import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:Herfa/constants.dart';
import '../data/models/event_comment_model.dart';
import '../viewmodels/event_comment_cubit.dart';

class EventCommentsScreen extends StatefulWidget {
  final String eventId;

  const EventCommentsScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventCommentsScreen> createState() => _EventCommentsScreenState();
}

class _EventCommentsScreenState extends State<EventCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  int? _editingCommentId;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _loadComments() {
    context.read<EventCommentCubit>().fetchComments(widget.eventId);
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString).toLocal().add(const Duration(hours: 3));
      return DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  void _submitComment() {
    final content = _commentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_editingCommentId != null) {
      context.read<EventCommentCubit>().editComment(widget.eventId, _editingCommentId.toString(), content);
      setState(() => _editingCommentId = null);
    } else {
      context.read<EventCommentCubit>().postComment(widget.eventId, content);
    }
    
    _commentController.clear();
  }

  void _showCommentOptions(EventCommentModel comment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Comment'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _commentController.text = comment.content;
                  _editingCommentId = comment.id;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Comment'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(comment.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<EventCommentCubit>().deleteComment(
                    widget.eventId,
                    commentId.toString(),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentList(List<EventCommentModel> comments) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: comments.length,
      itemBuilder: (context, index) => _CommentItem(
        comment: comments[index],
        onLongPress: _showCommentOptions,
        formatDate: _formatDate,
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              onPressed: _submitComment,
              icon: const Icon(Icons.send, color: Colors.white),
              tooltip: 'Send comment',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Event Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<EventCommentCubit, EventCommentState>(
              builder: (context, state) {
                if (state is EventCommentLoading) {
                  return const _LoadingState();
                }
                if (state is EventCommentError) {
                  return _ErrorState(message: state.message);
                }
                if (state is EventCommentLoaded) {
                  if (state.comments.isEmpty) {
                    return const _EmptyState();
                  }
                  return _buildCommentList(state.comments);
                }
                return const Center(child: Text('No comments yet'));
              },
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: kPrimaryColor),
          const SizedBox(height: 16),
          const Text(
            'Loading comments...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.red[300], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to comment!',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final EventCommentModel comment;
  final Function(EventCommentModel) onLongPress;
  final String Function(String) formatDate;

  const _CommentItem({
    required this.comment,
    required this.onLongPress,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onLongPress(comment),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    // ignore: deprecated_member_use
                    backgroundColor: kPrimaryColor.withOpacity(0.1),
                    child: Text(
                      (comment.userFirstName?.isNotEmpty ?? false)
                          ? comment.userFirstName![0].toUpperCase()
                          : 'A',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (comment.userFirstName?.isNotEmpty ?? false) ...[
                              Text(
                                comment.userFirstName!.trim(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            if (comment.userLastName?.isNotEmpty ?? false)
                              Text(
                                comment.userLastName![0].toUpperCase() +
                                comment.userLastName!.substring(1).toLowerCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            else if (comment.userFirstName?.isEmpty ?? true)
                              const Text(
                                'Anonymous',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          formatDate(comment.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                comment.content,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

