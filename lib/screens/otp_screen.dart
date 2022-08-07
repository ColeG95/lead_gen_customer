import 'package:flutter/material.dart';

class OTPScreen extends StatelessWidget {
  final String phoneNumber;
  final String verificationId;

  OTPScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: TextFormField(
        controller: controller,
      ),
    ));
  }
}
