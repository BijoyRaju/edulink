import 'package:edu_link/model/fee_model.dart';
import 'package:edu_link/model/student_model.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentUpdateScreen extends StatelessWidget {
  final FeeModel fee;
  final StudentModel student;
  const PaymentUpdateScreen({
    super.key,
    required this.fee,
    required this.student
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color(0xFF254F43),
        foregroundColor: Colors.white,
      ),
      body: Padding(padding: EdgeInsetsGeometry.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(text: "Student Info",fontSize: 18.sp),
          SizedBox(height: 10.h),
          ListTile(
              leading: const Icon(Icons.person),
              title: customText(text: student.name,fontSize: 16.sp),
              subtitle: customText(text: "Class ${student.stdClass}",fontSize: 14.sp)
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: customText(text: student.phone,fontSize: 16.sp),
            ),
            const Divider(),
          
          // Fee Details
          customText(text: "Fee Details",fontSize: 18.sp),
          SizedBox(height: 10.h),
          ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: customText(text: "Amount ${fee.amount}",fontSize: 16.sp),
              subtitle: customText(text: "Status: ${fee.status}",fontSize: 14.sp),
              trailing: Text(fee.paidOn.toString()),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customIconButton(label: "Reminder", icon: Icons.notifications, onPressed: (){

                  
                }),
                customIconButton(label: "Update Status", icon: Icons.attach_money, onPressed: (){},color: Colors.green)
              ],
            )
        ],
      ),),
    );
  }
}