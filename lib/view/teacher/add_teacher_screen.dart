import 'package:edu_link/controller/auth_controller.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddTeacherScreen> {

  final AuthController controller = AuthController();

  Future<void> _pickDate({required TextEditingController textController,required void Function(DateTime) onDatePicked}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        textController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        onDatePicked(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Teacher"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(controller: controller.nameController, label: "Name"),
            customTextField(controller: controller.emailController, label: "Email"),
            customTextField(controller: controller.phoneController, label: "Phone No"),
            customTextField(controller: controller.subjectController, label: "Subject"),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(textController: controller.dobController, onDatePicked: (date) => controller.dateOfBirth = date),
                    child: AbsorbPointer(
                      child: customTextField(controller: controller.dobController, label: "Date of Birth"),
                    ),
                  ),
                ),
                

                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(textController: controller.joinDateController, onDatePicked: (date) => controller.joinDate = date),
                    child: AbsorbPointer(
                      child: customTextField(controller: controller.joinDateController, label: "Join Date"),
                    ),
                  ),
                ),
              ],
            ),
            customTextField(controller: controller.additinalInfoController, label: "Additional Info",maxline: 5),
            customTextField(controller: controller.passwordController, label: "Password",obscureText: true),
            customTextField(controller: controller.rePasswordController, label: "Re-Enter Password",obscureText: true),
            SizedBox(height: 20.h),
            customButton(text: "Add ", onPressed: ()async{
              if(validateTeacherForm(context, controller)){
              await controller.registerTeacher(context);
              if(context.mounted) Navigator.pop(context);
              }
            })
          ],
        ),
      ),
    );
  }

  // Validate
  bool validateTeacherForm(BuildContext context, AuthController controller) {
  if (controller.nameController.text.isEmpty) {
    showError(context, "Name is required");
    return false;
  }
  if (controller.emailController.text.isEmpty ||
      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(controller.emailController.text)) {
    showError(context, "Enter a valid email");
    return false;
  }
  if (controller.phoneController.text.isEmpty ||
      !RegExp(r'^[0-9]{10}$').hasMatch(controller.phoneController.text)) {
    showError(context, "Enter a valid 10-digit phone number");
    return false;
  }
  if (controller.subjectController.text.isEmpty) {
    showError(context, "Subject is required");
    return false;
  }
  if (controller.dobController.text.isEmpty) {
    showError(context, "Select Date of Birth");
    return false;
  }
  if (controller.joinDateController.text.isEmpty) {
    showError(context, "Select Join Date");
    return false;
  }
  if (controller.passwordController.text.isEmpty ||
      controller.passwordController.text.length < 6) {
    showError(context, "Password must be at least 6 characters");
    return false;
  }
  if (controller.passwordController.text != controller.rePasswordController.text) {
    showError(context, "Passwords do not match");
    return false;
  }

  return true;
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.black),
  );
}
}

