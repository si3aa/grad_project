import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:Herfa/constants.dart'; // Assuming kPrimaryColor is defined here
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'dart:developer' as developer;

class CommentsScreen extends StatefulWidget {
  final String productId;

  const CommentsScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _editingCommentId;
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchComments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _authDataSource.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Please login to view comments.';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/comments/product/${widget.productId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          final List<dynamic> commentData = responseData['data'];
          setState(() {
            _comments = commentData
                .map((commentJson) => Comment.fromJson(commentJson))
                .toList();
          });
        } else {
          setState(() {
            _errorMessage =
                responseData['message'] ?? 'Failed to load comments';
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Error ${response.statusCode}: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String commentContent = _commentController.text;
    _commentController.clear(); // Clear input field immediately

    if (_editingCommentId != null) {
      await _deleteComment(_editingCommentId!);
      setState(() {
        _editingCommentId = null;
      });
    }

    try {
      final token = await _authDataSource.getToken();
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to add a comment.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final response = await http.post(
        Uri.parse(
            'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/comments?productId=${widget.productId}&content=$commentContent'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          _fetchComments();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Failed to add comment'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error ${response.statusCode}: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  void _showCommentOptions(Comment comment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
        );
      },
    );
  }

  Future<void> _deleteComment(int commentId) async {
    try {
      final token = await _authDataSource.getToken();
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to delete comments.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final response = await http.delete(
        Uri.parse(
            'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/comments/$commentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          _fetchComments();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(responseData['message'] ?? 'Failed to delete comment'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error ${response.statusCode}: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog(int commentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _deleteComment(commentId); // Proceed with deletion
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : _comments.isEmpty
                        ? const Center(
                            child: Text(
                                'No comments yet. Be the first to comment!'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: _comments.length,
                            itemBuilder: (context, index) {
                              final comment = _comments[index];
                              return GestureDetector(
                                onLongPress: () => _showCommentOptions(comment),
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            if (comment.userImage != null &&
                                                comment.userImage!.isNotEmpty)
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundImage: NetworkImage(
                                                    comment.userImage!),
                                              )
                                            else
                                              const CircleAvatar(
                                                radius: 16,
                                                backgroundColor: Colors.grey,
                                                child: Icon(Icons.person,
                                                    size: 20,
                                                    color: Colors.white),
                                              ),
                                            const SizedBox(width: 10.0),
                                            Text(
                                              comment.userName ?? 'Anonymous',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          comment.content,
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black87,
                                              height: 1.4),
                                        ),
                                        const SizedBox(height: 12.0),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            _formatDate(comment.createdAt),
                                            style: const TextStyle(
                                              fontSize: 11.0,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _addComment,
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Comment {
  final int id;
  final String content;
  final String createdAt;
  final String? userName;
  final String? userImage;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    this.userName,
    this.userImage,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    developer.log('Parsing comment JSON: $json', name: 'Comment.fromJson');
    try {
      return Comment(
        id: json['id'],
        content: json['content'],
        createdAt: json['createdAt'],
        userName: json['user']
            ?['username'], // Using null-aware operator for safety
        userImage: json['user']
            ?['image'], // Using null-aware operator for safety
      );
    } catch (e) {
      developer.log('Error parsing comment JSON: $e, JSON: $json',
          name: 'Comment.fromJson', error: e);
      rethrow; // Re-throw to propagate the error if necessary
    }
  }
}
