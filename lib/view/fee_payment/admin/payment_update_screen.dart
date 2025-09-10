import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/model/fee_model.dart';
import 'package:edu_link/model/student_model.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:edu_link/widgets/common/list_shimmer.dart';
import 'package:edu_link/widgets/fees/fee_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentUpdateScreen extends StatefulWidget {
  final FeeModel fee;
  final StudentModel student;

  const PaymentUpdateScreen({
    super.key,
    required this.fee,
    required this.student,
  });

  @override
  State<PaymentUpdateScreen> createState() => _PaymentUpdateScreenState();
}

class _PaymentUpdateScreenState extends State<PaymentUpdateScreen> {

  late FeeController feeController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      feeController.loadFee(widget.fee.feeId);
    });
    feeController = context.read<FeeController>(); 
  }

  @override
  void dispose() {
    feeController.selectedFee = null; 
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<FeeController>(
      builder: (context, feeController, _) {
        final fee = feeController.selectedFee;

        if (feeController.isLoading || fee == null) {
          return const Scaffold(
            body: Center(child: ListShimmer()),
          );
        }

        if (feeController.errorMessage != null && fee == null ) {
          return Scaffold(
            body: Center(child: Text("Error: ${feeController.errorMessage}")),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Payment"),
            backgroundColor: const Color(0xFF254F43),
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(text: "Student Info", fontSize: 18.sp),
                SizedBox(height: 10.h),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: customText(text: widget.student.name, fontSize: 16.sp),
                  subtitle: customText(
                      text: "Class ${widget.student.stdClass}", fontSize: 14.sp),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: customText(text: widget.student.phone, fontSize: 16.sp),
                ),
                const Divider(),
                customText(text: "Fee Details", fontSize: 18.sp),
                SizedBox(height: 10.h),
                ListTile(
                  leading: const Icon(Icons.currency_rupee),
                  title: customText(text: "Amount ${fee.amount}", fontSize: 16.sp),
                  subtitle: customText(text: "Status: ${fee.status}", fontSize: 14.sp),
                  trailing: customText(
                      text: fee.month != null 
                        ? "Due: ${DateFormat('MMM, yyyy').format(fee.month!)}"
                        : "Due : N/A",
                      fontSize: 14.sp),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (fee.status == "Pending")
                      customIconButton(
                        label: "Reminder",
                        icon: Icons.notifications,
                        onPressed: () {},
                      ),
                    customIconButton(
                      label: "Update Status",
                      icon: Icons.attach_money,
                      onPressed: () async {
                        final result = await showUpdateDialog(context, fee);
                        if (result == true) {
                          await feeController.loadFee(fee.feeId);
                          if (context.mounted) Navigator.pop(context, true);
                        }
                      },
                      color: Colors.green,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
