import 'package:flutter/material.dart';
import '../ss.dart';

class DebugButtonOverlay extends StatelessWidget {
  const DebugButtonOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 10,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.white),
            onPressed: () {
              testUserData(context);
            },
            tooltip: 'Print User Data',
          ),
        ),
      ),
    );
  }
}
