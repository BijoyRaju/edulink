import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/view/fee_payment/admin/payment_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeePaymentAdminScreen extends StatefulWidget {
  const FeePaymentAdminScreen({super.key});

  @override
  State<FeePaymentAdminScreen> createState() => _FeePaymentAdminScreenState();
}

class _FeePaymentAdminScreenState extends State<FeePaymentAdminScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if(mounted){ 
        final feeController = Provider.of<FeeController>(context, listen: false);
        
        feeController.fetchAllFees(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final feeController = Provider.of<FeeController>(context);
      final studentController = Provider.of<StudentController>(context);

  String getStudentName(String studentId) {
    if(studentController.students.isEmpty){
      return "No teacher found";
    }
  final student = studentController.students.firstWhere(
    (t) => t.studentId  == studentId,
  );
  return student.name ?? "Unknow Student";
}

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fee Management"),
          backgroundColor: Color(0xFF254F43),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.yellow,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Paid"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Tab 1
            feeController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : feeController.pendingFees.isEmpty
                    ? const Center(child: Text("No Pending Transactions"))
                    : ListView.separated(
                        separatorBuilder: (_, __) => const Divider(),
                        itemCount: feeController.pendingFees.length,
                        itemBuilder: (context, index) {
                          final fee = feeController.pendingFees[index];
                          return ListTile(
                            leading: const Icon(Icons.warning, color: Colors.red),
                            title: Text("Name: ${getStudentName(fee.studentId)}"),
                            subtitle: Text("Amount: ₹${fee.amount}"),
                            trailing: Text(
                              fee.status,
                              style: const TextStyle(color: Colors.red),
                            ),
                            onTap: (){
                              final student = studentController.students.firstWhere(
                                (s) => s.studentId == fee.studentId
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentUpdateScreen(fee: fee, student: student)));
                            },
                          );
                        },
                      ),

            // Tab 2 Paid
            feeController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : feeController.studentFees
                        .where((f) => f.status == "Paid")
                        .isEmpty
                    ? const Center(child: Text("No Paid Fees yet"))
                    : ListView(
                        children: feeController.studentFees
                            .where((f) => f.status == "Paid")
                            .map((fee) => ListTile(
                                  leading: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  title: Text("Student ID: ${fee.studentId}"),
                                  subtitle: Text("Amount: ₹${fee.amount}"),
                                  trailing: Text(
                                    fee.status,
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ))
                            .toList(),
                      ),
          ],
        ),
      ),
    );
  }
}
