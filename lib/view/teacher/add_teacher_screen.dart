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
              await controller.registerTeacher(context);
              Navigator.pop(context);
            })
          ],
        ),
      ),
    );
  }
}

