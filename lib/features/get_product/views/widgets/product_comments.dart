import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/features/comments/data/models/comment_model.dart';
import 'package:Herfa/features/comments/viewmodels/comment_cubit.dart';

class ProductComments extends StatefulWidget {
  final String productId;

  const ProductComments({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductComments> createState() => _ProductCommentsState();
}

class _ProductCommentsState extends State<ProductComments> {
  final TextEditingController _commentController = TextEditingController();
  bool _isPostingComment = false;

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
    context.read<CommentCubit>().fetchComments(widget.productId);
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildCommentItem(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              _buildUserAvatar(comment),
              const SizedBox(width: 12),
              // Comment Content
              Expanded(
                child: _buildCommentContent(comment),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(CommentModel comment) {
    final initial = comment.userFirstName.isNotEmpty
        ? comment.userFirstName[0].toUpperCase()
        : comment.userLastName.isNotEmpty
            ? comment.userLastName[0].toUpperCase()
            : '?';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: kPrimaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentContent(CommentModel comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Name
        Row(
          children: [
            Text(
              comment.userFirstName.trim(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              comment.userLastName.trim()[0].toUpperCase() + comment.userLastName.trim().substring(1).toLowerCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Comment Date
        Text(
          _formatDate(comment.createdAt),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        // Comment Text
        Text(
          comment.content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit, CommentState>(
      builder: (context, state) {
        return Column(
          children: [
            // Comments List
            if (state is CommentLoading)
              const Center(child: CircularProgressIndicator())
            else if (state is CommentLoaded)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.comments.length,
                itemBuilder: (context, index) => _buildCommentItem(state.comments[index]),
              )
            else if (state is CommentError)
              Center(child: Text(state.message))
            else
              const SizedBox.shrink(),

            // Comment Input
            _buildCommentInput(),
          ],
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (!_isPostingComment)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitComment,
              color: kPrimaryColor,
            )
          else
            const SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isPostingComment = true);

    try {
      final success = await context.read<CommentCubit>().postComment(
        widget.productId,
        _commentController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        _commentController.clear();
        _loadComments();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to post comment. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPostingComment = false);
      }
    }
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}
