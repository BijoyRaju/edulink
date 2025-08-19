import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/attendance_model.dart';

class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add attendance
  Future<void> addAttendace(AttendanceModel attendance)async{
    try{
    await _db.collection("attendance").doc(attendance.attendanceId).set(attendance.toMap());
    }catch(e){
      throw Exception("Failed to add attendance: $e");
    }
  }

  // Get attendance for a specific student
  Future<AttendanceModel?> getAttendance(String studentId,DateTime date)async{
    try{
    final snapshot = await _db.collection("attendance")
                      .where("student_id",isEqualTo: studentId)
                      .where("date",isEqualTo: date)
                      .limit(1)
                      .get();
    if(snapshot.docs.isEmpty){
      return AttendanceModel.fromMap(snapshot.docs.first.data());
    }
    return null;
    }catch(e){
      throw Exception("Failed to fetch attendance: $e");
    }
  }

  // Fetch attendance for all student
  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date) async {
    try{
    final snapshot = await _db
        .collection('attendance')
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
    }catch(e){
      throw  Exception("Failed to fetch attendance: $e");
    }
  }

  // Update Attendance
  Future<void> updateAttendance(String attendanceId,Map<String,dynamic>data)async{
    try{
    await _db.collection("attendance").doc("attendanceId").update(data);
    }catch(e){
      throw Exception("Failed to update attendance: $e");
    }
  }

  // Delete Attendance
  Future<void> deleteAttendance(String attendandeId)async{
    try{
      await _db.collection("attendance").doc(attendandeId).delete();
    }catch(e){

    }
  }



}