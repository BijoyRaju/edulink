import 'package:cloud_firestore/cloud_firestore.dart';

class FeeModel {
  String feeId;
  String studentId;
  String transactionId;
  double amount;
  String status;
  String? paymentMethod;
  DateTime? paidOn;
  DateTime? month;

  FeeModel({
    required this.feeId,
    required this.studentId,
    required this.transactionId,
    required this.amount,
    required this.status,
    this.paymentMethod,
    this.paidOn,
    this.month
  });

  Map<String, dynamic> toMap() {
    return {
      "fee_id" : feeId,
      "student_id" : studentId,
      "transaction_id" : transactionId,
      "amount" : amount,
      "status" : status,
      "payment_method" : paymentMethod,
      "paid_on" : paidOn != null ? Timestamp.fromDate(paidOn!) : null,
      "month" : month != null ? Timestamp.fromDate(month!) : null
    };
  }

  factory FeeModel.fromMap(Map<String, dynamic> map) {
    return FeeModel(
      feeId: map['fee_id'] ?? "",
      studentId: map['student_id'] ?? "",
      transactionId: map['transaction_id'] ?? "",
      amount: (map['amount'] as num).toDouble(),
      status: map['status'] ?? "Pending",
      paymentMethod: map['payment_method'],
      paidOn: map['paid_on'] != null 
        ? (map['paid_on'] as Timestamp).toDate()
        : null,
      month: map['month'] != null 
        ? (map['month'] as Timestamp).toDate()
        : null,
    );
  }


}