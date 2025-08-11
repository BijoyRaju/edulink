import 'package:edu_link/controller/auth_controller.dart';
import 'package:edu_link/view/register/register_screen.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller = AuthController();
  LoginScreen({super.key});

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
        child:Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText(text: "L O G I N",color: Colors.white,fontSize: 24.sp,fontWeight: FontWeight.bold),
                SizedBox(height: 20.sp),
                customTextFormField(text: "Email", controller: controller.emailController),
                customTextFormField(text: "Password", controller: controller.passwordController),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      customText(text: "Forget Password",color: Colors.white,fontSize: 16.sp)
                    ],
                  ),
                ),
                customButton(text: "LOGIN", onPressed: (){
                  controller.loginUser(context);
                }),
                Divider(),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  child: customText(text: "Don't have an Account?",color:  Colors.white, fontSize: 18.h))
              ],
            )
          ),
        )
      )
    );
  }
}