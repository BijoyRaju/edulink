import 'dart:developer';

import 'package:edu_link/model/attendance_model.dart';
import 'package:edu_link/services/attendance_service.dart';
import 'package:flutter/material.dart';

class AttendanceController extends ChangeNotifier{
  final AttendanceService _service = AttendanceService();
  bool isLoading = false;
  String? errorMessage;
  List<AttendanceModel> attendanceList = [];
  String selectedYear = DateTime.now().year.toString();
  String selectdMonth = DateTime.now().month.toString();

  // update Year
  void updateYear(String year,String studentId)async{
    selectedYear = year;
    await fetchMonthlyAttendance(studentId, int.parse(year), int.parse(selectdMonth));
    notifyListeners();
  }

  // Update Month
  void updateMonth(String month, String studentId)async{
    selectdMonth = month;
    await fetchMonthlyAttendance(studentId, int.parse(selectedYear), int.parse(month));
    notifyListeners();
  }

  // Fetch Attendance by Date
  Future<void> fetchAttendanceByDate(DateTime date)async{
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      attendanceList = await _service.getAttendanceByDate(date);
      log("Fetched successfully");
    }catch(e){
      errorMessage = e.toString();
      log("Error in fetching attendance $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  // Mark Attendance 
  Future<void> markAttendance(AttendanceModel attendance)async{
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      await _service.addAttendance(attendance);
      attendanceList.add(attendance);
      log("Sucess");
    }catch(e){
      errorMessage = e.toString();
      log("Error is $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  // Update Attendance
  Future<void> updateAttendance(String attendanceId,Map<String,dynamic>data)async{
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      await _service.updateAttendance(attendanceId, data);
      final index = attendanceList.indexWhere((a) => a.attendanceId == attendanceId);
      if(index != -1){
        attendanceList[index] = AttendanceModel.fromMap({
          ...attendanceList[index].toMap(),
          ...data,
        });
       }
      log("Attendance update success");
    }catch(e){
      errorMessage = e.toString();
      log("Error in update $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Attendance Monthly
  Map<String, int> monthlySummary = {
    "Present": 0,
    "Absent": 0,
    "Holiday": 0,
    "Not Set": 0,
  };
  Future<void> fetchMonthlyAttendance(String studentId,int year,int month)async{
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      final records = await _service.getAttendanceforMonth(studentId, year, month);
      monthlySummary = {
        "Present" : 0,
        "Absent" : 0,
        "Holiday" : 0,
        "Not Set" : 0
      };
      for(var record in records){
          switch (record.status) {
          case "Present":
            monthlySummary["Present"] = (monthlySummary["Present"] ?? 0) + 1;
            break;
          case "Absent":
            monthlySummary["Absent"] = (monthlySummary["Absent"] ?? 0) + 1;
            break;
          case "Holiday":
            monthlySummary["Holiday"] = (monthlySummary["Holiday"] ?? 0) + 1;
            break;
          default:
            monthlySummary["Not Set"] = (monthlySummary["Not Set"] ?? 0) + 1;
        }
      }
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
}