import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/user_viewmodel.dart';

class UserInfoDisplay extends StatelessWidget {
  const UserInfoDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  viewModel.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.getCurrentUser(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (viewModel.currentUser == null) {
          return const Center(
            child: Text('No user information available'),
          );
        }

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (viewModel.currentUser?.profile?.profilePictureUrl != null)
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          viewModel.currentUser!.profile!.profilePictureUrl!,
                        ),
                      )
                    else
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${viewModel.username}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (viewModel.isVerified)
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                      ),
                  ],
                ),
                const Divider(height: 32),
                _InfoRow(
                  icon: Icons.badge,
                  label: 'Role',
                  value: viewModel.userRole,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.numbers,
                  label: 'ID',
                  value: viewModel.userId?.toString() ?? 'N/A',
                ),
                if (viewModel.currentUser?.profile != null) ...[
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: viewModel.currentUser!.profile!.phone,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.location_on,
                    label: 'Address',
                    value: viewModel.currentUser!.profile!.address,
                  ),
                  if (viewModel.currentUser!.profile!.bio.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Bio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      viewModel.currentUser!.profile!.bio,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
