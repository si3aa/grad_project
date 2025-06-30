import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/get_interested_event_repository.dart';

part 'get_interested_event_state.dart';

class GetInterestedEventCubit extends Cubit<GetInterestedEventState> {
  final GetInterestedEventRepository repository;
  final String token;
  List<dynamic> interestedEvents = [];

  GetInterestedEventCubit({required this.repository, required this.token})
      : super(GetInterestedEventInitial());

  Future<void> fetchInterestedEvents() async {
    emit(GetInterestedEventLoading());
    try {
      interestedEvents = await repository.fetchInterestedEvents(token);
      if (!isClosed) emit(GetInterestedEventLoaded(interestedEvents));
    } catch (e) {
      if (!isClosed) emit(GetInterestedEventError(e.toString()));
    }
  }

  Future<void> removeInterest(String eventId) async {
    emit(GetInterestedEventLoading());
    try {
      final success = await repository.removeInterest(eventId, token);
      if (success) {
        interestedEvents
            .removeWhere((event) => event['id'].toString() == eventId);
        if (!isClosed) emit(GetInterestedEventLoaded(interestedEvents));
      } else {
        if (!isClosed)
          emit(GetInterestedEventError('Failed to remove interest'));
      }
    } catch (e) {
      if (!isClosed) emit(GetInterestedEventError(e.toString()));
    }
  }

  Future<void> addInterest(String eventId) async {
    emit(GetInterestedEventLoading());
    try {
      final event = await repository.addInterest(eventId, token);
      if (event != null) {
        await fetchInterestedEvents();
      } else {
        if (!isClosed) emit(GetInterestedEventError('Failed to add interest'));
      }
    } catch (e) {
      if (!isClosed) emit(GetInterestedEventError(e.toString()));
    }
  }

  bool isEventInterested(String eventId) {
    return interestedEvents.any((event) => event['id'].toString() == eventId);
  }
}
