import 'package:edu_link/controller/auth_controller.dart';
import 'package:edu_link/view/login/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = AuthController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              controller.logOutUser(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),  (Route<dynamic> route) => false,);
          }, child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}