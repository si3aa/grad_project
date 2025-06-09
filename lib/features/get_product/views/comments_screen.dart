import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/comment_repository.dart';
import '../viewmodels/comment_cubit.dart';
import '../data/models/comment_model.dart';
import 'package:intl/intl.dart';

class CommentsScreen extends StatefulWidget {
  final String productId;
  const CommentsScreen({super.key, required this.productId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();
  late CommentCubit _cubit;
  String? _commentToEditId; // To store the ID of the comment being edited

  @override
  void initState() {
    super.initState();
    _cubit = CommentCubit(CommentRepository());
    _cubit.fetchComments(widget.productId);
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.close();
    super.dispose();
  }

  void _postOrUpdateComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (_commentToEditId != null) {
      // Delete old comment and post new one
      final oldCommentId = _commentToEditId!;
      _commentToEditId = null; // Exit edit mode immediately

      _cubit.deleteComment(widget.productId, oldCommentId).then((_) {
        // After deletion, post the new comment
        _cubit.postComment(widget.productId, text);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to delete old comment: $error'),
              backgroundColor: Colors.red),
        );
      });
    } else {
      // Post new comment
      _cubit.postComment(widget.productId, text);
    }
    FocusScope.of(context).unfocus();
    _controller.clear(); // Clear the text field after action
  }

  // Method to handle edit option: pre-fill text field and set edit mode
  void _prepareEdit(CommentModel comment) {
    setState(() {
      _controller.text = comment.content;
      _commentToEditId = comment.id.toString();
    });
    // Optionally scroll to the input field if it's not visible
    // Scrollable.ensureVisible(context.findRenderObject() as RenderBox);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          leading: BackButton(),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<CommentCubit, CommentState>(
                builder: (context, state) {
                  if (state is CommentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CommentLoaded) {
                    if (state.comments.isEmpty) {
                      return const Center(child: Text('No comments yet.'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.comments.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final CommentModel comment = state.comments[index];
                        return GestureDetector(
                          onLongPress: () =>
                              _showCommentOptions(context, comment),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[300],
                                    child: const Icon(Icons.person,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.userName?.isNotEmpty == true
                                              ? comment.userName!
                                              : 'User',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          comment.content,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 12),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            _formatDate(comment.createdAt),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CommentError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            BlocConsumer<CommentCubit, CommentState>(
              listener: (context, state) {
                if (state is CommentPosted) {
                  _controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Comment posted!'),
                        backgroundColor: Colors.green),
                  );
                } else if (state is CommentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                final isPosting = state is CommentPosting;
                return SafeArea(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              controller: _controller,
                              enabled: !isPosting,
                              decoration: InputDecoration(
                                hintText: _commentToEditId != null
                                    ? 'Editing comment...'
                                    : 'Add a comment...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                              onSubmitted: (_) => _postOrUpdateComment(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        isPosting
                            ? const SizedBox(
                                width: 28,
                                height: 28,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                      _commentToEditId != null
                                          ? Icons.check
                                          : Icons.send,
                                      color: Colors.white),
                                  onPressed: _postOrUpdateComment,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  void _showCommentOptions(BuildContext context, CommentModel comment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blueAccent),
                title: const Text('Edit Comment'),
                onTap: () {
                  Navigator.pop(bc); // Close the bottom sheet
                  _prepareEdit(comment); // Prepare the text field for editing
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text('Delete Comment'),
                onTap: () {
                  Navigator.pop(bc); // Close the bottom sheet
                  _deleteComment(
                      context, comment.id.toString()); // Handle delete logic
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteComment(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _cubit.deleteComment(
                    widget.productId, commentId); // Call cubit method to delete
              },
            ),
          ],
        );
      },
    );
  }
}
