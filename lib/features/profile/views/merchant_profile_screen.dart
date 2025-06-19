import 'package:flutter/material.dart';
import '../data/models/merchant_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/profile_cubit.dart';
import './create_profile_screen.dart';

class MerchantProfileScreen extends StatefulWidget {
  final MerchantProfile profile;
  const MerchantProfileScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  late MerchantProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.share, color: Colors.black),
                onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.black),
                onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.black),
                onPressed: () {}),
          ],
        ),
        body: ListView(
          children: [
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
                _buildStat('${_profile.numberOfRatings}', 'Ratings'),
                const SizedBox(width: 32),
                _buildStat('${_profile.averageRating}', 'Avg. Rating'),
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
                  onPressed: () {},
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
                ],
              ),
            ),
            SizedBox(
              height: 350,
              child: TabBarView(
                children: [
                  _buildProductGrid(_profile.products),
                  _buildReviewsTab(),
                ],
              ),
            ),
          ],
        ),
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: product.media.isNotEmpty
                  ? Image.network(product.media, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 40, color: Colors.grey),
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
