import 'package:edu_link/controller/announcement_controller.dart';
import 'package:edu_link/controller/attendance_controller.dart';
import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/controller/teacher_controller.dart';
import 'package:edu_link/firebase_options.dart';
import 'package:edu_link/view/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final client = StreamChatClient(
    'vuhzsbmwtcrb',
    logLevel: Level.INFO,
  );

  // final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;


  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key ,required this.client}) : super(key: key);

  final StreamChatClient client;
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TeacherController()..fetchTeachers()),
          ChangeNotifierProvider(create: (_) => StudentController()..fetchStudents()),
          ChangeNotifierProvider(create: (_) => AnnouncementController()),
          ChangeNotifierProvider(create: (_) => AttendanceController()),
          ChangeNotifierProvider(create: (_) => FeeController())
        ],
        child: MaterialApp(
          builder: (context,child){
            return StreamChat(client: client, child: child);
          },
            debugShowCheckedModeBanner: false,
            home: SplashScreen()
          ),
        ),
    );
  }
}
