import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Color(0xFF254F43),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _faqItem(
            "How to pay fees?",
            "Go to the Fees section → Select Pending Fees → Click Pay and complete via Razorpay.",
          ),
          _faqItem(
            "How to view attendance?",
            "Navigate to Attendance Dashboard → Select Month to see student-wise attendance.",
          ),
          _faqItem(
            "How to contact teachers?",
            "Use the built-in chat powered by StreamChat to message teachers directly.",
          ),
          _faqItem(
            "What if payment fails?",
            "If payment fails, the amount will be auto-refunded. You can retry after 15 minutes.",
          ),

          const SizedBox(height: 25),
          const Text(
            "Need More Help?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF254F43)),
            title: const Text("Email Support"),
            subtitle: const Text("support@edulink.com"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF254F43)),
            title: const Text("Call Support"),
            subtitle: const Text("+91 9876543210"),
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Color(0xFF254F43)),
            title: const Text("Live Chat"),
            subtitle: const Text("Chat with our support team"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
