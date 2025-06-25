import 'package:flutter/material.dart';

class BundleViewModel extends ChangeNotifier {
  // Example: List of bundles (replace with your actual model)
  List<dynamic> bundles = [];

  // Example: Loading state
  bool isLoading = false;

  // Example: Error message
  String? error;

  Future<void> fetchAllBundles() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      bundles = [];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
