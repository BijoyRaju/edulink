import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/model/fee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<bool?> showUpdateDialog(BuildContext context, FeeModel fee) async {
  final transactionController = TextEditingController(text: fee.transactionId);

  String selectedStatus = fee.status;
  String? selectedMethod = fee.paymentMethod;

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
                      DropdownMenuItem(value: "Cash", child: Text("Cash")),
                      DropdownMenuItem(value: "UPI", child: Text("UPI")),
                      DropdownMenuItem(value: "Card", child: Text("Card")),
                      DropdownMenuItem(
                          value: "Bank Transfer", child: Text("Bank Transfer")),
                    ],
                    onChanged: (val) => setState(() => selectedMethod = val!),
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

              await Provider.of<FeeController>(ctx, listen: false)
                  .updateFee(updatedFee);
               Navigator.of(context).pop(true);   
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
