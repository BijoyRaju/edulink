import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/fee_model.dart';

class FeeService {
  final _firestore = FirebaseFirestore.instance;
  final _collection = "fees";

  Future <void> saveFee(FeeModel fee)async{
    try{
     await _firestore.collection(_collection).doc(fee.feeId).set({
      ...fee.toMap(),
      "paid_on": Timestamp.fromDate(fee.paidOn),
      "month": Timestamp.fromDate(fee.month),
    });
    }catch(e){
      throw Exception("Error in saving fees $e");
    }
  }

  // Get All Fees
   Future<List<FeeModel>> getAllFees() async {
    try{
      final snapshot = await _firestore.collection("fees").get();
      return snapshot.docs.map((doc) => FeeModel.fromMap(doc.data())).toList();
    }catch(e){
      throw Exception("Error in fetching all students fees: $e");
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

  

}