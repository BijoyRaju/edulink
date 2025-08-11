import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/admin_model.dart';
import 'package:edu_link/model/student_model.dart';
import 'package:edu_link/model/teacher_model.dart';
import 'package:edu_link/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
   
   // Register Admin
   Future<String> registerAdmin({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phoneNo,
    required String schoolName
   })async{
    try{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

    // Save in User Collection
    String uid = userCredential.user!.uid;
    UserModel userModel = UserModel(uid: uid, name: name, email: email, role: role);
    await _db.collection('users').doc(uid).set(userModel.toMap());

    // Save in Admin Collection
    AdminModel adminModel = AdminModel(adminId: uid, name: name, email: email, phoneNo: phoneNo, schoolName: schoolName);
    await _db.collection('admins').doc(uid).set(adminModel.toMap());
    
    return "success";
   }on FirebaseAuthException catch(e){
    return e.message ?? "Registration Failed";
   }
   catch(e){
    return e.toString();
   }
   }

  // Register Teacher
   Future<String> registerTeacher({
    required String adminId,
    required String name,
    required String password,
    required String email,
    required String phone,
    required String subject,
    required DateTime dateOfBirth,
    required DateTime joinDate,
    required String additionalInfo,
    required String role
   })async{
    try{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

    // Save in User Collection
    String uid = userCredential.user!.uid;
    UserModel userModel = UserModel(uid: uid, name: name, email: email, role: role);
    await _db.collection('users').doc(uid).set(userModel.toMap());

    // Save in teacher Collection
    TeacherModel teacherModel = TeacherModel(teacherId: uid, adminId: adminId, name: name, email: email, phone: phone, subject: subject, dateOfBirth: dateOfBirth, joinDate: joinDate, additionalInfo: additionalInfo);
    await _db.collection('teachers').doc(uid).set(teacherModel.toMap());
    
    return "success";
   }on FirebaseAuthException catch(e){
    return e.message ?? "Registration Failed";
   }
   catch(e){
    return e.toString();
   }
   }

   // Register Student
   Future<String> registerStudent({
    required String adminId,
    required String teacherId,
    required String name,
    required String email,
    required String password,
    required String stdClass,
    required String parentName,
    required String phone,
    required String profileImage,
    required String rollNo,
    required DateTime dateOfBirth,
    required DateTime admissionDate,
    required String role
    })async{
      try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      // Save in User Collection
      String uid = userCredential.user!.uid;
      UserModel userModel = UserModel(uid: uid, name: name, email: email, role: role);
      await _db.collection('users').doc(uid).set(userModel.toMap());

      // Save in student Collection
      StudentModel studentModel = StudentModel(studentId: uid, adminId: adminId, teacherId: teacherId, name: name,stdClass: stdClass, email: email, parentName: parentName, phone: phone, profileImage: profileImage, rollNo: rollNo, dateOfBirth: dateOfBirth, admissionDate: admissionDate);
      await _db.collection('teachers').doc(uid).set(studentModel.toMap());
      
      return "success";
    }on FirebaseAuthException catch(e){
      return e.message ?? "Registration Failed";
    }
    catch(e){
      return e.toString();
    }
    }



   // Login User 
   Future<Map<String,dynamic>> loginUser({required String email,required String password})async{
    try{
      UserCredential userCred =  await _auth.signInWithEmailAndPassword(email: email, password: password);
      String uid = userCred.user!.uid;

      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
      if(!userDoc.exists){
        return {"Status" :"error" , "message" : "User data not Found"};
      }
      String role = userDoc['role'];
      return {"status" : "success", "role" : role};
    }on FirebaseException catch(e){
      return {"status" : "error", "message" : e.message ?? "Login Failed"};
    }catch(e){
      return {"status" : "error", "message" :e.toString()};
    }
   }


}