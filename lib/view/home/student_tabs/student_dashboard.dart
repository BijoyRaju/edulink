import 'package:edu_link/controller/attendance_controller.dart';
import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/widgets/home/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) async {
    final studentController = Provider.of<StudentController>(context, listen: false);
    await studentController.fetchCurrentStudent();
    final student = studentController.currentStudent;

    if (student != null) {
      if(mounted){
      final attendanceController = Provider.of<AttendanceController>(context,listen: false);
      final now = DateTime.now();
      await attendanceController.fetchMonthlyAttendance(student.studentId, now.year, now.month);
      }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentController = Provider.of<StudentController>(context);
    final student = studentController.currentStudent;
    final attendanceController = Provider.of<AttendanceController>(context);
    final summary = attendanceController.monthlySummary;

    if (studentController.isLoading ) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    

    if (studentController.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(studentController.errorMessage!),
        ),
      );
    }

    if (student == null) {
      return const Scaffold(
        body: Center(child: Text("No student data found")),
      );
    }

    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              studentInfo(
                studentName: student.name,
                stdClass: student.stdClass,
                rollNo: student.rollNo,
                parentName: student.parentName,
                phoneNo: student.phone
              ),
              attendanceController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : studentAttendanceContainer(present: summary["Present"]?.toString() ?? "0", absent: summary["Absent"]?.toString() ?? "0")
            ],
          ),
        ],
      ),
    );
  }
}
