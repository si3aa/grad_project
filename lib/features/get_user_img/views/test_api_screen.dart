import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../index.dart';

class TestApiScreen extends StatefulWidget {
  const TestApiScreen({Key? key}) : super(key: key);

  @override
  State<TestApiScreen> createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  final TextEditingController _userIdController =
      TextEditingController(text: '3');
  String _result = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    developer.log('=== TEST API SCREEN INITIALIZED ===', name: 'TestApiScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test User Image API'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test User Image API Calls',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Input field for user ID
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                border: OutlineInputBorder(),
                hintText: 'Enter user ID (e.g., 3)',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            // Test buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testDirectApiCall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Test Direct API Call'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testCubitApiCall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test Cubit API Call'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Widget test
            const Text(
              'Widget Test:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            CachedUserImageWidget(
              userId: int.tryParse(_userIdController.text) ?? 3,
              radius: 30,
              onTap: () {
                developer.log('Widget tapped!', name: 'TestApiScreen');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Widget tapped!')),
                );
              },
            ),

            const SizedBox(height: 20),

            // Results
            const Text(
              'API Results:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _result.isEmpty
                      ? 'No results yet. Check console for detailed logs.'
                      : _result,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Clear logs button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _result = '';
                });
                developer.log('=== LOGS CLEARED ===', name: 'TestApiScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear Results'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testDirectApiCall() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing direct API call...\n';
    });

    try {
      developer.log('=== TESTING DIRECT API CALL ===', name: 'TestApiScreen');

      final userId = int.tryParse(_userIdController.text) ?? 3;
      final repository = UserImageRepository();

      final startTime = DateTime.now();
      final userImage = await repository.getUserImage(userId);
      final endTime = DateTime.now();

      final duration = endTime.difference(startTime);

      setState(() {
        _result += '✅ Direct API Call Successful!\n';
        _result += 'User ID: $userId\n';
        _result += 'Image URL: ${userImage.imageUrl}\n';
        _result += 'Duration: ${duration.inMilliseconds}ms\n';
        _result += 'Success: ${userImage.success}\n';
        _result += 'Message: ${userImage.message}\n';
        _result += 'Timestamp: ${DateTime.now()}\n\n';
        _result += 'Check console for detailed request/response logs.\n';
      });

      developer.log('Direct API call completed successfully',
          name: 'TestApiScreen');
    } catch (e) {
      setState(() {
        _result += '❌ Direct API Call Failed!\n';
        _result += 'Error: $e\n';
        _result += 'Timestamp: ${DateTime.now()}\n\n';
        _result += 'Check console for detailed error logs.\n';
      });

      developer.log('Direct API call failed: $e', name: 'TestApiScreen');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCubitApiCall() async {
    setState(() {
      _result += 'Testing Cubit API call...\n';
    });

    try {
      developer.log('=== TESTING CUBIT API CALL ===', name: 'TestApiScreen');

      final userId = int.tryParse(_userIdController.text) ?? 3;
      final cubit = UserImageCubit();

      final startTime = DateTime.now();
      await cubit.getUserImage(userId);
      final endTime = DateTime.now();

      final duration = endTime.difference(startTime);

      setState(() {
        _result += '✅ Cubit API Call Completed!\n';
        _result += 'User ID: $userId\n';
        _result += 'Duration: ${duration.inMilliseconds}ms\n';
        _result += 'Timestamp: ${DateTime.now()}\n\n';
        _result += 'Check console for detailed cubit logs.\n';
      });

      developer.log('Cubit API call completed', name: 'TestApiScreen');
    } catch (e) {
      setState(() {
        _result += '❌ Cubit API Call Failed!\n';
        _result += 'Error: $e\n';
        _result += 'Timestamp: ${DateTime.now()}\n\n';
        _result += 'Check console for detailed error logs.\n';
      });

      developer.log('Cubit API call failed: $e', name: 'TestApiScreen');
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
}
