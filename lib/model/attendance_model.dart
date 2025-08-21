import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  String attendanceId;
  String studentId;
  DateTime date;
  String status;
  String markedBy;
  String method;

  AttendanceModel({
    required this.attendanceId,
    required this.studentId,
    required this.date,
    required this.status,
    required this.markedBy,
    required this.method
  });

  Map<String,dynamic> toMap(){
    return {
      'attendance_id' : attendanceId,
      'student_id' : studentId,
      'date' : Timestamp.fromDate(date),
      'status' : status,
      'marked_by' : markedBy,
      'method' : method
    };
  }

  factory AttendanceModel.fromMap(Map<String,dynamic> map){
    return AttendanceModel(
      attendanceId: map['attendance_id'],
      studentId: map['student_id'],
      date: (map['date']as Timestamp).toDate(),
      status: map['status'],
      markedBy: map['marked_by'],
      method: map['method']
    );
  }
}