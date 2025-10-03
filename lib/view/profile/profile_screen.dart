import 'package:edu_link/controller/auth_controller.dart';
import 'package:edu_link/view/login/login_screen.dart';
import 'package:edu_link/view/profile/about/about_screen.dart';
import 'package:edu_link/view/profile/help/help_screen.dart';
import 'package:edu_link/view/profile/privacy/privacy_screen.dart';
import 'package:edu_link/widgets/profile/profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = AuthController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Color(0xFF254F43),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            profileTile("My Profile", Icons.person, (){}),
            profileTile("Privacy", Icons.privacy_tip, (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyScreen()));
            }),
            profileTile("Edu Link Help", Icons.help, (){}),
            profileTile("About", Icons.info, (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
            }),
            profileTile("Help", Icons.live_help_sharp, (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
            }),
             profileTile("Logout", Icons.logout_rounded, (){
              controller.logOutUser(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),  (Route<dynamic> route) => false,);
            }),
            // App Information
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 20),
                      
                      buildInfoRow(
                        context,
                        Icons.apps,
                        'App Name',
                        'Edu Link',
                      ),
                      const SizedBox(height: 16),
                      
                      buildInfoRow(
                        context,
                        Icons.info,
                        'Version',
                        '1.0.0',
                      ),
                      const SizedBox(height: 16),
                      
                      buildInfoRow(
                        context,
                        Icons.build,
                        'Build',
                        '1',
                      ),
                    ],
                  ),
                ),
           
          ],
        ),
      ),
    );
  }
}