import 'package:flutter/material.dart';
import 'package:Herfa/core/constant.dart';
import '../data/models/merchant_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/profile_cubit.dart';
import './create_profile_screen.dart';
import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/features/coupons/viewmodels/cubit/coupon_cubit.dart';
import 'package:Herfa/features/deals/views/all_seller_deals_screen.dart';
import 'package:Herfa/features/deals/viewmodels/deal_cubit.dart';
import 'package:Herfa/features/deals/data/repository/deal_repository.dart';
import 'package:Herfa/features/deals/data/data_source/deal_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:Herfa/features/get_me/me_repository.dart';
import '../viewmodels/order_history_cubit.dart';
import '../data/repository/profile_repository.dart';
import '../data/data_source/profile_remote_data_source.dart';
import 'order_card.dart';

class MerchantProfileScreen extends StatefulWidget {
  final MerchantProfile profile;
  const MerchantProfileScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  late MerchantProfile _profile;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double? walletBalance;
  int? loyaltyPoints;
  bool _loadingBalance = true;
  String? _balanceError;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    _fetchWalletAndPoints();
  }

  Future<void> _fetchWalletAndPoints() async {
    setState(() {
      _loadingBalance = true;
      _balanceError = null;
    });
    try {
      final data = await MeRepository().getMe();
      setState(() {
        walletBalance = data?.walletBalance;
        loyaltyPoints = data?.loyaltyPoints;
        _loadingBalance = false;
      });
    } catch (e) {
      setState(() {
        _balanceError = 'Failed to load balance';
        _loadingBalance = false;
      });
    }
  }

  Future<void> _refreshProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    if (token != null && userId != null) {
      final cubit = context.read<ProfileCubit>();
      await cubit.fetchProfile(token, userId);
      final state = cubit.state;
      if (state is ProfileLoaded) {
        setState(() {
          _profile = state.profile;
        });
      }
    }
  }

  void _showCreateCouponDialog() async {
    // Check authentication first
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to create coupons'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_profile.products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You need to create products first before creating coupons!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.local_offer, color: Color(0xFF7C5CFC)),
              const SizedBox(width: 8),
              const Text(
                'Select Product for Coupon',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Text(
                  'Choose a product to create a coupon for:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _profile.products.length,
                    itemBuilder: (context, index) {
                      final product = _profile.products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: product.media.isNotEmpty
                                ? NetworkImage(product.media)
                                : null,
                            child: product.media.isEmpty
                                ? const Icon(Icons.image, color: Colors.grey)
                                : null,
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: \$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'ID: ${product.id}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToCreateCoupon(product);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCreateCoupon(ProductMerchant product) {
    Navigator.pushNamed(
      context,
      Routes.createCouponRoute,
      arguments: {
        'productId': product.id,
        'productName': product.name,
        'couponCubit': context.read<CouponCubit>(),
      },
    ).then((result) {
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coupon created successfully for ${product.name}!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Navigate to coupon list or details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Coupon list feature coming soon!')),
                );
              },
            ),
          ),
        );
      }
    });
  }

  void _signOut() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(CacheConstant.tokenKey);
    await sharedPref.remove(CacheConstant.userDataKey);
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.loginRoute, (route) => false);
  }

  Widget _buildWalletLoyaltyCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xFF7C5CFC),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: _loadingBalance
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : _balanceError != null
                  ? Center(
                      child: Text(_balanceError!,
                          style: const TextStyle(color: Colors.white)))
                  : Row(
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
                                      ? '${walletBalance} EGP'
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
                            const Icon(Icons.stars,
                                color: Colors.amber, size: 22),
                          ],
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF7F6FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
        ),
        drawer: _buildDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 8),
            _buildWalletLoyaltyCard(),
            SizedBox(height: 8),
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage: _profile.profilePictureUrl != null &&
                        _profile.profilePictureUrl!.isNotEmpty
                    ? NetworkImage(_profile.profilePictureUrl!)
                    : const AssetImage('noprofile.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '${_profile.firstName} ${_profile.lastName}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(_profile.bio,
                  style: const TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat('${10}', 'Ratings'),
                const SizedBox(width: 32),
                _buildStat('${4.5}', 'Avg. Rating'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C5CFC),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token');
                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Not authenticated!')),
                      );
                      return;
                    }
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateProfileScreen(
                            token: token, profile: _profile),
                      ),
                    );
                    if (updated == true) {
                      await _refreshProfile();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated!')),
                      );
                    }
                  },
                  child: const Text('Edit Profile',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF7C5CFC)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: _showCreateCouponDialog,
                  child: Row(
                    children: const [
                      Text('Create coupon',
                          style: TextStyle(color: Color(0xFF7C5CFC))),
                      SizedBox(width: 4),
                      Icon(Icons.add, color: Color(0xFF7C5CFC), size: 18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TabBar(
                indicatorColor: const Color(0xFF7C5CFC),
                labelColor: const Color(0xFF7C5CFC),
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Created'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Your Orders'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProductGrid(_profile.products),
                  _buildReviewsTab(),
                  FutureBuilder<String?>(
                    future: SharedPreferences.getInstance()
                        .then((prefs) => prefs.getString('token')),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final token = snapshot.data ?? '';
                      return BlocProvider(
                        create: (_) => OrderHistoryCubit(
                            ProfileRepository(ProfileRemoteDataSource()))
                          ..fetchAllOrders(token),
                        child:
                            BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              return ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 24, bottom: 8.0),
                                    child: Text('Your Orders',
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${_profile.firstName} ${_profile.lastName}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail:
                Text(_profile.bio, style: const TextStyle(fontSize: 14)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: _profile.profilePictureUrl != null &&
                      _profile.profilePictureUrl!.isNotEmpty
                  ? NetworkImage(_profile.profilePictureUrl!)
                  : const AssetImage('assets/images/noprofile.png')
                      as ImageProvider,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_offer_outlined),
            title: const Text('All Coupons'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, Routes.allCouponsRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('All Deals'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');
              if (token == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not authenticated!')),
                );
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => SellerDealsCubit(
                      DealRepository(
                        DealRemoteDataSource(Dio(BaseOptions(
                          baseUrl:
                              'https://zygotic-marys-herfa-c2dd67a8.koyeb.app',
                        ))),
                      ),
                    ),
                    child: AllSellerDealsScreen(token: token),
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildProductGrid(List<ProductMerchant> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: GridView.builder(
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: product.media.isNotEmpty
                        ? Image.network(
                            product.media,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.price.toStringAsFixed(2)} EGP',
                          style: const TextStyle(
                            color: Color(0xFF7C5CFC),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Center(
      child: Text(
        'No reviews yet.',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}
