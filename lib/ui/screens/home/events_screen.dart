import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/cubit/event_cubit.dart';
import 'package:Herfa/ui/widgets/home/event_card.dart';
import 'package:Herfa/ui/widgets/home/featured_event_card.dart';
import 'package:Herfa/ui/widgets/home/workshop_card.dart';
import 'package:Herfa/core/utils/responsive.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EventsCubit>().fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildFeaturedEvents(),
            SizedBox(height: 16),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryTabs(),
                    _buildSectionTitle("Events"),
                    _buildEventsGrid(),
                    _buildSectionTitle("Workshops"),
                    _buildWorkshopsGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            color: kPrimaryColor,
          ),
          const Spacer(),
          const Text(
            "Events",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: "Search in events",
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.filter_list),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildCategoryTab(
                    "For you", EventCategory.forYou, state.selectedCategory),
                const SizedBox(width: 16),
                _buildCategoryTab(
                    "Local", EventCategory.local, state.selectedCategory),
                const SizedBox(width: 16),
                _buildCategoryTab("This week", EventCategory.thisWeek,
                    state.selectedCategory),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedEvents() {
    return SizedBox(
      height: 150,
      child: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: state.featuredEvents.length,
            itemBuilder: (context, index) {
              return FeaturedEventCard(event: state.featuredEvents[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEventsGrid() {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        final filteredEvents = state.events
            .where((event) => event.category == state.selectedCategory)
            .toList();
        return _buildGrid(filteredEvents, (event) => EventCard(event: event));
      },
    );
  }

  /// Workshops grid
  Widget _buildWorkshopsGrid() {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        return _buildGrid(
            state.workshops, (workshop) => WorkshopCard(workshop: workshop));
      },
    );
  }

  Widget _buildGrid<T>(List<T> items, Widget Function(T) itemBuilder) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(items[index]);
      },
    );
  }

  Widget _buildCategoryTab(
      String title, EventCategory category, EventCategory selectedCategory) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () => context.read<EventsCubit>().selectCategory(category),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? kPrimaryColor : Colors.grey,
        ),
      ),
    );
  }
}
