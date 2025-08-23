import 'package:edu_link/services/auth_service.dart';
import 'package:edu_link/view/bottom_navigation/bottom_navigation_screen.dart';
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
  DateTime? dateOfBirth;
  DateTime? joinDate;
  

  // Register Admin
  Future<void> registerAdmin(BuildContext context)async{
    String result = await _authService.registerAdmin(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: 'admin',
      phoneNo: phoneController.text.trim(),
      schoolName: schoolController.text.trim()
    );
    if(context.mounted){
      if(result == "success"){
        showSnackBarMessage(context,"Admin Registerd Successfully");
      }else{
        showSnackBarMessage(context,result);
      }
    }
  }
    void dispose() {
      nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      phoneController.dispose();
      schoolController.dispose();
    }

  // Login
  Future<void> loginUser(BuildContext context)async{
    var result = await _authService.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim()
    );
    if(context.mounted){
      if(result["status"] == "success"){
        String userRole = result["role"];
        showSnackBarMessage(context, "Login Successfull");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(role: userRole)));
      }else{
        showSnackBarMessage(context, result["message"]);
      }
    }
  }

  // Register Teacher

  Future<void> registerTeacher(BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminId = prefs.getString("userId");
      if(adminId == null){
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
      role: 'teacher'
    );
    if(context.mounted){
      if(result == "success"){
        showSnackBarMessage(context, "Teacher registartion success");
      }else{
        showSnackBarMessage(context, result);
      }
    }

  // Future<void> registerStudent(String email,String name,String password)async{
  //   await _authService.registerUser(
  //     name: name,
  //     email: email,
  //     password: password,
  //     role: 'student'
  //   );
  // }
}


   // LogOut User
   Future<void> logOutUser(BuildContext context)async{
    try{
      await FirebaseAuth.instance.signOut();
      if(context.mounted){
      showSnackBarMessage(context, "Logged Out Successfully.");
    }
    }catch(e){
      if(context.mounted){
        showSnackBarMessage(context, "Logout failed : $e");
      }
    }
   }
}
