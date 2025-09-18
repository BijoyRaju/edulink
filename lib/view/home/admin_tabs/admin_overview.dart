import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/controller/teacher_controller.dart';
import 'package:edu_link/widgets/home/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AdminOverview extends StatefulWidget {
  const AdminOverview({super.key});

  @override
  State<AdminOverview> createState() => _AdminOverviewState();
}

class _AdminOverviewState extends State<AdminOverview> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final studentController = Provider.of<StudentController>(context, listen: false);
      final now = DateTime.now();
      final feeController = Provider.of<FeeController>(context, listen: false);
      feeController.fetchThisMonthRevenue();
      feeController.loadRecentTransactions();
      for (var student in studentController.students) {
        await feeController.ensureMonthlyFee(student.studentId, now.year, now.month);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final teacherController = Provider.of<TeacherController>(context);
    final studentController = Provider.of<StudentController>(context);
    final feeController = Provider.of<FeeController>(context);

    final totalTeacher = teacherController.teacher.length;
    final totalStudents = studentController.students.length;
    final totalRevenue = feeController.monthlyRevenue.toString();

    String getStudentName(String studentId) {
    if(studentController.students.isEmpty){
        return "No student found";
      }
    final student = studentController.students.firstWhere(
      (s) => s.studentId == studentId,
    );
    return student.name ?? "Unknow Teacher";
  }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  homeScreenContainerOne(
                    250.sp, 
                    150.sp, 
                    const Color(0xFFA7D0B9), 
                    "STUDENTS", 
                    "$totalStudents"
                  ),
                  Column(
                    children: [
                      homeScreenContainerTwo(
                        115.sp, 
                        150.sp, 
                        const Color(0xFF043427), 
                        "TEACHERS", 
                        "$totalTeacher"
                      ),
                      SizedBox(height: 10.h),
                      homeScreenContainerTheree(
                        115.sp, 
                        150.sp, 
                        const Color(0xFF29725E), 
                        "This month Revenue", 
                        totalRevenue
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                "Recent Transaction",
                style: TextStyle(
                  fontSize: 20.sp,
                  decoration: TextDecoration.underline,
                  color: Colors.grey,
                  decorationColor: Colors.grey
                ),
              ),
              SizedBox(height: 10.h),
              Builder(
                builder: (_) {
                  if (feeController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (feeController.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(
                        "Error: ${feeController.errorMessage}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (feeController.recentTransactions.isEmpty) {
                    return const Text("No Recent Transaction");
                  }

                  return Column(
                    children: feeController.recentTransactions.map((fee) {
                      return recentTransactionCard(
                        studentName: getStudentName(fee.studentId),
                        paymentMethod: fee.paymentMethod ?? "N/A",
                        amount: fee.amount,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
    
  }
    
}
