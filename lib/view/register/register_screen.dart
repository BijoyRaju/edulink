import 'package:edu_link/controller/auth_controller.dart';
import 'package:edu_link/view/login/login_screen.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController controller = AuthController();
  final _formKey = GlobalKey<FormState>();
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customText(text: "R E G I S T E R",color: Colors.white,fontSize: 24.sp,fontWeight: FontWeight.bold),
                  SizedBox(height: 20.h),
                  customTextFormField(text: "Name",controller: controller.nameController,validator: validateName),
                  customTextFormField(text: "Email",controller: controller.emailController,validator: validateEmail),
                  customTextFormField(text: "Phone", controller: controller.phoneController,validator: validatePhone),
                  customTextFormField(text: "School Name",controller: controller.schoolController,validator: validateSchoolName),
                  customTextFormField(text: "Password",controller: controller.passwordController, obscureText: true,validator: validatePassword),
                  customTextFormField(text: "Re-Enter Password",controller: controller.rePasswordController,obscureText: true,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please re-enter password";
                      }if (value != controller.passwordController.text) {
                      return "Passwords do not match";
                      }
                      return null;
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: customText(text: "Already have a account?",color: Colors.white,fontSize: 16.sp)
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  customButton(text: "Register", onPressed: ()async{
                    if (_formKey.currentState!.validate()) {
                      await controller.registerAdmin(context);
                    }
                  })                  
                ],
            )
          )
        )
      )
  );
}


    String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is Required";
    }
    return null;
  }

  String? validatePassword(String? value){
    if(value == null || value.isEmpty){
      return "Password is Required";
    }if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
     return null;
   }
  }

  String? validateSchoolName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is Required";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is Required";
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Enter a valid 10-digit phone number";
    }
    return null;
}