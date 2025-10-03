import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Color(0xFF254F43),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF254F43),
              ),
            ),
            SizedBox(height: 16),

            Text(
              "Edu Link respects your privacy and is committed to protecting "
              "your personal information. This Privacy Policy explains how "
              "we collect, use, and safeguard your data when using the app.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Text(
              "1. Information We Collect",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "We may collect personal information such as your name, email, "
              "phone number, and payment details for fee management.",
            ),
            SizedBox(height: 12),

            Text(
              "2. How We Use Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "We use the collected data to manage students, process payments, "
              "send notifications, and improve the app experience.",
            ),
            SizedBox(height: 12),

            Text(
              "3. Data Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Your data is securely stored using Firebase and encrypted "
              "payment gateways like Razorpay.",
            ),
            SizedBox(height: 12),

            Text(
              "4. Third-Party Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "We integrate third-party services such as Firebase, StreamChat, "
              "and OneSignal. These services may collect limited information "
              "to provide functionality.",
            ),
            SizedBox(height: 12),

            Text(
              "5. User Rights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "You can request deletion of your account and associated data "
              "at any time by contacting our support.",
            ),
            SizedBox(height: 12),

            Text(
              "6. Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "If you have questions about this Privacy Policy, please reach us at:\n"
              "📧 support@edulink.com\n📞 +91 9876543210",
            ),
            SizedBox(height: 20),

            Text(
              "Last Updated: January 2025",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
