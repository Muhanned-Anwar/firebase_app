import 'package:flutter/material.dart';

class TextFieldLoginScreen extends StatefulWidget {
  String hintText;
  Icon prefixIcon;
  TextInputType keyboardType;
  bool obscureText;
  late TextEditingController textEditingController;

  TextFieldLoginScreen({
    required this.hintText,
    required this.prefixIcon,
    required this.keyboardType,
    this.obscureText = false,
    required this.textEditingController,
  });

  @override
  _TextFieldLoginScreenState createState() => _TextFieldLoginScreenState(
      hintText: hintText,
      prefixIcon: prefixIcon,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textEditingController: textEditingController);
}

class _TextFieldLoginScreenState extends State<TextFieldLoginScreen> {
  String hintText;
  Icon prefixIcon;
  TextInputType keyboardType;
  bool obscureText;
  late TextEditingController textEditingController;

  _TextFieldLoginScreenState({
    required this.hintText,
    required this.prefixIcon,
    required this.keyboardType,
    required this.obscureText,
    required this.textEditingController,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
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
    );
  }
}
