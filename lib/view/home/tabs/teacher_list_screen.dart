import 'package:edu_link/view/add_teacher/add_teacher_screen.dart';
import 'package:edu_link/widgets/home/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_link/controller/teacher_controller.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {

  final TeacherController controller = TeacherController();
  @override
  void initState() {
    Future.microtask((){
      Provider.of<TeacherController>(context,listen: false).fetchTeachers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TeacherController>(
        builder: (context, teacherController, child) {
          if (teacherController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
      
          if (teacherController.errorMessage != null) {
            return Center(
              child: Text(
                teacherController.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
      
          if (teacherController.teacher.isEmpty) {
            return const Center(
              child: Text("No teachers found"),
            );
          }
      
          return ListView.builder(
            itemCount: teacherController.teacher.length,
            itemBuilder: (context, index) {
              final teacher = teacherController.teacher[index];
              return customTile(teacher.name, teacher.phone, teacher.subject);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeacherScreen()));
      },child: Icon(Icons.add),),
    );
  }
}
