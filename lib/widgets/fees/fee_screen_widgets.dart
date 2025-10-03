import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/model/fee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<bool?> showUpdateDialog(BuildContext context, FeeModel fee) async {
  final transactionController = TextEditingController(text: fee.transactionId);

  String selectedStatus = fee.status;
  String? selectedMethod = fee.paymentMethod;
  
  // List of valid payment methods
  const List<String> validPaymentMethods = [
    "Cash", "UPI", "Card", "Razorpay", "Paytm", "Google Pay", "PhonePe", "Bank Transfer", "Cheque"
  ];
  
  // If the current payment method is not in the valid list, set it to null
  if (selectedMethod != null && !validPaymentMethods.contains(selectedMethod)) {
    selectedMethod = null;
  }

  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Update Payment"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem(value: "Pending", child: Text("Pending")),
                      DropdownMenuItem(value: "Paid", child: Text("Paid")),
                    ],
                    onChanged: (val) => setState(() => selectedStatus = val!),
                    decoration: const InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Payment Method Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedMethod,
                    items: const [
                      DropdownMenuItem(value: null, child: Text("Select Method")),
                      DropdownMenuItem(value: "Cash", child: Text("Cash")),
                      DropdownMenuItem(value: "UPI", child: Text("UPI")),
                      DropdownMenuItem(value: "Card", child: Text("Card")),
                      DropdownMenuItem(value: "Razorpay", child: Text("Razorpay")),
                      DropdownMenuItem(value: "Paytm", child: Text("Paytm")),
                      DropdownMenuItem(value: "Google Pay", child: Text("Google Pay")),
                      DropdownMenuItem(value: "PhonePe", child: Text("PhonePe")),
                      DropdownMenuItem(
                          value: "Bank Transfer", child: Text("Bank Transfer")),
                      DropdownMenuItem(value: "Cheque", child: Text("Cheque")),
                    ],
                    onChanged: (val) => setState(() => selectedMethod = val),
                    decoration: const InputDecoration(
                      labelText: "Payment Method",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Transaction ID
                  TextField(
                    controller: transactionController,
                    decoration: const InputDecoration(
                      labelText: "Transaction ID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Validation: If status is "Paid", payment method should be selected
              if (selectedStatus == "Paid" && (selectedMethod == null || selectedMethod!.isEmpty)) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text("Please select a payment method for paid status")),
                );
                return;
              }

              final updatedFee = FeeModel(
                feeId: fee.feeId,
                studentId: fee.studentId,
                transactionId: transactionController.text,
                amount: fee.amount,
                status: selectedStatus,
                paymentMethod: selectedMethod ?? "",
                paidOn: selectedStatus == "Paid" ? DateTime.now() : null,
                month: fee.month,
              );

              try {
                await Provider.of<FeeController>(ctx, listen: false)
                    .updateFee(updatedFee);
                if (ctx.mounted) {
                  Navigator.of(ctx).pop(true);
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text("Error updating payment: $e")),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
