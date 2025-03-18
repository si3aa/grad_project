import 'package:flutter_bloc/flutter_bloc.dart';

enum EventCategory { forYou, local, thisWeek }

class EventsCubit extends Cubit<EventsState> {
  EventsCubit()
      : super(EventsLoaded(
          events: const [],
          featuredEvents: const [],
          workshops: const [],
          selectedCategory: EventCategory.forYou,
        ));

  void fetchEvents() {
    final events = [
      Event(
        id: 1,
        title: "From Clay to Masterpiece",
        date: "Sat, 8 Mar 2025",
        imageUrl: "assets/images/event.png",
        category: EventCategory.forYou,
      ),
      Event(
        id: 2,
        title: "From Clay to Masterpiece",
        date: "Mon, 10 Mar 2025",
        imageUrl: "assets/images/event.png",
        category: EventCategory.local,
      ),
      Event(
        id: 2,
        title: "From Clay to Masterpiece",
        date: "Mon, 10 Mar 2025",
        imageUrl: "assets/images/event.png",
        category: EventCategory.local,
      ),
      Event(
        id: 3,
        title: "From Clay to Masterpiece",
        date: "Mon, 10 Mar 2025",
        imageUrl: "assets/images/event.png",
        category: EventCategory.thisWeek,
      ),
    ];

    final featuredEvents = [
      FeaturedEvent(
        id: 1,
        title: "Weave & Craft: Palm Craft Workshop",
        location: "Shebin El Kom, Menoufia, Egypt",
        imageUrl: "assets/images/event.png",
        isInterested: true,
      ),
      FeaturedEvent(
        id: 1,
        title: "Weave & Craft: Palm Craft Workshop",
        location: "Shebin El Kom, Menoufia, Egypt",
        imageUrl: "assets/images/event.png",
        isInterested: true,
      ),
      FeaturedEvent(
        id: 2,
        title: "Weave & Craft: Palm Craft Workshop",
        location: "Shebin El Kom, Menoufia, Egypt",
        imageUrl: "assets/images/event.png",
        isInterested: false,
      ),
    ];

    final workshops = [
      Workshop(
        id: 1,
        title: "Clay Crafting Basics",
        date: "Sat, 8 Mar 2025",
        imageUrl: "assets/images/event.png",
        
      ),
      Workshop(
        id: 2,
        title: "Advanced Pottery Techniques",
        date: "Mon, 10 Mar 2025",
        imageUrl: "assets/images/event.png",
      ),
    ];

    emit(EventsLoaded(
      events: events,
      featuredEvents: featuredEvents,
      workshops: workshops,
      selectedCategory: EventCategory.forYou,
    ));
  }

  void selectCategory(EventCategory category) {
    emit(EventsLoaded(
      events: state.events,
      featuredEvents: state.featuredEvents,
      workshops: state.workshops,
      selectedCategory: category,
    ));
  }
}

class EventsState {
  final List<Event> events;
  final List<FeaturedEvent> featuredEvents;
  final List<Workshop> workshops;
  final EventCategory selectedCategory;

  EventsState({
    this.events = const [],
    this.featuredEvents = const [],
    this.workshops = const [],
    this.selectedCategory = EventCategory.forYou,
  });
}

class EventsLoaded extends EventsState {
  EventsLoaded({
    required List<Event> events,
    required List<FeaturedEvent> featuredEvents,
    required List<Workshop> workshops,
    required EventCategory selectedCategory,
  }) : super(
          events: events,
          featuredEvents: featuredEvents,
          workshops: workshops,
          selectedCategory: selectedCategory,
        );
}

class Event {
  final int id;
  final String title;
  final String date;
  final String imageUrl;
  final EventCategory category;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.category,
  });
}

class FeaturedEvent {
  final int id;
  final String title;
  final String location;
  final String imageUrl;
  final bool isInterested;

  FeaturedEvent({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.isInterested,
  });
}

class Workshop {
  final int id;
  final String title;
  final String date;
  final String imageUrl;

  Workshop({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
  });
}