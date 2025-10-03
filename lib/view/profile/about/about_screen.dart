import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appName = "Edu Link";
  String version = "";
  String buildNumber = "";

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: Color(0xFF254F43),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/logo.png"),
            ),
            const SizedBox(height: 16),
            Text(
              appName,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF254F43)),
            ),
            const SizedBox(height: 8),
            Text("Version $version (Build $buildNumber)",
                style: const TextStyle(color: Colors.grey)),

            const Divider(height: 30),

            const Text(
              "Edu Link is a complete school management solution. "
              "It helps manage students, teachers, branches, fees, and communication "
              "with ease. The app provides secure payments, attendance tracking, "
              "and real-time notifications for schools and parents.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const Spacer(),
            const Text("Developed by Bijoy Raju",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text("© 2025 Edu Link. All rights reserved.",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
