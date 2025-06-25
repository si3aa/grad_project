import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/show_bundels/viewmodels/bundle_cubit.dart';
import 'package:Herfa/constants.dart';

class BundleScreen extends StatefulWidget {
  const BundleScreen({Key? key}) : super(key: key);

  @override
  State<BundleScreen> createState() => _BundleScreenState();
}

class _BundleScreenState extends State<BundleScreen> {
  int selectedIndex = 0; // 0: All Bundle, 1: My Bundles

  @override
  void initState() {
    super.initState();
    context.read<BundleCubit>().fetchBundles();
  }

  @override
  Widget build(BuildContext context) {
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
                        setState(() {
                          selectedIndex = 0;
                        });
                        context.read<BundleCubit>().fetchBundles();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 0
                            ? kPrimaryColor
                            : const Color(0xFFF5F5F5),
                        foregroundColor:
                            selectedIndex == 0 ? Colors.white : kPrimaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'All Bundle',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                      ),
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
                        setState(() {
                          selectedIndex = 1;
                        });
                        // TODO: Implement 'My Bundles' filter if needed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 1
                            ? kPrimaryColor
                            : const Color(0xFFF5F5F5),
                        foregroundColor:
                            selectedIndex == 1 ? Colors.white : kPrimaryColor,
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
            child: BlocBuilder<BundleCubit, BundleState>(
              builder: (context, state) {
                if (state is BundleLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BundleError) {
                  return Center(child: Text(state.message));
                } else if (state is BundleLoaded) {
                  final bundles = state.bundles;
                  if (bundles.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.inbox, size: 64, color: Colors.grey),
                            SizedBox(height: 24),
                            Text(
                              'No bundle yet',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: bundles.length,
                    itemBuilder: (context, index) {
                      final bundle = bundles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bundle.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333366),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      bundle.description,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.attach_money,
                                            color: Colors.orange, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${bundle.bundlePrice} EGP',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Bundle'),
                                      content: const Text(
                                          'Are you sure you want to delete this bundle?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Delete',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    context
                                        .read<BundleCubit>()
                                        .deleteBundle(bundle.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
