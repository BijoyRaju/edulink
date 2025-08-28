import 'package:edu_link/controller/attendance_controller.dart';
import 'package:edu_link/controller/student_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = DateTime.now().month.toString();

  final List<String> years = ["2023", "2024", "2025"];
  final Map<String, String> months = {
  "1": "January",
  "2": "February",
  "3": "March",
  "4": "April",
  "5": "May",
  "6": "June",
  "7": "July",
  "8": "August",
  "9": "September",
  "10": "October",
  "11": "November",
  "12": "December",
};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      final studentController = Provider.of<StudentController>(context,listen: false);
      await studentController.fetchCurrentStudent();
      final student = studentController.currentStudent;
      if(student != null){
      final attendanceController = Provider.of<AttendanceController>(context,listen: false);
      await attendanceController.fetchMonthlyAttendance(student.studentId, int.parse(selectedYear),int.parse(selectedMonth));
    }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceController = Provider.of<AttendanceController>(context);
    final studentController = Provider.of<StudentController>(context);
    if(studentController.isLoading ||attendanceController.isLoading){
      return const Center(child: CircularProgressIndicator());
    }
    final summary = attendanceController.monthlySummary;
    int present = summary["Present"] ?? 0;
    int absent = summary["Absent"] ?? 0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Year & Month Dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: attendanceController.selectedYear,
                  items: ["2023", "2024", "2025"].map((year) {
                  return DropdownMenuItem(value: year, child: Text(year));
                }).toList(),
                  onChanged: (value) {
                    final student = studentController.currentStudent;
                    if(student != null && value != null){
                      attendanceController.updateMonth(value, student.studentId);
                    }
                  }
                ),
                DropdownButton<String>(
                  value: attendanceController.selectdMonth,
                  items:  {"1": "January","2": "February", "3": "March","4": "April","5": "May","6": "June","7": "July",
                  "8": "August","9": "September","10": "October","11": "November","12": "December",}.
                  entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                  onChanged: (value)  {
                    final student = studentController.currentStudent;
                    if(student != null && value != null){
                      attendanceController.updateMonth(value, student.studentId);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 5.h),
            /// Pie Chart
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: present.toDouble(),
                      title: "Present",
                      color: Colors.green,
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: absent.toDouble(),
                      title: "Absent",
                      color: const Color.fromARGB(255, 237, 80, 69),
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
            ),

          SizedBox(height: 5.h),

            Text(
              "Present: $present | Absent: $absent",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
