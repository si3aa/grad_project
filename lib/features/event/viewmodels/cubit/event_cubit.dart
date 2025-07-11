import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:Herfa/features/event/data/models/return_event.dart';
import '../../data/repositories/event_repository.dart';
import 'dart:io';
import 'package:Herfa/features/event/data/models/event_model.dart';

// States
abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Data> events;

  const EventLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class EventCubit extends Cubit<EventState> {
  final EventRepository _eventRepository;

  EventCubit(this._eventRepository) : super(EventInitial()) {
    loadEvents(); // Automatically load events when the cubit is created
  }

  Future<void> loadEvents() async {
    try {
      print('EventCubit: Starting to load events...');
      emit(EventLoading());
      final events = await _eventRepository.getEvents();
      print('EventCubit: Successfully loaded ${events.length} events');
      emit(EventLoaded(events));
    } catch (e) {
      print('EventCubit: Error loading events: $e');
      String errorMessage = 'Failed to load events';

      if (e.toString().contains('UnauthorizedException')) {
        errorMessage = 'Please log in again to view events';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Events service is currently unavailable';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later';
      } else if (e.toString().contains('Network')) {
        errorMessage = 'Network error. Please check your connection';
      } else {
        errorMessage = e.toString();
      }

      emit(EventError(errorMessage));
    }
  }

  Future<void> createEvent(EventModel event, File image) async {
    try {
      print('EventCubit: Starting event creation...');
      emit(EventLoading());

      final createdEvent = await _eventRepository.createEvent(event, image);
      print('EventCubit: Event created successfully');

      // Add the new event to the current list
      final currentState = state;
      if (currentState is EventLoaded) {
        final updatedEvents = [...currentState.events, createdEvent];
        print(
            'EventCubit: Added event to existing list. Total events: ${updatedEvents.length}');
        emit(EventLoaded(updatedEvents));
      } else {
        print('EventCubit: Created first event');
        emit(EventLoaded([createdEvent]));
      }
    } catch (e) {
      print('EventCubit: Error creating event: $e');
      String errorMessage = 'Failed to create event';

      if (e.toString().contains('UnauthorizedException')) {
        errorMessage = 'Please log in again to create events';
      } else if (e.toString().contains('Access forbidden')) {
        errorMessage = 'You don\'t have permission to create events';
      } else if (e.toString().contains('Validation error')) {
        errorMessage = 'Please check your input data';
      } else if (e.toString().contains('Network')) {
        errorMessage = 'Network error. Please check your connection';
      } else if (e.toString().contains('Server error')) {
        errorMessage = 'Server error. Please try again later';
      } else {
        errorMessage = e.toString();
      }

      emit(EventError(errorMessage));
    }
  }

  Future<void> updateEvent(EventModel event) async {
    try {
      emit(EventLoading());
      await _eventRepository.updateEvent(event);
      await loadEvents(); // Reload events after updating
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> refreshEvents() async {
    print('EventCubit: Refreshing events...');
    await loadEvents();
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      emit(EventLoading());
      await _eventRepository.deleteEvent(eventId);
      await loadEvents(); // Reload events after deleting
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
