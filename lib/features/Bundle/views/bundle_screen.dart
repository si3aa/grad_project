import 'package:Herfa/features/Bundle/viewmodels/bundle_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/features/Bundle/views/create_bundle_screen.dart';

class BundleScreen extends StatelessWidget {
  const BundleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BundleViewModel(),
      child: Consumer<BundleViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.all_inbox, color: Colors.orange, size: 34),
                  SizedBox(width: 12),
                  Text(
                    'Bundle',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 1,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Show all bundles
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('All Bundle',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Show my bundles
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5F5F5),
                              foregroundColor: kPrimaryColor,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('My Bundles',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.inbox, size: 64, color: Colors.grey),
                          SizedBox(height: 24),
                          Text(
                            'No bundle yet',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateBundleScreen(),
                  ),
                );
              },
              backgroundColor: kPrimaryColor,
              child: const Icon(Icons.add, color: Colors.white, size: 32),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}
