import 'package:flutter/material.dart';
import 'widgets/user_fav_dialog.dart';

class ShowUserFavDialog {
  static void show(BuildContext context, String productId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return UserFavDialog(productId: productId);
      },
    );
  }
}
