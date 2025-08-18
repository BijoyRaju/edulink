import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/student_model.dart';

class StudentService {
    final CollectionReference studentCollection = FirebaseFirestore.instance.collection('students');
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch current student
  Future<StudentModel?> getCurrentStudent(String studentId)async{
    try{
      DocumentSnapshot doc = await _firestore.collection('student').doc(studentId).get();
      if(doc.exists){
        final data = doc.data() as Map<String,dynamic>;
        return StudentModel.fromMap(data);
      }
      return null;
    }catch(e){
      throw Exception("Error in fetching student: $e");
    }
  }

  // Fetch Student by admin
  Future<List<StudentModel>> getStudentsByAdmin(String adminId)async{
    try{
      QuerySnapshot snapshot = await _firestore.collection('students').where('admin_id',isEqualTo: adminId).get();
      return snapshot.docs.map((doc){
        final data = doc.data() as Map<String,dynamic>;
        return StudentModel.fromMap(data);
      }).toList();
    }catch(e){
      throw Exception("Failed to fetch Students: $e");
    }
  }

  // Fetch Student by teacher
  Future<List<StudentModel>> getStudentsByTeacher(String teacherId)async{
    try{
      QuerySnapshot snapshot = await _firestore.collection('students').where('teacher_id',isEqualTo: teacherId).get();
      return snapshot.docs.map((doc){
        final data = doc.data() as Map<String,dynamic>;
        return StudentModel.fromMap(data);
      }).toList();
    }catch(e){
      throw Exception("Failed to fetch Students : $e");
    }
  }

  // Update Student
  Future<void> updateStudents(StudentModel student)async{
    try{
      await _firestore.collection('students').doc(student.studentId).update(student.toMap());
    }catch(e){
      throw Exception("Error in updating: $e");
    }
  }

}