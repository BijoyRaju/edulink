import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/controller/teacher_controller.dart';
import 'package:edu_link/widgets/home/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Widget adminOverview(BuildContext context){
  final teacherController = Provider.of<TeacherController>(context);
  final studentController = Provider.of<StudentController>(context);
  final totalTeacher = teacherController.teacher.length;
  final totalStudents = studentController.students.length;
  
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  homeScreenContainerOne(250.sp, 150.sp, Color(0xFFA7D0B9), "STUDENTS", "$totalStudents"),
                  Column(
                    children: [
                      homeScreenContainerTwo(115.sp, 150.sp, Color(0xFF043427), "TEACHERS", "$totalTeacher"),
                      SizedBox(height: 10.h),
                      homeScreenContainerTwo(115.sp, 150.sp, Color(0xFF29725E), "REVENUE", "15000"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text("Recent Transaction",style: TextStyle(fontSize: 20.sp,decoration: TextDecoration.underline,color: Colors.grey,decorationColor: Colors.grey),)
            ],
          ),
        ],
      ),
    ),
  );
}