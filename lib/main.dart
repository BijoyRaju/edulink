import 'package:edu_link/controller/announcement_controller.dart';
import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/controller/teacher_controller.dart';
import 'package:edu_link/firebase_options.dart';
import 'package:edu_link/view/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
// import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final client = stream.StreamChatClient(
  //   'vuhzsbmwtcrb',
  //   logLevel: stream.Level.INFO,
  // );

  // final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TeacherController()..fetchTeachers()),
          ChangeNotifierProvider(create: (_) => StudentController()..fetchStudents()),
          ChangeNotifierProvider(create: (_) => AnnouncementController()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen()
          ),
        ),
    );
  }
}
