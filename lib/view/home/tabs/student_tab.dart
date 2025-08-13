import 'package:edu_link/view/add_student/add_student_screen.dart';
import 'package:edu_link/widgets/home/home_widget.dart';
import 'package:flutter/material.dart';

class StudentTab extends StatefulWidget {
  const StudentTab({super.key});

  @override
  State<StudentTab> createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customTile("", "","")
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudentScreen()));
      },child: Icon(Icons.add),),
    );
  }
}