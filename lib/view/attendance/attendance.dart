import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/controller/attendance_controller.dart';
import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/model/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  DateTime selectedDate = DateTime.now();
  List<String> statuses = ["Not Set","Holiday","Present","Absent"];
  String get formattedDate => DateFormat("dd-MM-yyyy").format(selectedDate);

  @override
  void initState() {
    Future.microtask((){
      if(mounted){
      final attendanceController = context.read<AttendanceController>();
      attendanceController.fetchAttendanceByDate(selectedDate);
      final stuudentController = context.read<StudentController>();
      stuudentController.fetchStudentByTeacher();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceController = context.watch<AttendanceController>();
    final studentController = context.watch<StudentController>();
    if(studentController.students.isEmpty && !studentController.isLoading){
      studentController.fetchStudentByTeacher();
    }
    if(attendanceController.attendanceList.isEmpty && !attendanceController.isLoading){
      attendanceController.fetchAttendanceByDate(selectedDate);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Take Attendance"),
        backgroundColor: Color(0xFF254F43),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),

          // Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _previousDay,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                onPressed: _nextDay,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.sp,
              children: statuses.map((status) {
                return ChoiceChip(
                  label: Text(status),
                  selected: false,
                  selectedColor: _getStatusColor(status),
                  onSelected: (_) {
                    setState(() {
                      for (var student in studentController.students) {
                        attendanceController.updateAttendance(
                          student.studentId,
                          {"status": status, "date": Timestamp.fromDate(DateTime(selectedDate.year, selectedDate.month, selectedDate.day))}
                        );
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Expanded(
            child:studentController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: studentController.students.length,
                itemBuilder: (context,index){
                  final student = studentController.students[index];
                  final attendance = attendanceController.attendanceList.firstWhere(
                    (a) => a.studentId == student.studentId &&
                          a.date.year == selectedDate.year &&
                          a.date.month == selectedDate.month &&
                          a.date.day == selectedDate.day,
                    orElse: () => AttendanceModel(
                      attendanceId: "",
                      studentId: student.studentId,
                      date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
                      status: "Not Set",
                      markedBy: "",
                      method: "Manual"
                    )
                  );

                  return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${student.rollNo}. ${student.name}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Text("Class: ${student.stdClass}"),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 5.sp,
                          children: statuses.map((status) {
                            return ChoiceChip(
                              label: Text(status),
                              selected: attendance.status == status,
                              selectedColor: _getStatusColor(status),
                              labelStyle: TextStyle(
                                color: attendance.status == status
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (_) {
                                    setState(() {
                                      final existing = attendanceController.attendanceList.firstWhere(
                                        (a) => a.studentId == student.studentId &&
                                              DateFormat("dd-MM-yyyy").format(a.date) == formattedDate,
                                        orElse: () => AttendanceModel(
                                          attendanceId: "",
                                          studentId: student.studentId,
                                          date: selectedDate,
                                          status: "Not Set",
                                          markedBy: "",
                                          method: "Manual",
                                        ),
                                      );

                                      if (existing.attendanceId.isEmpty) {
                                        attendanceController.markAttendance(
                                          AttendanceModel(
                                            attendanceId: DateTime.now().microsecondsSinceEpoch.toString(),
                                            studentId: student.studentId,
                                            date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
                                            status: status,
                                            markedBy: "",
                                            method: "Manual",
                                          ),
                                        );
                                      } else {
                                        attendanceController.updateAttendance(
                                          existing.attendanceId,
                                          {"status": status},
                                        );
                                      }
                                    });
                                  },

                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                );
                }
              )
          )
        ]
      )
    );
  }
    // 🎨 Status → Color mapping
  Color _getStatusColor(String status) {
    switch (status) {
      case "Holiday":
        return Colors.purple;
      case "Present":
        return Colors.green;
      case "Absent":
        return Colors.red;
      default:
        return Colors.teal;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      if(mounted) context.read<AttendanceController>().fetchAttendanceByDate(selectedDate);
    }
  }

  void _previousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
    context.read<AttendanceController>().fetchAttendanceByDate(selectedDate);
  }

  void _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
    context.read<AttendanceController>().fetchAttendanceByDate(selectedDate);
  }
}