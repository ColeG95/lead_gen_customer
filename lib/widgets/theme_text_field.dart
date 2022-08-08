import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double width;
  final TextInputType textInputType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const ThemeTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.width,
    required this.textInputType,
    this.validator,
    this.onChanged,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextFormField(
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[700]),
          enabledBorder: OutlineInputBorder(),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue,
            ),
          ),
          isDense: true,
        ),
        textAlign: TextAlign.center,
        keyboardType: textInputType,
        validator: validator,
      ),
    );
  }
}
