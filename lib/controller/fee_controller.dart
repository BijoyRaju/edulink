import 'package:edu_link/model/fee_model.dart';
import 'package:edu_link/services/fee_service.dart';
import 'package:flutter/cupertino.dart';

class FeeController extends ChangeNotifier{
  final FeeService _feeService = FeeService();
  List<FeeModel> studentFees = [];
  List<FeeModel> pendingFees = [];
  List<FeeModel> recentTransactions = [];
  bool isLoading = false;
  String errorMessage = "";
  FeeModel? selectedFee;
  double monthlyRevenue = 0;

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

   Future<void> updateFee(FeeModel fee) async {
    isLoading = true;
    notifyListeners();
    try {
      await _feeService.updateFee(fee);
      await fetchFees(fee.studentId); 
    } catch (e) {
      errorMessage = e.toString();
    } finally {
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

  Future<void> loadFee(String feeId) async {
  isLoading = true;
  notifyListeners();
  errorMessage = "";
  try {
    selectedFee = await _feeService.getFeeById(feeId);
  } catch (e) {
    errorMessage = e.toString();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  Future<FeeModel?> fetchFeeById(String feeId) async {
  isLoading = true;
  notifyListeners();
  try {
    final fee = await _feeService.getFeeById(feeId);
    return fee;
  } catch (e) {
    errorMessage = e.toString();
    return null;
  } finally {
    isLoading = false;
    notifyListeners();
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
  isLoading = true;
  notifyListeners();
  try {
    final fees = await _feeService.getFeesByStudent(studentId);

    final alreadyExists = fees.any(
      (f) => f.month != null && f.month!.year == year && f.month!.month == month,
    );

    if (!alreadyExists) {
      final newFee = FeeModel(
        feeId: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: studentId,
        transactionId: "",
        amount: 5000,
        status: "Pending",
        paymentMethod: "",
        paidOn: DateTime(2000), 
        month: DateTime(year, month, 1),
      );
      await _feeService.saveFee(newFee);

      await fetchFees(studentId);
    }
  } catch (e) {
    errorMessage = "Error in ensureMonthlyFee: $e";
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

// Fetch fees for multiple students
Future<void> fetchFeesForStudents(List<String> studentIds) async {
  isLoading = true;
  notifyListeners();

  try {
    final allFees = await _feeService.getFeesForStudents(studentIds);
    studentFees = allFees;
    pendingFees = allFees.where((f) => f.status == "Pending").toList();
  } catch (e) {
    errorMessage = e.toString();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  Future<void> markFeeAsPaid({
    required String feeId,
    required String transactionId,
    String paymentMethod = "Razorpay",
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final fee = await _feeService.getFeeById(feeId);
      if (fee != null) {
        final updatedFee = FeeModel(
          feeId: fee.feeId,
          studentId: fee.studentId,
          transactionId: transactionId,
          amount: fee.amount,
          status: "Paid",
          paymentMethod: paymentMethod,
          paidOn: DateTime.now(),
          month: fee.month,
        );

        await _feeService.updateFee(updatedFee);
        await fetchFees(fee.studentId); 
      }
    } catch (e) {
      errorMessage = "Error marking fee as paid: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch This month revenue
  Future<void> fetchThisMonthRevenue() async {
  isLoading = true;
  notifyListeners();
  try {
    monthlyRevenue = await _feeService.getThisMonthRevenue();
  } catch (e) {
    errorMessage = e.toString();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

// Fetch Recent Transaction
  Future<void> loadRecentTransactions() async {
    try{
      recentTransactions = await _feeService.fetchRecentTransactions();
      notifyListeners();
    }catch(e){
      errorMessage = e.toString();
    }
  }

}