import 'package:edu_link/controller/auth_controller.dart';
import 'package:edu_link/view/attendance/attendance.dart';
import 'package:edu_link/view/fee_payment/admin/fee_payment_admin_screen.dart';
import 'package:edu_link/view/fee_payment/fee_payment_student_screen.dart';
import 'package:edu_link/view/fee_payment/fee_payment_teacher_screen.dart';
import 'package:flutter/material.dart';

Widget customDrawer(BuildContext context,String role,String studentId) {
  final AuthController controller = AuthController();
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFF254F43),
          ),
          child: Text(
            'Edu Link',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        if (role == "teacher") ...[
        ListTile(
          leading: const Icon(Icons.edit_calendar_sharp),
          title: const Text('Attendance'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Attendance()));
          },
        ),
        Divider(),
        ],
         if (role == "student") ...[
        ListTile(
          leading: const Icon(Icons.payment_sharp),
          title: const Text('Fees Payment'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FeePaymentStudentScreen(studentId: studentId,)));
          },
        ),
        Divider(),
        ],
        if (role == "teacher") ...[
        ListTile(
          leading: const Icon(Icons.payment_sharp),
          title: const Text('Fees Payment'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FeePaymentTeacherScreen()));
          },
        ),
        Divider(),
        ],
        if (role == "admin") ...[
        ListTile(
          leading: const Icon(Icons.payment_sharp),
          title: const Text('Fees Payment'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FeePaymentAdminScreen()));
          },
        ),
        Divider(),
        ],
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to Profile Screen
          },
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            controller.logOutUser(context);
          },
        ),
        Divider(),
      ],
    ),
  );
}
