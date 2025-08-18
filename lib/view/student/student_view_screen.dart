import 'package:edu_link/controller/teacher_controller.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:edu_link/widgets/student/student_widget.dart';
import 'package:flutter/material.dart';
import 'package:edu_link/model/student_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class StudentViewScreen extends StatelessWidget {
  final StudentModel student;

  const StudentViewScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {

  final teacherController = Provider.of<TeacherController>(context);

  String getTeacherName(String teacherId) {
    if(teacherController.teacher.isEmpty){
      return "No teacher found";
    }
  final teacher = teacherController.teacher.firstWhere(
    (t) => t.teacherId == teacherId,
  );
  return teacher.name ?? "Unknow Teacher";
}

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: customText(text: student.name,color: Colors.white,fontSize: 20.sp),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF254F43),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Edit action
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              // TODO: Delete action
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Circle
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF254F43),
              child: Text(
                student.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              student.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    detailTile(Icons.person, "Name", student.name),
                    const Divider(),
                    detailTile(Icons.phone, "Phone", student.phone),
                    const Divider(),
                    detailTile(Icons.class_, "Class", student.stdClass),
                    const Divider(),
                    detailTile(Icons.assignment_turned_in, "Roll No", student.rollNo),
                    const Divider(),
                    detailTile(Icons.email, "Email", student.email),
                    const Divider(),
                    detailTile(Icons.person_add, "Parent", student.parentName),
                    const Divider(),
                    detailTile(Icons.date_range, "DOB", student.dateOfBirth.toString()),
                    const Divider(),
                    detailTile(Icons.school, "Teacher", getTeacherName(student.teacherId)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Action Button
            ElevatedButton.icon(
              onPressed: () {
                // Example: message student
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.message),
              label: const Text(
                "Send Message",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
