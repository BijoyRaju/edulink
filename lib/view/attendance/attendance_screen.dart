import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime selectedDate = DateTime.now();
  List<String> statuses = ["Not Set", "Holiday", "Present", "Absent"];

  // Example student list
  List<Map<String, dynamic>> students = [
    {"roll": 1, "name": "John Doe", "class": "10 A", "status": "Not Set"},
    {"roll": 2, "name": "Jane Smith", "class": "10 A", "status": "Not Set"},
    {"roll": 3, "name": "Alex Lee", "class": "10 A", "status": "Not Set"},
  ];

  String get formattedDate => DateFormat('yyyy-MM-dd').format(selectedDate);

  @override
  Widget build(BuildContext context) {
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
              IconButton(onPressed: _previousDay, icon: const Icon(Icons.arrow_back_ios)),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(onPressed: _nextDay, icon: const Icon(Icons.arrow_forward_ios)),
            ],
          ),

          const SizedBox(height: 10),

          // Set All Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.sp,
              children: statuses.map((status) {
                return ChoiceChip(
                  label: Text(status),
                  selected: false,
                  onSelected: (_) {
                    setState(() {
                      for (var s in students) {
                        s["status"] = status;
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),

          const Divider(),
          // Student List
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${student['roll']}. ${student['name']}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Class: ${student['class']}"),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 5.sp,
                          children: statuses.map((status) {
                            return ChoiceChip(
                              label: Text(status),
                              selected: student["status"] == status,
                              selectedColor: Colors.teal,
                              onSelected: (_) {
                                setState(() {
                                  student["status"] = status;
                                });
                              },
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
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
    }
  }

  void _previousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }
}
