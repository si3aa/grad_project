import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareLinkDialog extends StatelessWidget {
  final String shareLink;
  const ShareLinkDialog({Key? key, required this.shareLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share Link'),
      content: Row(
        children: [
          Expanded(child: Text(shareLink)),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: shareLink));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
