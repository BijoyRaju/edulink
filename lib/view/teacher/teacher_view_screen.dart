import 'package:edu_link/model/teacher_model.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:edu_link/widgets/student/student_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TeacherViewScreen extends StatelessWidget {
  final TeacherModel teacher;

  const TeacherViewScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: customText(text: teacher.name,color: Colors.white,fontSize: 20.sp),
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
                teacher.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              teacher.name,
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
                    detailTile(Icons.person, "Name", teacher.name),
                    const Divider(),
                    detailTile(Icons.phone, "Phone", teacher.phone),
                    const Divider(),
                    detailTile(Icons.assignment_turned_in, "Join Date", teacher.joinDate.toString()),
                    const Divider(),
                    detailTile(Icons.email, "Email", teacher.email),
                    const Divider(),
                    detailTile(Icons.topic, "Subject", teacher.subject),
                    const Divider(),
                    detailTile(Icons.date_range, "DOB", teacher.dateOfBirth.toString()),
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
