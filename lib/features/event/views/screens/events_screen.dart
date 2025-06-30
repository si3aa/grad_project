import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/core/route_manger/routes.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cubit/event_cubit.dart';
import '../../data/models/return_event.dart' as event_model;
import 'add_event_screen.dart';
import 'event_details_screen.dart';
import 'event_products_list_screen.dart';
import 'edit_event_screen.dart';
import 'package:Herfa/features/get-inter-event/viewmodels/get_interested_event_cubit.dart';
import 'package:Herfa/features/get-inter-event/data/get_interested_event_repository.dart';
import 'package:Herfa/features/get-inter-event/widgets/interested_event_card.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/get_me/current_user_cubit.dart';
import 'package:Herfa/features/get_me/my_user_model.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authDataSource = AuthSharedPrefLocalDataSource();
    return FutureBuilder<String?>(
      future: authDataSource.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(
                child: Text('Unable to load user token. Please login again.')),
          );
        }
        final token = snapshot.data!;
        return BlocProvider(
          create: (_) => GetInterestedEventCubit(
            repository: GetInterestedEventRepository(),
            token: token,
          )..fetchInterestedEvents(),
          child: BlocBuilder<CurrentUserCubit, CurrentUserState>(
            builder: (context, state) {
              String? userRole;
              if (state is CurrentUserLoaded) {
                userRole = state.user.role;
              }
              return _EventsScreenBody(userRole: userRole);
            },
          ),
        );
      },
    );
  }
}

class _EventsScreenBody extends StatelessWidget {
  final String? userRole;
  const _EventsScreenBody({Key? key, this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.homeRoute, (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.homeRoute, (route) => false);
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<EventCubit>().refreshEvents();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<GetInterestedEventCubit, GetInterestedEventState>(
                  builder: (context, state) {
                    if (state is GetInterestedEventLoaded) {
                      if (state.interestedEvents.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Icon(Icons.star_border,
                                  size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'You have no interested events yet.',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 16, bottom: 8),
                            child: Text(
                              'Your Interested Events',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: state.interestedEvents.length,
                              itemBuilder: (context, index) {
                                final event = state.interestedEvents[index];
                                return InterestedEventCard(
                                  event: event,
                                  onRemoveInterest: () {
                                    context
                                        .read<GetInterestedEventCubit>()
                                        .removeInterest(event['id'].toString());
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is GetInterestedEventLoading) {
                      return const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state is GetInterestedEventError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Text('Failed to load interested events.',
                                style: TextStyle(color: Colors.red)),
                            TextButton(
                              onPressed: () => context
                                  .read<GetInterestedEventCubit>()
                                  .fetchInterestedEvents(),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                BlocBuilder<EventCubit, EventState>(
                  builder: (context, state) {
                    if (state is EventLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is EventError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Oops! Something went wrong',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<EventCubit>().refreshEvents();
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Try Again'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is EventLoaded) {
                      if (state.events.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No events found',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddEventScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Create Your First Event'),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.events.length,
                        itemBuilder: (context, index) {
                          final event = state.events[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventProductsListScreen(
                                    eventId: event.id.toString(),
                                  ),
                                ),
                              );
                            },
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailsScreen(event: event),
                                ),
                              );
                            },
                            child: EventCard(event: event, userRole: userRole),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: userRole == 'USER'
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddEventScreen(),
                    ),
                  );
                },
                backgroundColor: kPrimaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final event_model.Data event;
  final String? userRole;

  const EventCard({
    Key? key,
    required this.event,
    this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GetInterestedEventCubit>();
    final isInterested = cubit.isEventInterested(event.id.toString());
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              event.media ?? '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                Text(
                  event.name ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Event Date and Location
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${_formatDate(event.startTime)} - ${_formatDate(event.endTime)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.money, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Price: \$${event.price?.toStringAsFixed(2) ?? 'N/A'}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isInterested) {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 28),
                                  SizedBox(width: 8),
                                  const Text('Remove Interest'),
                                ],
                              ),
                              content: const Text(
                                'Are you sure you want to remove this event from your interests?',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await cubit.removeInterest(event.id.toString());
                            await cubit.fetchInterestedEvents();
                          }
                        } else {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  Icon(Icons.star_border,
                                      color: Colors.amber, size: 28),
                                  SizedBox(width: 8),
                                  const Text('Add to Interest'),
                                ],
                              ),
                              content: const Text(
                                'Do you want to add this event to your interests?',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await cubit.addInterest(event.id.toString());
                            await cubit.fetchInterestedEvents();
                            context.read<EventCubit>().refreshEvents();
                          }
                        }
                      },
                      child: Icon(
                        isInterested ? Icons.star : Icons.star_border,
                        color: isInterested ? Colors.amber : Colors.grey,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Event Description
                Text(
                  event.description ?? 'No Description',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment_outlined, color: kPrimaryColor),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.eventCommentsRoute,
                          arguments: {'eventId': event.id.toString()},
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsScreen(event: event),
                          ),
                        );
                      },
                      child: const Text('View Details'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: userRole == 'USER'
                          ? null
                          : () => _showEventOptions(context, event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.more_horiz, size: 18),
                      label: const Text('More'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  void _showEventOptions(BuildContext context, event_model.Data event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Event Options',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Edit Option
              ListTile(
                leading: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                title: const Text('Edit Event'),
                subtitle: const Text('Modify event details'),
                onTap: () {
                  Navigator.pop(context);
                  _editEvent(context, event);
                },
              ),

              // Delete Option
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text('Delete Event'),
                subtitle: const Text('Remove this event permanently'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteEvent(context, event);
                },
              ),

              const SizedBox(height: 10),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editEvent(BuildContext context, event_model.Data event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(event: event),
      ),
    );
  }

  void _confirmDeleteEvent(BuildContext context, event_model.Data event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: Text(
            'Are you sure you want to delete "${event.name}"?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteEvent(context, event);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(BuildContext context, event_model.Data event) {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Deleting event...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    // Call the delete method from EventCubit
    context.read<EventCubit>().deleteEvent(event.id.toString());
  }
}
