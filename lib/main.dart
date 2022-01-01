import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_notifications.dart';
import 'package:vp7_firebase_app/screens/app/create_note_screen.dart';
import 'package:vp7_firebase_app/screens/app/images/images_screen.dart';
import 'package:vp7_firebase_app/screens/app/images/upload_image_screen.dart';
import 'package:vp7_firebase_app/screens/app/notes_screen.dart';
import 'package:vp7_firebase_app/screens/auth/forget_password_screen.dart';
import 'package:vp7_firebase_app/screens/auth/login_screen.dart';
import 'package:vp7_firebase_app/screens/auth/register_screen.dart';
import 'package:vp7_firebase_app/screens/launch_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FbNotifications.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/launch_screen',
      routes: {
        '/launch_screen': (context) => const LaunchScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        '/forget_password_screen': (context) => const ForgetPasswordScreen(),
        '/notes_screen': (context) => const NotesScreen(),
        '/create_note_screen': (context) => const CreateNoteScreen(),
        '/images_screen': (context) => const ImagesScreen(),
        '/upload_image_screen': (context) => const UploadImageScreen(),
      },
    );
  }
}
