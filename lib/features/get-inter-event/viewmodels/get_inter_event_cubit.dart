import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/get_inter_event_repository.dart';

part 'get_inter_event_state.dart';

class GetInterEventCubit extends Cubit<GetInterEventState> {
  final GetInterEventRepository _repository;
  List<String> _interestedEventIds = [];

  GetInterEventCubit(this._repository) : super(GetInterEventInitial());

  List<String> get interestedEventIds => _interestedEventIds;

  Future<void> fetchInterestedEvents() async {
    emit(GetInterEventLoading());
    try {
      _interestedEventIds = await _repository.getInterestedEventIds();
      emit(GetInterEventLoaded(_interestedEventIds));
    } catch (e) {
      emit(GetInterEventError(e.toString()));
    }
  }

  Future<void> addInterest(String eventId) async {
    try {
      final success = await _repository.addInterest(eventId);
      if (success) {
        _interestedEventIds.add(eventId);
        emit(GetInterEventLoaded(List.from(_interestedEventIds)));
      }
    } catch (e) {
      emit(GetInterEventError(e.toString()));
    }
  }

  Future<void> removeInterest(String eventId) async {
    try {
      final success = await _repository.removeInterest(eventId);
      if (success) {
        _interestedEventIds.remove(eventId);
        emit(GetInterEventLoaded(List.from(_interestedEventIds)));
      }
    } catch (e) {
      emit(GetInterEventError(e.toString()));
    }
  }

  bool isInterested(String eventId) {
    return _interestedEventIds.contains(eventId);
  }
}
