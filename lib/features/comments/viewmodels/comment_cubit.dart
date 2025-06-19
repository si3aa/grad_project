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

class CommentDeleting extends CommentState {}

class CommentDeleted extends CommentState {}

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository repository;

  CommentCubit(this.repository) : super(CommentInitial());

  Future<void> fetchComments(String productId) async {
    emit(CommentLoading());
    try {
      final comments = await repository.fetchComments(productId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError('Failed to load comments: $e'));
    }
  }

  Future<bool> postComment(String productId, String content) async {
    emit(CommentPosting());
    try {
      final success = await repository.postComment(productId, content);
      if (success) {
        emit(CommentPosted());
        await fetchComments(productId);
        return true;
      } else {
        emit(CommentError('Failed to post comment'));
        return false;
      }
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception:', '').trim();
      emit(CommentError(errorMessage));
      return false;
    }
  }

  Future<bool> updateComment(String commentId, String newContent) async {
    try {
      final success = await repository.updateComment(commentId, newContent);
      if (success) {
        // Emit loading state to show refresh
        emit(CommentLoading());
        return true;
      } else {
        emit(CommentError('Failed to update comment'));
        return false;
      }
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception:', '').trim();
      emit(CommentError(errorMessage));
      return false;
    }
  }

  Future<bool> deleteComment(String commentId, {String? productId}) async {
    emit(CommentDeleting());
    try {
      final success = await repository.deleteComment(commentId);

      if (success) {
        emit(CommentDeleted());

        // If productId is provided, refresh the comments list
        if (productId != null) {
          await fetchComments(productId);
        }
        return true;
      } else {
        emit(CommentError('Failed to delete comment'));
        return false;
      }
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception:', '').trim();
      emit(CommentError(errorMessage));
      return false;
    }
  }
}
