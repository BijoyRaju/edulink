import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FeePaymentStudentScreen extends StatefulWidget {
  final String studentId;
  const FeePaymentStudentScreen({super.key,required this.studentId});

  @override
  State<FeePaymentStudentScreen> createState() => _FeePaymentStudentScreenState();
}

class _FeePaymentStudentScreenState extends State<FeePaymentStudentScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<FeeController>().fetchFees(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FeeController>();
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Fees Transactions"),
        backgroundColor: Color(0xFF254F43),
        foregroundColor: Colors.white,
      ),
      body: controller.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Expanded(
              child: controller.studentFees.isEmpty
                ? Center(child: Text("No Transaction yet"))
                : ListView.builder(
                  itemCount: controller.studentFees.length,
                  itemBuilder: (context,index){
                    final fee = controller.studentFees[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text("Amount: ₹${fee.amount}"),
                          subtitle: Text(
                          "Status: ${fee.status}\nDate: ${fee.paidOn.toLocal()}",
                          ),
                          trailing: Text(fee.transactionId),
                      ),
                    );
                  }
                )
            ),
             customButton(text: "Pay", onPressed: (){}),
             SizedBox(height: 30.h)
          ],
        )
    );
  }
}