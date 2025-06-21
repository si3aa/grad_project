import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/event_comment_model.dart';
import '../data/repositories/event_comment_repository.dart';
import 'dart:developer' as developer;

abstract class EventCommentState {}

class EventCommentInitial extends EventCommentState {}

class EventCommentLoading extends EventCommentState {}

class EventCommentLoaded extends EventCommentState {
  final List<EventCommentModel> comments;
  EventCommentLoaded(this.comments);
}

class EventCommentError extends EventCommentState {
  final String message;
  EventCommentError(this.message);
}

class EventCommentPosting extends EventCommentState {}

class EventCommentPosted extends EventCommentState {}

class EventCommentCubit extends Cubit<EventCommentState> {
  final EventCommentRepository repository;
  EventCommentCubit(this.repository) : super(EventCommentInitial());

  Future<void> fetchComments(String eventId) async {
    emit(EventCommentLoading());
    try {
      developer.log('Fetching comments for event: $eventId',
          name: 'EventCommentCubit');
      final comments = await repository.fetchComments(eventId);
      developer.log('Fetched ${comments.length} comments',
          name: 'EventCommentCubit');
      emit(EventCommentLoaded(comments));
    } catch (e) {
      developer.log('Error fetching comments: $e', name: 'EventCommentCubit');
      emit(EventCommentError('Failed to load comments: $e'));
    }
  }

  Future<void> postComment(String eventId, String content) async {
    emit(EventCommentPosting());
    try {
      final success = await repository.postComment(eventId, content);
      if (success) {
        emit(EventCommentPosted());
        await fetchComments(eventId); // Refresh comments
      } else {
        emit(EventCommentError('Failed to post comment'));
      }
    } catch (e) {
      developer.log('Error posting comment: $e', name: 'EventCommentCubit');
      emit(EventCommentError('Failed to post comment: $e'));
    }
  }

  Future<void> deleteComment(String eventId, String commentId) async {
    emit(EventCommentLoading());
    try {
      final success = await repository.deleteComment(eventId, commentId);
      if (success) {
        await fetchComments(eventId); // Refresh comments after deletion
      } else {
        emit(EventCommentError('Failed to delete comment'));
      }
    } catch (e) {
      developer.log('Error deleting comment: $e', name: 'EventCommentCubit');
      emit(EventCommentError('Failed to delete comment: $e'));
    }
  }

  Future<void> editComment(String eventId, String commentId, String content) async {
    emit(EventCommentLoading());
    try {
      final success = await repository.editComment(eventId, commentId, content);
      if (success) {
        await fetchComments(eventId); // Refresh comments after editing
      } else {
        emit(EventCommentError('Failed to edit comment'));
      }
    } catch (e) {
      developer.log('Error editing comment: $e', name: 'EventCommentCubit');
      emit(EventCommentError('Failed to edit comment: $e'));
    }
  }
}
