import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/widgets/home/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:edu_link/controller/teacher_controller.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      if(mounted){
        Provider.of<StudentController>(context, listen: false).fetchStudentByTeacher();
        Provider.of<TeacherController>(context,listen: false).fetchCurrentTeacher();
      }
  });
  }

  @override
  Widget build(BuildContext context) {
    final studentController = Provider.of<StudentController>(context);
    final teacherController = Provider.of<TeacherController>(context);

    final totalStudents = studentController.students.length;
    final teacher = teacherController.currentTeacher;


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teacher Info Card
              customTileTeacher("${teacher?.name}", "${teacher?.subject}", 315.w),
              SizedBox(height: 20.h),

              // Stats Card
              homeScreenContainerOne(
                140.h,
                double.infinity,
                const Color(0xFFA7D0B9),
                "Students",
                "$totalStudents",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

