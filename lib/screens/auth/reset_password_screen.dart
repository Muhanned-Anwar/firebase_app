import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vp7_firebase_app/utils/helpers.dart';
import 'package:vp7_firebase_app/widgets/code_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with Helpers {
  String? _code;
  late TextEditingController _passwordTextController;
  late TextEditingController _passwordConfirmationTextController;

  late TextEditingController _firstCodeTextController;
  late TextEditingController _secondCodeTextController;
  late TextEditingController _thirdCodeTextController;
  late TextEditingController _fourthCodeTextController;

  late FocusNode _firstFocusNode;
  late FocusNode _secondFocusNode;
  late FocusNode _thirdFocusNode;
  late FocusNode _fourthFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordTextController = TextEditingController();
    _passwordConfirmationTextController = TextEditingController();

    _firstCodeTextController = TextEditingController();
    _secondCodeTextController = TextEditingController();
    _thirdCodeTextController = TextEditingController();
    _fourthCodeTextController = TextEditingController();

    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _thirdFocusNode = FocusNode();
    _fourthFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordTextController.dispose();
    _passwordConfirmationTextController.dispose();

    _firstCodeTextController.dispose();
    _secondCodeTextController.dispose();
    _thirdCodeTextController.dispose();
    _fourthCodeTextController.dispose();

    _firstFocusNode.dispose();
    _secondFocusNode.dispose();
    _thirdFocusNode.dispose();
    _fourthFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'RESET PASSWORD',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            'Welcome back...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Enter code & new password',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CodeTextField(
                  codeTextController: _firstCodeTextController,
                  focusNode: _firstFocusNode,
                  onChanged: (value) {
                    if (value.isNotEmpty) _secondFocusNode.requestFocus();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CodeTextField(
                  codeTextController: _secondCodeTextController,
                  focusNode: _secondFocusNode,
                  onChanged: (value) {
                    if (value.isNotEmpty)
                      _thirdFocusNode.requestFocus();
                    else
                      _firstFocusNode.requestFocus();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CodeTextField(
                  codeTextController: _thirdCodeTextController,
                  focusNode: _thirdFocusNode,
                  onChanged: (value) {
                    if (value.isNotEmpty)
                      _fourthFocusNode.requestFocus();
                    else
                      _secondFocusNode.requestFocus();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CodeTextField(
                  codeTextController: _fourthCodeTextController,
                  focusNode: _fourthFocusNode,
                  onChanged: (value) {
                    if (value.isEmpty) _thirdFocusNode.requestFocus();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordTextController,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordConfirmationTextController,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Password Confirmation',
              prefixIcon: Icon(Icons.lock),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => await performResetPassword(),
            child: Text('Reset Password'),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> performResetPassword() async {
    if (checkData()) {
      await resetPassword();
    }
  }

  bool checkData() {
    if (checkCode()) {
      if (checkPassword()) {
        return true;
      }
    }
    return false;
  }

  bool checkPassword() {
    if (_passwordTextController.text.isNotEmpty &&
        _passwordConfirmationTextController.text.isNotEmpty) {
      if (_passwordTextController.text ==
          _passwordConfirmationTextController.text) {
        return true;
      } else {
        showSnackBar(
            context: context,
            message: 'Password Confirmation error!',
            error: true);
        return false;
      }
    }
    showSnackBar(
        context: context, message: 'Enter required data!', error: true);
    return false;
  }

  bool checkCode() {
    if (_firstCodeTextController.text.isNotEmpty &&
        _secondCodeTextController.text.isNotEmpty &&
        _thirdCodeTextController.text.isNotEmpty &&
        _fourthCodeTextController.text.isNotEmpty) {
      _code = _firstCodeTextController.text +
          _secondCodeTextController.text +
          _thirdCodeTextController.text +
          _fourthCodeTextController.text;
      return true;
    }
    showSnackBar(context: context, message: 'Enter sent code!', error: true);
    return false;
  }

  Future<void> resetPassword() async {
    // bool status = await StudentApiController().resetPassword(
    //   context: context,
    //   email: widget.email,
    //   code: _code!,
    //   password: _passwordTextController.text,
    //   passwordConfirmation: _passwordConfirmationTextController.text,
    // );
    // if (status) Navigator.pop(context);
  }
}
