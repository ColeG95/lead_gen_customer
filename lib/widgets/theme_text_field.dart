import 'package:flutter/material.dart';

class ThemeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double width;
  final TextInputType textInputType;
  final void Function(String)? onChanged;

  const ThemeTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.width,
    required this.textInputType,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue,
            ),
          ),
          isDense: true,
        ),
        textAlign: TextAlign.center,
        keyboardType: textInputType,
      ),
    );
  }
}
