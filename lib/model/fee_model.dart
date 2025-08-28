import 'package:cloud_firestore/cloud_firestore.dart';

class FeeModel {
  String feeId;
  String studentId;
  String transactionId;
  double amount;
  String status;
  DateTime paidOn;
  DateTime month;

  FeeModel({
    required this.feeId,
    required this.studentId,
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.paidOn,
    required this.month
  });

  Map<String, dynamic> toMap() {
    return {
      "fee_id" : feeId,
      "student_id" : studentId,
      "transaction_id" : transactionId,
      "amount" : amount,
      "status" : status,
      "paid_on" : Timestamp.fromDate(paidOn),
      "month" : Timestamp.fromDate(month)
    };
  }

  factory FeeModel.fromMap(Map<String, dynamic> map) {
    return FeeModel(
      feeId: map['fee_id'] ?? "",
      studentId: map['student_id'] ?? "",
      transactionId: map['transaction_id'] ?? "",
      amount: (map['amount'] as num).toDouble(),
      status: map['status'] ?? "Pending",
      paidOn: (map['paid_on'] as Timestamp).toDate(),
      month: (map['month'] as Timestamp).toDate()
    );
  }
}