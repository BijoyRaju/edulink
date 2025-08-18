import 'package:edu_link/model/teacher_model.dart';
import 'package:edu_link/services/teacher_screvice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherController extends ChangeNotifier{
  final TeacherScrevice _teacherScrevice = TeacherScrevice();
  List<TeacherModel> _teachers = [];
  TeacherModel? _currentTeacher;
  bool _isLoading = false;
  String? _errorMessage;

  List<TeacherModel> get teacher => _teachers;
  TeacherModel? get currentTeacher => _currentTeacher;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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


}