import 'package:edu_link/view/bottom_navigation/bottom_navigation_screen.dart';
import 'package:edu_link/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    _checkLoginUser();
    super.initState();
  }


  Future<void> _checkLoginUser()async{
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(Duration(seconds: 2));

  if(mounted){
    if(isLoggedIn && role != null){
      // final client = StreamChat.of(context).client;
      // final userId = prefs.getString('userId') ?? "Guest";
      // await client.connectUser(User(id: userId,), client.devToken(userId).rawValue);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(role: role)));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
  }
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png')
            ],
          ),
        ),
      )
    );
  }
}
