import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../user/viewmodel/user_viewmodel.dart';
import '../../../ui/widgets/home/enhanced_header.dart';
import '../../../ui/widgets/home/header.dart';

class HeaderDemoScreen extends StatefulWidget {
  const HeaderDemoScreen({Key? key}) : super(key: key);

  @override
  State<HeaderDemoScreen> createState() => _HeaderDemoScreenState();
}

class _HeaderDemoScreenState extends State<HeaderDemoScreen> {
  bool _useEnhancedHeader = true;

  @override
  void initState() {
    super.initState();
    // Load user data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Header Demo'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          Switch(
            value: _useEnhancedHeader,
            onChanged: (value) {
              setState(() {
                _useEnhancedHeader = value;
              });
            },
          ),
          const SizedBox(width: 16),
          Text(
            _useEnhancedHeader ? 'Enhanced' : 'Basic',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Header Demo
          _useEnhancedHeader ? const EnhancedHomeAppBar() : const HomeAppBar(),

          const SizedBox(height: 20),

          // User Info Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<UserViewModel>(
                  builder: (context, userViewModel, child) {
                    if (userViewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (userViewModel.error != null) {
                      return Column(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${userViewModel.error}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => userViewModel.getCurrentUser(),
                            child: const Text('Retry'),
                          ),
                        ],
                      );
                    }

                    if (userViewModel.currentUser == null) {
                      return const Center(
                        child: Text('No user information available'),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current User Information:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow('User ID',
                            userViewModel.userId?.toString() ?? 'N/A'),
                        _InfoRow('Username', userViewModel.username),
                        _InfoRow('Full Name', userViewModel.fullName),
                        _InfoRow('Role', userViewModel.userRole),
                        _InfoRow(
                            'Verified', userViewModel.isVerified.toString()),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            userViewModel.getCurrentUser();
                          },
                          child: const Text('Refresh User Data'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Instructions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Header Features:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FeatureItem('✅ User profile image from API'),
                    _FeatureItem('✅ Loading state with spinner'),
                    _FeatureItem('✅ Error handling with fallback'),
                    _FeatureItem('✅ Tap to show profile options'),
                    _FeatureItem('✅ Enhanced styling with gradients'),
                    _FeatureItem('✅ Username and verification badge'),
                    _FeatureItem('✅ Settings button integration'),
                    const SizedBox(height: 12),
                    const Text(
                      'Toggle the switch in the app bar to see both header versions!',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _FeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
