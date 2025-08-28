import 'package:edu_link/model/teacher_model.dart';
import 'package:edu_link/services/auth_service.dart';
import 'package:edu_link/services/teacher_screvice.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherController extends ChangeNotifier{
  final TeacherScrevice _teacherScrevice = TeacherScrevice();
  final AuthService _authService = AuthService();
  List<TeacherModel> _teachers = [];
  TeacherModel? _currentTeacher;
  bool _isLoading = false;
  String? _errorMessage;

  List<TeacherModel> get teacher => _teachers;
  TeacherModel? get currentTeacher => _currentTeacher;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final schoolController = TextEditingController();
  final rePasswordController = TextEditingController();
  final subjectController = TextEditingController();
  final additinalInfoController = TextEditingController();
  final dobController = TextEditingController();
  final joinDateController = TextEditingController();

  DateTime? dateOfBirth;
  DateTime? joinDate;


  /// Register Teacher
  Future<void> registerTeacher(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminId = prefs.getString("userId");

    if (adminId == null) {
      if (context.mounted) {
        showSnackBarMessage(context, "Admin not logged in");
      }
      return;
    }

    try {
      String result = await _authService.registerTeacher(
        adminId: adminId,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        subject: subjectController.text.trim(),
        password: passwordController.text.trim(),
        dateOfBirth: dateOfBirth!,
        joinDate: joinDate!,
        additionalInfo: additinalInfoController.text.trim(),
        role: "teacher",
      );

      if (context.mounted) {
        if (result == "success") {
          showSnackBarMessage(context, "Teacher registered successfully");
          clearController();
          await fetchTeachers();
        } else {
          showSnackBarMessage(context, result);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBarMessage(context, "Error registering teacher: $e");
      }
    }
  }

  // Fetch Current Teacher
  Future<void> fetchCurrentTeacher()async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final teacherId = prefs.getString("userId");
      if(teacherId == null){
        throw Exception("Teacher not logged In");
      }
      _currentTeacher = await _teacherScrevice.getTeacherById(teacherId);
    }catch(e){
      _errorMessage = e.toString();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Teacher By ID
  Future<void> fetchTeachers()async{
    _isLoading = true;
     _errorMessage= null;
    notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final adminId = prefs.getString('userId');
      if(adminId == null){
        throw Exception("Admin not logged In");
      }
      _teachers = await _teacherScrevice.getTeacherByAdmin(adminId);
    }catch(e){
      _errorMessage = e.toString();
    }finally{
    _isLoading = false;
    notifyListeners();
    }
  }

  // Update Teacher
  Future<void> updateTeacher(TeacherModel teacher)async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      await _teacherScrevice.updateTeacher(teacher);
      await fetchTeachers();
    }catch(e){
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }


    /// Clear Input Controllers
  void clearController() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    subjectController.clear();
    additinalInfoController.clear();
    passwordController.clear();
    rePasswordController.clear();
    dobController.clear();
    joinDateController.clear();
    dateOfBirth = null;
    joinDate = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    additinalInfoController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    dobController.dispose();
    joinDateController.dispose();
    super.dispose();
  }
}
