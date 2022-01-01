import 'package:flutter/material.dart';

class CodeTextField extends StatelessWidget {
  final TextEditingController codeTextController;
  final FocusNode focusNode;
  final void Function(String value) onChanged;

  CodeTextField({
   required this.codeTextController,
   required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: codeTextController,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onChanged: onChanged,
      maxLength: 1,
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
