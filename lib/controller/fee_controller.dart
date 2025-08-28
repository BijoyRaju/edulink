import 'package:edu_link/model/fee_model.dart';
import 'package:edu_link/services/fee_service.dart';
import 'package:edu_link/services/student_service.dart';
import 'package:flutter/cupertino.dart';

class FeeController extends ChangeNotifier{
  final FeeService _feeService = FeeService();
  final StudentService _studentService = StudentService();
  List<FeeModel> studentFees = [];
  List<FeeModel> pendingFees = [];
  bool isLoading = false;
  String errorMessage = "";

  // Fetch Fees for student
  Future<void> fetchFees(String studentId)async{
    isLoading = true;
    notifyListeners();
    try{
      studentFees = await _feeService.getFeesByStudent(studentId);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllFees() async {
  isLoading = true;
  notifyListeners();
  try {
    final allFees = await _feeService.getAllFees(); 
    studentFees = allFees;
    pendingFees = allFees.where((f) => f.status == "Pending").toList();
  } catch (e) {
    errorMessage = e.toString();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  Future<void> saveFees(FeeModel fee)async{
    try{
    await _feeService.saveFee(fee);
    await fetchFees(fee.studentId);
    }catch(e){
      errorMessage = e.toString();
    }
  }

   Future<void> fetchPendingFees(String studentId) async {
  isLoading = true;
  notifyListeners();
  try {
    pendingFees = await _feeService.getPendingFees(studentId);
  } catch (e) {
    errorMessage = e.toString();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  Future<void> ensureMonthlyFee(String studentId, int year, int month) async {
  final fees = await _feeService.getFeesByStudent(studentId);

  final alreadyExists = fees.any(
    (f) => f.month.year == year && f.month.month == month,
  );

  if (!alreadyExists) {
    final newFee = FeeModel(
      feeId: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: studentId,
      transactionId: "",
      amount: 5000,
      status: "Pending",
      paidOn: DateTime(2000), 
      month: DateTime(year, month, 1),
    );
    await _feeService.saveFee(newFee);
  }
}


}