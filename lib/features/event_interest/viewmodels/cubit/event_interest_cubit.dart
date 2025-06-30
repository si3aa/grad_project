import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/event_interest/viewmodels/cubit/event_interest_state.dart';
import '../../data/repositories/event_interest_repository.dart';

class EventInterestCubit extends Cubit<EventInterestState> {
  final EventInterestRepository _interestRepository;
  final Map<String, bool> _interestCache = {};

  EventInterestCubit(this._interestRepository) : super(EventInterestInitial());

  Future<void> toggleInterest(String eventId) async {
    try {
      emit(EventInterestLoading());
      
      final currentStatus = _interestCache[eventId] ?? 
                          await _interestRepository.getInterestStatus(eventId);
      
      bool success;
      if (currentStatus) {
        success = await _interestRepository.removeInterest(eventId);
      } else {
        success = await _interestRepository.addInterest(eventId);
      }

      if (success) {
        _interestCache[eventId] = !currentStatus;
        emit(EventInterestSuccess(
          isInterested: !currentStatus,
          eventId: eventId,
        ));
      } else {
        emit(const EventInterestError('Failed to update interest status'));
      }
    } catch (e) {
      emit(EventInterestError(e.toString()));
    }
  }

  Future<void> checkInterestStatus(String eventId) async {
    try {
      if (!_interestCache.containsKey(eventId)) {
        final isInterested = await _interestRepository.getInterestStatus(eventId);
        _interestCache[eventId] = isInterested;
      }
      
      emit(EventInterestSuccess(
        isInterested: _interestCache[eventId]!,
        eventId: eventId,
      ));
    } catch (e) {
      emit(EventInterestError(e.toString()));
    }
  }

  bool? getInterestStatus(String eventId) {
    return _interestCache[eventId];
  }

  void clearCache() {
    _interestCache.clear();
  }
}
