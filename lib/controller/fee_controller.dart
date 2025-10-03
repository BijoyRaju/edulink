import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/fee_model.dart';
import 'package:edu_link/services/fee_service.dart';
import 'package:edu_link/services/student_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class FeeController extends ChangeNotifier{
  final FeeService _feeService = FeeService();
  List<FeeModel> studentFees = [];
  List<FeeModel> pendingFees = [];
  List<FeeModel> recentTransactions = [];
  bool isLoading = false;
  String errorMessage = "";
  FeeModel? selectedFee;
  double monthlyRevenue = 0;

  static const String _appId = "322f33fa-72f3-4bfc-a290-cbcc67cc80a7";
  static const String _restApiKey = "os_v2_app_gixth6ts6nf7ziuqzpggpteau5omafxsnczuxdvfd6xug36bkkziuipfzj7oabz7iupdm3e56pnnsfan6t3d7pslzkpka2gxbhi7ywq";

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
      //  send notification if pending
      if (fee.status == "Pending") {
        await _sendPendingFeeNotification(fee);
      }
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
     // Get current adminId
    final prefs = await SharedPreferences.getInstance();
     final adminId = prefs.getString('userId');
    if (adminId == null) {
      throw Exception("Admin not logged in");
    }

    // Get all students under this admin
    final studentService = StudentService();
    final students = await studentService.getStudentsByAdmin(adminId);
    final studentIds = students.map((s) => s.studentId).toList();
    
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


  Future<void> saveFees(FeeModel fee)async{
    isLoading = true;
    notifyListeners();
    try{
    await _feeService.saveFee(fee);
    // Send notification
    if (fee.status == "Pending") {
        await _sendPendingFeeNotification(fee);
    }
    await fetchFees(fee.studentId);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
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
        paidOn: null, 
        month: DateTime(year, month, 1),
      );
      await _feeService.saveFee(newFee);

      await fetchFees(studentId);
      // Send Notification
      await _sendPendingFeeNotification(newFee);
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
    final prefs = await SharedPreferences.getInstance();
    final adminId = prefs.getString('userId');
    if (adminId == null) throw Exception("Admin not logged in");

    final studentService = StudentService();
    final students = await studentService.getStudentsByAdmin(adminId);
    final studentIds = students.map((s) => s.studentId).toList();
    monthlyRevenue = await _feeService.getThisMonthRevenue(studentIds);
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
    final prefs = await SharedPreferences.getInstance();
    final adminId = prefs.getString('userId');
    if (adminId == null) throw Exception("Admin not logged in");

    final studentService = StudentService();
    final students = await studentService.getStudentsByAdmin(adminId);
    final studentIds = students.map((s) => s.studentId).toList();
      recentTransactions = await _feeService.fetchRecentTransactions(studentIds);
      notifyListeners();
    }catch(e){
      errorMessage = e.toString();
    }
  }



  // OneSignal Notification
    Future<void> _sendPendingFeeNotification(FeeModel fee) async {
    try {
      // final targetUserId = fee.studentId;
      final response = await http.post(
        Uri.parse("https://api.onesignal.com/notifications"),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": "Basic $_restApiKey",
        },
        body: jsonEncode({
          "app_id": _appId,
          "included_segments": ["All"],
          // "include_external_user_ids": [targetUserId], 
          "headings": {"en": "Pending Fee"},
          "contents": {
            "en":
                "Your fee payment for ${fee.month} is pending. Fee Amount is ₹${fee.amount}"
          },
        }),
      );
      log("OneSignal response: ${response.body}");
    } catch (e) {
      log("Error in sending Notification: $e");
    }
  }

  // For selected student
  Future<void> sendPendingFeeNotificationToStudent(FeeModel fee, String studentId) async {
  try {
    // Get student FCM token from Firestore
    final doc = await FirebaseFirestore.instance.collection("users").doc(studentId).get();
    final token = doc.data()?["fcmToken"];

    if (token == null) {
      print("No FCM token found for this student.");
      return;
    }

    // Send push using Firebase Cloud Messaging HTTP v1 API
    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=YOUR_SERVER_KEY", // from Firebase project settings → Cloud Messaging → Legacy key
      },
      body: jsonEncode({
        "to": token,
        "notification": {
          "title": "Pending Fee",
          "body": "Your fee payment for ${fee.month} is pending. Amount: ₹${fee.amount}"
        },
        "data": { // optional payload
          "feeId": fee.feeId,
          "amount": fee.amount,
        },
      }),
    );

    print("Firebase response: ${response.body}");
  } catch (e) {
    print("Error sending FCM: $e");
  }
}

}