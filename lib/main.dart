import 'dart:io';

import 'package:edu_link/controller/announcement_controller.dart';
import 'package:edu_link/controller/attendance_controller.dart';
import 'package:edu_link/controller/fee_controller.dart';
import 'package:edu_link/controller/student_controller.dart';
import 'package:edu_link/controller/teacher_controller.dart';
import 'package:edu_link/firebase_options.dart';
import 'package:edu_link/view/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:permission_handler/permission_handler.dart';



final mediaStorePlugin = MediaStore();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final client = StreamChatClient(
    'az437hxams6a',
    logLevel: Level.INFO,
  );

  runApp(MyApp(client: client));

  // Initialize OneSignal AFTER runApp to avoid blocking UI
  WidgetsBinding.instance.addPostFrameCallback((_) async {

    OneSignal.initialize("322f33fa-72f3-4bfc-a290-cbcc67cc80a7");
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Notifications.requestPermission(true);

    final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;


    if (firebaseUser != null) {
    await client.connectUser(
      User(
        id: firebaseUser.uid,
        extraData: {
          'name': firebaseUser.displayName ?? 'Guest',
          'image': 'https://getstream.io/random_png/?id=${firebaseUser.uid}',
        },
      ),
      client.devToken(firebaseUser.uid).rawValue, 
    );
  }

  // Intialize MediaStore
  if (Platform.isAndroid) {
    await MediaStore.ensureInitialized();
  }

  List<Permission> permissions = [
    Permission.storage,
  ];

  if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
    permissions.add(Permission.photos);
    permissions.add(Permission.audio);
    permissions.add(Permission.videos);
  }

  await permissions.request();

  MediaStore.appFolder = "MediaStorePlugin";

//   await client.connectUser(
//   User(
//     id: '1234',
//     extraData: {
//       'name': 'Bijoy',
//       'image': '',
//     },
//   ),
//   client.devToken('1234').rawValue, 
// );

  });
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
