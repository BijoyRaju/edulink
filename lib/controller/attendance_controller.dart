import 'dart:developer';

import 'package:edu_link/model/attendance_model.dart';
import 'package:edu_link/services/attendance_service.dart';
import 'package:flutter/material.dart';

class AttendanceController extends ChangeNotifier{
  final AttendanceService _service = AttendanceService();
  bool isLoading = false;
  String? errorMessage;
  List<AttendanceModel> attendanceList = [];

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
}