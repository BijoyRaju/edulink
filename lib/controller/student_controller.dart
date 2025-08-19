import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/student_model.dart';
import 'package:edu_link/services/auth_service.dart';
import 'package:edu_link/services/student_service.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentController extends ChangeNotifier {

  final AuthService _authService = AuthService();
  final StudentService _studentService = StudentService();
  List<StudentModel> _students = [];
  bool _isLoading = false;
  String? _errorMessage;
  StudentModel? _currentStudent;

  List<StudentModel> get students => _students;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  StudentModel? get currentStudent => _currentStudent;


  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final parentNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final classController = TextEditingController();
  final rollNoController = TextEditingController();
  final profileImageController = TextEditingController();
  final passwordController = TextEditingController();
  final reEnterPassword = TextEditingController();
  final dobController = TextEditingController();
  final admissionDateController = TextEditingController();

  DateTime? dateOfBirth;
  DateTime? admissionDate;

  String? selectedTeacherId;

// Register Student
  Future<void> registerStudent(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    String? currentUserId = prefs.getString('userId');

    if (currentUserId == null || role == null) {
      if (context.mounted) {
        showSnackBarMessage(context, "User not logged in");
      }
      return;
    }

    String adminId = "";
    String teacherId = "";

  if (context.mounted) {
  if (role == "admin") {
    adminId = currentUserId;
    if (selectedTeacherId == null) {
      showSnackBarMessage(context, "Please select a teacher");
      return;
    }
    teacherId = selectedTeacherId!;
  } else if (role == "teacher") {
    teacherId = currentUserId;
    DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(currentUserId)
        .get();
    if (!teacherDoc.exists) {
      if(context.mounted){
      showSnackBarMessage(context, "Teacher data not found");
      }
      return;
    }
    adminId = teacherDoc["admin_id"];
  } else {
    showSnackBarMessage(context, "Invalid user role");
    return;
  }
}


    String result = await _authService.registerStudent(
      adminId: adminId,
      teacherId: teacherId,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      stdClass: classController.text.trim(),
      parentName: parentNameController.text.trim(),
      phone: phoneNumberController.text.trim(),
      profileImage: profileImageController.text.trim(),
      rollNo: rollNoController.text.trim(),
      dateOfBirth: dateOfBirth!,
      admissionDate: admissionDate!,
      role: 'student',
    );

    if (context.mounted) {
      if (result == "success") {
        showSnackBarMessage(context, "Student registered successfully");
        clearController();
      } else {
        showSnackBarMessage(context, result);
      }
    }
  }

  // Fetch Current Student
  Future<void> fetchCurrentStudent()async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final studentId = prefs.getString("userId");
      if(studentId == null){
        throw Exception("Student not found");
      }
      _currentStudent = await _studentService.getCurrentStudent(studentId);
    }catch(e){
      _errorMessage = e.toString();
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }

  // View Students
  Future<void> fetchStudents()async{
    _isLoading = true;
     _errorMessage= null;
    notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final adminId = prefs.getString('userId');
      if(adminId == null){
        throw Exception("Admin not logged In");
      }
      _students = await _studentService.getStudentsByAdmin(adminId);
    }catch(e){
      _errorMessage = e.toString();
    }finally{
    _isLoading = false;
    notifyListeners();
    }
  }

  // Fetch Student by Teacher
  Future<void>fetchStudentByTeacher()async{
    _isLoading = true;
    notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final teacherId = prefs.getString("userId");
      if(teacherId == null){
        throw Exception("Teacher not logged in");
      }
      _students = await _studentService.getStudentsByTeacher(teacherId);
    }catch(e){
      _errorMessage = e.toString();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }


  // Update Students
  Future<void> updateStudent(StudentModel student)async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      await _studentService.updateStudents(student);
      await fetchStudents();
    }catch(e){
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }


  void clearController() {
    nameController.clear();
    emailController.clear();
    parentNameController.clear();
    phoneNumberController.clear();
    classController.clear();
    rollNoController.clear();
    dateOfBirth = null;
    admissionDate = null;
    passwordController.clear();
    profileImageController.clear();
    selectedTeacherId = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    parentNameController.dispose();
    phoneNumberController.dispose();
    classController.dispose();
    rollNoController.dispose();
    passwordController.dispose();
    profileImageController.dispose();
    super.dispose();
  }
}
