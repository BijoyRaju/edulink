import 'package:edu_link/services/auth_service.dart';
import 'package:edu_link/view/bottom_navigation/bottom_navigation_screen.dart';
import 'package:edu_link/view/login/login_screen.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final AuthService _authService = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final schoolController = TextEditingController();
  final rePasswordController = TextEditingController();

  final subjectController = TextEditingController();
  final additinalInfoController = TextEditingController();
  final dobController = TextEditingController();
  final joinDateController = TextEditingController();

  DateTime? dateOfBirth;
  DateTime? joinDate;

  // Register Admin
  Future<void> registerAdmin(BuildContext context) async {
    String result = await _authService.registerAdmin(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: 'admin',
      phoneNo: phoneController.text.trim(),
      schoolName: schoolController.text.trim(),
    );
    if (context.mounted) {
      if (result == "success") {
        showSnackBarMessage(context, "Admin Registered Successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showSnackBarMessage(context, result);
      }
    }
  }



  // Login
  Future<void> loginUser(BuildContext context) async {
    var result = await _authService.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    if (context.mounted) {
      if (result["status"] == "success") {
        String userRole = result["role"];
        String userId = result["userId"];
        String? adminId = result["adminId"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userId", userId);
        await prefs.setString("role",userRole);
        await prefs.setBool("isLoggedIn", true);

        if (userRole != "admin" && adminId != null) {
        // Save adminId for teacher/student
        await prefs.setString("adminId", adminId);
      }
        if(context.mounted){
        showSnackBarMessage(context, "Login Successful");
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomNavigationScreen(role: userRole,),),
        );
        }
      } else {
        showSnackBarMessage(context, result["message"]);
      }
    }
  }

  // Register Teacher
  Future<void> registerTeacher(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminId = prefs.getString("userId");
    if (context.mounted) {
      if (adminId == null) {
        showSnackBarMessage(context, "Admin not logged in");
        return;
      }

      final result = await _authService.registerTeacher(
        adminId: adminId,
        name: nameController.text.trim(),
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        subject: subjectController.text.trim(),
        dateOfBirth: dateOfBirth!,
        joinDate: joinDate!,
        additionalInfo: additinalInfoController.text.trim(),
        role: 'teacher',
      );
      if (context.mounted) {
        if (result == "success") {
          showSnackBarMessage(context, "Teacher registration success");
        } else {
          showSnackBarMessage(context, result);
        }
      }
    }
  }


  // LogOut User
  Future<void> logOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if(context.mounted){
        showSnackBarMessage(context, "Logged Out Successfully.");
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBarMessage(context, "Logout failed: $e");
      }
    }
  }

    void dispose() {
      nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      phoneController.dispose();
      schoolController.dispose();
      rePasswordController.dispose();
      subjectController.dispose();
      additinalInfoController.dispose();
      dobController.dispose();
      joinDateController.dispose();
    }
}