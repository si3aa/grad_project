import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/comment_model.dart';
import '../data/repository/comment_repository.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentModel> comments;
  CommentLoaded(this.comments);
}

class CommentError extends CommentState {
  final String message;
  CommentError(this.message);
}

class CommentPosting extends CommentState {}

class CommentPosted extends CommentState {}

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository repository;
  CommentCubit(this.repository) : super(CommentInitial());

  Future<void> fetchComments(String productId) async {
    emit(CommentLoading());
    try {
      final comments = await repository.fetchComments(productId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError('Failed to load comments'));
    }
  }

  Future<void> postComment(String productId, String content) async {
    emit(CommentPosting());
    try {
      final success = await repository.postComment(productId, content);
      if (success) {
        emit(CommentPosted());
        await fetchComments(productId); // Refresh comments
      } else {
        emit(CommentError('Failed to post comment'));
      }
    } catch (e) {
      emit(CommentError('Failed to post comment'));
    }
  }

  Future<void> deleteComment(String productId, String commentId) async {
    emit(CommentLoading()); // Or a new state like CommentDeleting
    try {
      final success = await repository.deleteComment(commentId);
      if (success) {
        // After successful deletion, refetch comments to update UI
        await fetchComments(productId);
      } else {
        emit(CommentError('Failed to delete comment'));
      }
    } catch (e) {
      emit(CommentError('Failed to delete comment'));
    }
  }
}
