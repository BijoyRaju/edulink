import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; // ✅ Import intl

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final parentNameController = TextEditingController();
  final phoneController = TextEditingController();
  final classController = TextEditingController();
  final rollController = TextEditingController();

  final dobController = TextEditingController();
  final admissionDateController = TextEditingController();

  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
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
            customTextField(controller: nameController, label: "Name"),
            customTextField(controller: emailController, label: "Email"),
            customTextField(controller: parentNameController, label: "Parent Name"),
            customTextField(controller: phoneController, label: "Phone No"),

            Row(
              children: [
                Expanded(child: customTextField(controller: classController, label: "Class")),
                SizedBox(width: 10.w),
                Expanded(child: customTextField(controller: rollController, label: "Roll No")),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(dobController),
                    child: AbsorbPointer(
                      child: customTextField(controller: dobController, label: "Date of Birth"),
                    ),
                  ),
                ),
                

                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(admissionDateController),
                    child: AbsorbPointer(
                      child: customTextField(controller: admissionDateController, label: "Admission Date"),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
            customButton(text: "Add ", onPressed: (){})
          ],
        ),
      ),
    );
  }
}
