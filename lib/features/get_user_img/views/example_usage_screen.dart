import 'package:flutter/material.dart';
import '../index.dart';

class ExampleUsageScreen extends StatelessWidget {
  const ExampleUsageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Image Examples'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Image Widget Examples',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Example 1: Basic usage
            const Text(
              '1. Basic User Image Widget:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CachedUserImageWidget(
                  userId: 3,
                  radius: 25,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'This widget fetches the user image from the API and displays it with loading and error states.',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Example 2: Different sizes
            const Text(
              '2. Different Sizes:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CachedUserImageWidget(userId: 3, radius: 15),
                const SizedBox(width: 16),
                CachedUserImageWidget(userId: 3, radius: 25),
                const SizedBox(width: 16),
                CachedUserImageWidget(userId: 3, radius: 35),
              ],
            ),

            const SizedBox(height: 30),

            // Example 3: With tap handler
            const Text(
              '3. With Tap Handler:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            CachedUserImageWidget(
              userId: 3,
              radius: 30,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User image tapped!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Example 4: Manual API call
            const Text(
              '4. Manual API Call Example:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final repository = UserImageRepository();
                final cubit = UserImageCubit(repository: repository);

                try {
                  await cubit.getUserImage(3);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User image fetched successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Fetch User Image Manually'),
            ),

            const SizedBox(height: 30),

            // Example 5: Error handling
            const Text(
              '5. Error Handling (Invalid User ID):',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            CachedUserImageWidget(
              userId: 999999, // Invalid user ID to test error handling
              radius: 25,
            ),
          ],
        ),
      ),
    );
  }
}
