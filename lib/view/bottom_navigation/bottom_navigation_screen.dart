import 'package:edu_link/view/announcement/announcement_screen.dart';
import 'package:edu_link/view/chat/chat_screen.dart';
import 'package:edu_link/view/home/home_screen.dart';
import 'package:edu_link/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigationScreen extends StatefulWidget {
  final String role;
  const BottomNavigationScreen({super.key,required this.role});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int selectedIndex = 0;

  late List<Widget> pages =  [
    HomeScreen(role: widget.role),
    AnnouncementScreen(),
    ChatScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: 
          const [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active),label: "Announcement"),
            BottomNavigationBarItem(icon: Icon(Icons.chat),label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile")
        ],
      ),

    );
  }
}