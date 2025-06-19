import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/cubit/notification_cubit.dart';
import 'package:Herfa/ui/widgets/home/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/core/utils/responsive.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () =>  Navigator.pushReplacementNamed(context, '/home'),
                        color: kPrimaryColor,
                      ),
                      const Spacer(),
                      const Text(
                        "Notification",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context
                            .read<NotificationCubit>()
                            .filterByCategory(null),
                        child: Text(
                          "General",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: context
                                        .read<NotificationCubit>()
                                        .state
                                        .selectedCategory ==
                                    null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3.0),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context
                                  .read<NotificationCubit>()
                                  .filterByCategory(
                                      NotificationCategory.recommended),
                              child: Text(
                                "Recommended",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: context
                                              .read<NotificationCubit>()
                                              .state
                                              .selectedCategory ==
                                          NotificationCategory.recommended
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.orange,
                              child: Text(
                                "12",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Notification List or No Notification Message
                Expanded(
                  child: BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                      if (state is NotificationLoaded) {
                        final notificationsToShow =
                            state.filteredNotifications ?? [];
                        if (notificationsToShow.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/notification.dart.png',
                                  height: Responsive.isMobile(context)
                                      ? 150
                                      : Responsive.isTablet(context)
                                          ? 200
                                          : 250,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "You don’t have any notificationat this time!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: notificationsToShow.length,
                          itemBuilder: (context, index) {
                            return NotificationItemWidget(
                              notification: notificationsToShow[index],
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
