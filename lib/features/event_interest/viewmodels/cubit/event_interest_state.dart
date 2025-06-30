import 'package:equatable/equatable.dart';

abstract class EventInterestState extends Equatable {
  const EventInterestState();

  @override
  List<Object> get props => [];
}

class EventInterestInitial extends EventInterestState {}

class EventInterestLoading extends EventInterestState {}

class EventInterestSuccess extends EventInterestState {
  final bool isInterested;
  final String eventId;

  const EventInterestSuccess({
    required this.isInterested,
    required this.eventId,
  });

  @override
  List<Object> get props => [isInterested, eventId];
}

class EventInterestError extends EventInterestState {
  final String message;

  const EventInterestError(this.message);

  @override
  List<Object> get props => [message];
}
