part of 'get_interested_event_cubit.dart';

abstract class GetInterestedEventState {}

class GetInterestedEventInitial extends GetInterestedEventState {}

class GetInterestedEventLoading extends GetInterestedEventState {}

class GetInterestedEventLoaded extends GetInterestedEventState {
  final List<dynamic> interestedEvents;
  GetInterestedEventLoaded(this.interestedEvents);
}

class GetInterestedEventError extends GetInterestedEventState {
  final String message;
  GetInterestedEventError(this.message);
}
