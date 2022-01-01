import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_auth_controller.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_notifications.dart';
import 'package:vp7_firebase_app/utils/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers,FbNotifications {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNotificationPermissions();

    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'LOGIN',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text(
            'Welcome back...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Enter email & password',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailTextController,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: const Icon(Icons.email),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordTextController,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => await performLogin(),
            child: const Text('Login'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 0, maxHeight: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account '),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register_screen'),
                  child: const Text('Create Now!'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    // backgroundColor: Colors.red,
                    minimumSize: const Size(0, 20),
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 0, maxHeight: 20),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forget_password_screen');
              },
              child: const Text('Forget Password?'),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  // backgroundColor: Colors.yellowAccent,
                  minimumSize: const Size(0, 20)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performLogin() async {
    if (checkData()) {
      await login();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
        context: context, message: 'Enter required data', error: true, time: 1);
    return false;
  }

  Future<void> login() async {
    bool status = await FbAuthController().signIn(
        context: context,
        email: _emailTextController.text,
        password: _passwordTextController.text);
    if (status) {
      Navigator.pushReplacementNamed(context, '/notes_screen');
    }
  }
}
