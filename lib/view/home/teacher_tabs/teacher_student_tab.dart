import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/view/student/add_student_screen.dart';
import 'package:edu_link/view/student/student_view_screen.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:edu_link/widgets/home/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TeacherStudentTab extends StatefulWidget {
  const TeacherStudentTab({super.key});

  @override
  State<TeacherStudentTab> createState() => _TeacherStudentTabState();
}

class _TeacherStudentTabState extends State<TeacherStudentTab> {

  @override
  void initState() {
    Future.microtask((){
      if(mounted){
      Provider.of<StudentController>(context,listen: false).fetchStudentByTeacher();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StudentController>(
        builder: (context,studentController,child){
          if(studentController.isLoading){
            return const Center(child: CircularProgressIndicator());
          }if(studentController.students.isEmpty){
            return const Center(child: Text("No Students found"));
          }if(studentController.errorMessage != null){
            return Center(
              child: customText(text: studentController.errorMessage!,color: Colors.red, fontSize: 16.sp),
            );
          }
          return ListView.builder(
            itemCount: studentController.students.length,
            itemBuilder: (context,index){
              final student = studentController.students[index];
              return customTileStudent(student.name, student.phone, student.stdClass,
              (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => StudentViewScreen(student: student,)));
              });
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudentScreen()));
      },child: Icon(Icons.add),),
    );
  }
}