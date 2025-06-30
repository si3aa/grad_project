import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/profile_cubit.dart';
import '../data/models/merchant_profile.dart';
import 'create_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Herfa/features/deals/views/all_buyer_deals_screen.dart';
import 'package:Herfa/features/deals/viewmodels/deal_cubit.dart';
import 'package:Herfa/features/deals/data/repository/deal_repository.dart';
import 'package:Herfa/features/deals/data/data_source/deal_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:Herfa/features/get_me/me_repository.dart';
import '../viewmodels/order_history_cubit.dart';
import 'order_card.dart';
import '../data/repository/profile_repository.dart';
import '../data/data_source/profile_remote_data_source.dart';
import 'refund_request_screen.dart';
import '../viewmodels/refund_request_cubit.dart';
import 'my_refund_requests_screen.dart';

class UserScreen extends StatelessWidget {
  final String token;
  final int userId;
  const UserScreen({Key? key, required this.token, required this.userId})
      : super(key: key);

  void _signOut(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove('token');
    await sharedPref.remove('userData');
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Drawer _buildDrawer(BuildContext context, String name, String bio,
      String? profilePictureUrl) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(bio, style: const TextStyle(fontSize: 14)),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  (profilePictureUrl != null && profilePictureUrl.isNotEmpty)
                      ? NetworkImage(profilePictureUrl)
                      : const AssetImage('assets/images/noprofile.png')
                          as ImageProvider,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('All Deals'),
            onTap: () async {
              final token = this.token;
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => BuyerDealsCubit(
                      DealRepository(
                        DealRemoteDataSource(Dio(BaseOptions(
                            baseUrl:
                                'https://zygotic-marys-herfa-c2dd67a8.koyeb.app'))),
                      ),
                    ),
                    child: AllDealsScreen(token: token),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.assignment_return, color: Color(0xFF7C5CFC)),
            title: const Text('Make Refund'),
            onTap: () async {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RefundRequestScreen(token: token),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long, color: Color(0xFF7C5CFC)),
            title: const Text('My Refund Requests'),
            onTap: () async {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyRefundRequestsScreen(token: token),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }

  // Modern wallet/loyalty card for user profile
  Widget _buildWalletLoyaltyCard() {
    return FutureBuilder(
      future: MeRepository().getMe(),
      builder: (context, snapshot) {
        print('FutureBuilder connectionState: \\${snapshot.connectionState}');
        print('FutureBuilder hasData: \\${snapshot.hasData}');
        print('FutureBuilder data: \\${snapshot.data}');
        print('FutureBuilder error: \\${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Card(
              color: Color(0xFF7C5CFC),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: SizedBox(
                height: 64,
                child: Center(
                    child: CircularProgressIndicator(color: Colors.white)),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print('FutureBuilder error: \\${snapshot.error}');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Card(
              color: const Color(0xFF7C5CFC),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: SizedBox(
                height: 64,
                child: Center(
                  child: Text('Failed to load balance',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          );
        } else {
          final data = snapshot.data;
          final walletBalance = data?.walletBalance;
          final loyaltyPoints = data?.loyaltyPoints;
          print(
              'walletBalance: \\${walletBalance}, loyaltyPoints: \\${loyaltyPoints}');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Card(
              color: const Color(0xFF7C5CFC),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Wallet (left)
                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Wallet',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            Text(
                              walletBalance != null
                                  ? '\$${walletBalance}'
                                  : '--',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Loyalty (right)
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Coins',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            Text(
                              loyaltyPoints != null
                                  ? loyaltyPoints.toString()
                                  : '--',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.stars, color: Colors.amber, size: 22),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ProfileCubit>(context)
        ..fetchUserProfile(token, userId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(' Profile',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoaded) {
              final user = state.userProfile;
              return _buildDrawer(context, '${user.firstName} ${user.lastName}',
                  user.bio, user.profilePictureUrl);
            }
            return const SizedBox.shrink();
          },
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.red)));
            } else if (state is UserProfileLoaded) {
              final user = state.userProfile;
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  _buildWalletLoyaltyCard(),
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: user.profilePictureUrl != null &&
                              user.profilePictureUrl!.isNotEmpty
                          ? NetworkImage(user.profilePictureUrl!)
                          : const AssetImage('assets/images/noprofile.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      user.bio,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C5CFC),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                      ),
                      label: const Text('Edit Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateProfileScreen(
                                token: token, profile: null),
                            settings:
                                RouteSettings(arguments: {'userId': userId}),
                          ),
                        );
                        if (updated == true) {
                          // Refresh user profile after editing
                          context
                              .read<ProfileCubit>()
                              .fetchUserProfile(token, userId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated!')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // --- Order History Section ---
                  BlocProvider(
                    create: (_) => OrderHistoryCubit(
                        ProfileRepository(ProfileRemoteDataSource()))
                      ..fetchAllOrders(token),
                    child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                      builder: (context, state) {
                        if (state is OrderHistoryLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is OrderHistoryError) {
                          return Center(
                              child: Text(state.message,
                                  style: TextStyle(color: Colors.red)));
                        } else if (state is OrderHistoryLoaded) {
                          final orders = state.orders;
                          if (orders.isEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  Icon(Icons.inbox,
                                      size: 48, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  const Text('No orders yet',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text('My Orders',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              ...orders
                                  .map((order) => OrderCard(order: order))
                                  .toList(),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  // --- End Order History Section ---
                ],
              );
            } else if (state is ProfileNotFound) {
              return Center(
                child: Text('No profile found. Please create your profile.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 18)),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
