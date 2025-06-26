part of 'get_inter_event_cubit.dart';

abstract class GetInterEventState {}

class GetInterEventInitial extends GetInterEventState {}

class GetInterEventLoading extends GetInterEventState {}

class GetInterEventLoaded extends GetInterEventState {
  final List<String> interestedEventIds;
  GetInterEventLoaded(this.interestedEventIds);
}

class GetInterEventError extends GetInterEventState {
  final String message;
  GetInterEventError(this.message);
}
