import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/teacher_model.dart';

class TeacherScrevice {
  final CollectionReference teacherCollection = FirebaseFirestore.instance.collection('teachers');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TeacherModel>> getTeacherByAdmin(String adminId)async{
    try{
      QuerySnapshot snapshot = await _firestore.collection('teachers').where('admin_id',isEqualTo: adminId).get();
      return snapshot.docs.map((doc){
        final data = doc.data() as Map<String,dynamic>;
        return TeacherModel.fromMap(data);
      }).toList();
    }catch(e){
      throw Exception("Failed to fetch teachers: $e");
    }
  }

  Future<void> updateTeacher(TeacherModel teacher)async{
    try{
      await _firestore.collection('teachers').doc(teacher.teacherId).update(teacher.toMap());
    }catch(e){
      throw Exception("Error in updating: $e");
    }
  }
}