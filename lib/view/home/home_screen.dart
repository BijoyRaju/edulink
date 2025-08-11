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
    final views = _getTabViews();
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
      return const [
        Tab(text: "Overview"),
        Tab(text: "Student"),
        Tab(text: "Teacher")
      ];
    }else if(role == "teacher"){
    return const [
      Tab(text: "Dashboard"),
      Tab(text: "Student")
    ];
    }else{
      return const [
        Tab(text: "Dashboard")
      ];
    }
  }

    List<Widget> _getTabViews(){
    if(role == "admin"){
      return [
        // Admin overview UI
        Center(
          child: Text("Admin Overview"),
        ),
        Center(
          child: Column(
            children: [
              ListTile(),
              FloatingActionButton(onPressed: (){},child: Icon(Icons.add))
            ],
          ),
        ),
        Center(
          child: Text("Manage Teacher"),
        ),
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
      return const[
        Center(
          child: Text("Student Dashboard"),
        ),
      ];
    }
  }

}