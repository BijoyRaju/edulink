import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/controller/teacher_controller.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {

  final StudentController controller = StudentController();

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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<TeacherController>().fetchTeachers();
    });
    super.initState();
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
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          final prefs = snapshot.data!;
          final role = prefs.getString("role") ?? "teacher";
          final userId = prefs.getString("userId");
        return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (role == "teacher")
              Builder(
                builder: (context) {
                  controller.selectedTeacherId = userId;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Assigned Teacher: You",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Note: The student you add will be under your responsibility.",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[800],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  );
                },
              ),
            customTextField(controller: controller.nameController, label: "Name"),
            customTextField(controller: controller.emailController, label: "Email"),
            customTextField(controller: controller.parentNameController, label: "Parent Name"),
            customTextField(controller: controller.phoneNumberController, label: "Phone No"),
            // Teacher Select List
            if(role == "admin")
            Consumer<TeacherController>(
              builder: (context,teacherController,child){
                if(teacherController.isLoading){
                  return const Center(child: CircularProgressIndicator());
                }if(teacherController.teacher.isEmpty){
                  return const Center(child: Text("No Teacher Found"));
                }return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Select Text"
                  ),
                  items: teacherController.teacher.map((t){
                    return DropdownMenuItem(
                      value: t.teacherId,
                      child: Text(t.name)
                      );
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      controller.selectedTeacherId = value;
                    });
                  }
                );
              }
              ),

            Row(
              children: [
                Expanded(child: customTextField(controller: controller.classController, label: "Class")),
                SizedBox(width: 10.w),
                Expanded(child: customTextField(controller: controller.rollNoController, label: "Roll No")),
              ],
            ),

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
                    onTap: () => _pickDate(textController: controller.admissionDateController, onDatePicked: (date) => controller.admissionDate = date),
                    child: AbsorbPointer(
                      child: customTextField(controller: controller.admissionDateController, label: "Admission Date"),
                    ),
                  ),
                ),
              ],
            ),
            customTextField(controller: controller.passwordController, label: "Password",obscureText: true),
            customTextField(controller: controller.reEnterPassword, label: "Re Enter Password",obscureText: true),

            SizedBox(height: 20.h),
            customButton(text: "Add ", onPressed: ()async{
              await controller.registerStudent(context);
              if(context.mounted){
              Navigator.pop(context);
              }}
              ),
            ],
          ),
        );
      },
    ),
  );
}
}