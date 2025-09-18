import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPopup extends StatelessWidget {
  final String studentId;
  final String studentName;

  const QrPopup({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center(child: Text("QR Code for $studentName")),
      content: SizedBox(
        width: 260,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: studentId,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: (){}, child: Text("Download")),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}

