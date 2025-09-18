import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/view/drawer/drawer.dart';
import 'package:edu_link/view/home/admin_tabs/admin_overview.dart';
import 'package:edu_link/view/home/admin_tabs/teacher_list_screen.dart';
import 'package:edu_link/view/home/admin_tabs/student_tab.dart';
import 'package:edu_link/view/home/student_tabs/attendace_dashboard.dart';
import 'package:edu_link/view/home/student_tabs/student_dashboard.dart';
import 'package:edu_link/view/home/teacher_tabs/teacher_dashboard.dart';
import 'package:edu_link/view/home/teacher_tabs/teacher_student_tab.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:edu_link/widgets/student/qr_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  final String role;
  HomeScreen({super.key,
  required this.role
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

String studentId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final tabs = _getTabs();
    final views = _getTabViews(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: customDrawer(context,role,studentId),
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset("assets/images/home_appBar.png",width: double.infinity,fit: BoxFit.fill,height: 215.h),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              _scaffoldKey.currentState?.openDrawer();
                            }, icon: Icon(Icons.menu_sharp,size: 40.sp,color: Colors.white)),
                            Spacer(),
                            if(role == "student") IconButton(onPressed: (){
                              final studentController = Provider.of<StudentController>(context,listen: false);
                              final student = studentController.currentStudent;
                              showDialog(
                                context: context,
                                builder: (_) => QrPopup(
                                  studentId: student!.studentId,
                                  studentName: student.name,
                                ));
                            }, icon: Icon(Icons.qr_code,size: 25.sp,color: Colors.white,))
                          ],
                        ),
                        SizedBox(height: 15.sp),
                        customText(text: "Welcome to Edu Link",fontSize: 24.sp,fontWeight: FontWeight.bold,color: Colors.white),
                        SizedBox(height: 3.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: customText(text: "Where things are managed smartly",fontSize: 16.sp,fontWeight: FontWeight.bold,color: Color(0xFFD7DEDA)),
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
            TabBar(tabs: tabs,labelColor: Colors.black,unselectedLabelColor: Colors.grey,indicatorColor: Colors.black ,labelStyle: TextStyle(fontSize: 16.sp)),
            Expanded(child: TabBarView(children: views))
          ],
        ),
      ),
    );
  }

    List<Tab> _getTabs(){
    if(role == "admin"){
      return  [
        Tab(text: "Overview"),
        Tab(text: "Student"),
        Tab(text: "Teacher")
      ];
    }else if(role == "teacher"){
    return  [
      Tab(text: "Dashboard"),
      Tab(text: "Student")
    ];
    }else{
      return  [
        Tab(text: "Dashboard"),
        Tab(text: "Attendance",)
      ];
    }
  }

    List<Widget> _getTabViews(BuildContext context){
    if(role == "admin"){
      return [
        // Admin overview UI
        AdminOverview(),

        // Student Tab View(Admin)
        StudentTab(),

        // Teacher Tab View(Admin)
        TeacherListScreen()
      ];
    }else if(role == "teacher"){
      return [
        // Dashboard
        TeacherDashboard(),
        // Students
        TeacherStudentTab()
      ];
    }else{
      return [
        StudentDashboard(),
        AttendanceDashboard()
      ];
    }
  }

}