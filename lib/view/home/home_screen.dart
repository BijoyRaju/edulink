import 'package:edu_link/view/add_student/add_student_screen.dart';
import 'package:edu_link/view/add_teacher/add_teacher_screen.dart';
import 'package:edu_link/view/home/tabs/admin_overview.dart';
import 'package:edu_link/view/home/tabs/teacher_list_screen.dart';
import 'package:edu_link/view/home/tabs/student_tab.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeScreen extends StatelessWidget {
  final String role;
  const HomeScreen({super.key,
  required this.role
  });

  @override
  Widget build(BuildContext context) {
    final tabs = _getTabs();
    final views = _getTabViews(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
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
                        Icon(Icons.menu_sharp,size: 40.sp,color: Color(0xFF242424),),
                        SizedBox(height: 20.sp),
                        customText(text: "Welcome to Edu Link",fontSize: 24.sp,fontWeight: FontWeight.bold,color: Colors.white),
                        SizedBox(height: 8.h),
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
        Tab(text: "Dashboard")
      ];
    }
  }

    List<Widget> _getTabViews(BuildContext context){
    if(role == "admin"){
      return [
        // Admin overview UI
        adminOverview(),

        // Student Tab View(Admin)
        StudentTab(),

        // Teacher Tab View(Admin)
        TeacherListScreen()
      ];
    }else if(role == "teacher"){
      return const[
        Center(
          child: Text("Teacher Overview"),
        ),
        Center(
          child: Text("My Student"),
        ),
      ];
    }else{
      return [
        Center(
          child: Text("Student Dashboard"),
        ),
      ];
    }
  }

}