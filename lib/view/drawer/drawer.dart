// drawer.dart
import 'package:edu_link/controller/auth_controller.dart';
import 'package:edu_link/view/attendance/attendance.dart';
import 'package:edu_link/view/attendance/attendance_screen.dart';
import 'package:flutter/material.dart';

Widget customDrawer(BuildContext context,String role) {
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
