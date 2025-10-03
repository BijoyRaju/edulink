import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/fee_model.dart';

class FeeService {
  final _firestore = FirebaseFirestore.instance;
  final _collection = "fees";

 Future<void> saveFee(FeeModel fee) async {
    try {
      await _firestore.collection(_collection).doc(fee.feeId).set({
        ...fee.toMap(),
        "paid_on": fee.paidOn != null ? Timestamp.fromDate(fee.paidOn!) : null,
        "month": fee.month != null ? Timestamp.fromDate(fee.month!) : null,
      });
    } catch (e) {
      throw Exception("Error in saving fees $e");
    }
  }

  // Update Fee
   Future<void> updateFee(FeeModel fee) async {
    try {
      await _firestore.collection(_collection).doc(fee.feeId).update({
        ...fee.toMap(),
        "paid_on": fee.paidOn != null ? Timestamp.fromDate(fee.paidOn!) : null,
        "month": fee.month != null ? Timestamp.fromDate(fee.month!) : null,
      });
    } catch (e) {
      throw Exception("Error in updating fee $e");
    }
  }


  // Get All Fees
   Future<List<FeeModel>> getAllFees() async {
    try{
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => FeeModel.fromMap(doc.data())).toList();
    }catch(e){
      log("Error in fetching students fees: $e");
      throw Exception("Error in fetching all  fees: $e");
    }
  }

  Future <FeeModel?> getFeeById(String feeId)async{
    try{
      final doc = await _firestore.collection(_collection).doc(feeId).get();
      if(doc.exists){
        return FeeModel.fromMap(doc.data()!);
      }
      return null;
    }catch(e){
      throw Exception("Error in fetching fees $e");
    }
  }

  Future<List<FeeModel>> getFeesByStudent(String studentId)async{
    try{
      final query = await _firestore.collection(_collection).where("student_id",isEqualTo: studentId).get();
      return query.docs.map((doc) => FeeModel.fromMap(doc.data())).toList();
    }catch(e){
      throw Exception("Error in fetching fees $e");
    }
  }

  // Get Pending Fees
  Future<List<FeeModel>> getPendingFees(String studentId)async{
    try{
      final query = await _firestore.collection(_collection).where("student_id",isEqualTo: studentId)
        .where("status",isEqualTo: "Pending").get();
      return query.docs.map((doc) => FeeModel.fromMap(doc.data())).toList();
    }catch(e){
      throw Exception("Error in fetching pending fees $e");
    }
  }


  // Fetch all fees for a list of students
  Future<List<FeeModel>> getFeesForStudents(List<String> studentIds) async {
  try {
    if (studentIds.isEmpty) return [];
    final query = await _firestore
        .collection(_collection)
        .where("student_id", whereIn: studentIds)
        .get();

    return query.docs.map((doc) => FeeModel.fromMap(doc.data())).toList();
  } catch (e) {
    throw Exception("Error fetching fees for students: $e");
  }
}

// Revenue this Month
  Future<double> getThisMonthRevenue(List<String> studentIds) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      // Simplified query to avoid composite index requirement
      final query = await _firestore
            .collection(_collection)
            .where("student_id", whereIn: studentIds)
            .where("status", isEqualTo: "Paid")
              .get();

      // Filter by date in application code to avoid composite index
      final paidDocs = query.docs.where((doc) {
        final data = doc.data();
        final paidOn = data["paid_on"] as Timestamp?;
        if (paidOn == null) return false;
        
        final paidDate = paidOn.toDate();
        return paidDate.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
               paidDate.isBefore(startOfNextMonth);
      });

      double total = 0;
      for (var doc in paidDocs) {
        final data = doc.data();
        total += (data["amount"] as num).toDouble();
      }

      return total;
    } catch (e) {
      log("Error Fetching Monthly revenue: $e");
      throw Exception("Error fetching monthly revenue: $e");
    }
  }

  // Recent Transaction
  Future<List<FeeModel>> fetchRecentTransactions(List<String> studentIds) async {
    try {
      // Simplified query to avoid composite index requirement
      final snapshot = await _firestore
          .collection(_collection)
          .where("student_id", whereIn: studentIds)
          .where("status", isEqualTo: "Paid") 
          .get();

      // Sort and limit in application code to avoid composite index
      final paidDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        return data["paid_on"] != null; // Only include documents with paid_on
      }).toList();

      // Sort by paid_on in descending order
      paidDocs.sort((a, b) {
        final aDate = (a.data()["paid_on"] as Timestamp).toDate();
        final bDate = (b.data()["paid_on"] as Timestamp).toDate();
        return bDate.compareTo(aDate); // Descending order
      });

      // Take only the first 5
      final limitedDocs = paidDocs.take(5).toList();

      return limitedDocs.map((doc) => FeeModel.fromMap(doc.data())).toList();
    } catch (e) {
      log("Error in recent transaction: $e");
      throw Exception("Error fetching recent transactions: $e");
    }
  }

}