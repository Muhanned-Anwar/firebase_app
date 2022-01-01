import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_auth_controller.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late StreamSubscription stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      stream = FbAuthController().checkUserStatus(({required bool loggedIn}) {
        String route = loggedIn ? '/notes_screen' : '/login_screen';
        Navigator.pushReplacementNamed(context, route);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black54, Colors.black26]),
        ),
        child: const Text('API APP'),
      ),
    );
  }
}
