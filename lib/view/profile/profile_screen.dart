import 'package:edu_link/controller/auth_controller.dart';
import 'package:edu_link/view/login/login_screen.dart';
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
        child: Column(
          children: [
            profileTile("My Profile", Icons.person, (){}),
            profileTile("Privacy", Icons.privacy_tip, (){}),
            profileTile("Edu Link Help", Icons.help, (){}),
            profileTile("About", Icons.info, (){}),
            profileTile("Help", Icons.live_help_sharp, (){}),
            profileTile("Logout", Icons.logout_rounded, (){
              controller.logOutUser(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),  (Route<dynamic> route) => false,);
            }),
          ],
        ),
      ),
    );
  }
}