import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lead_gen_customer/constants.dart';
import 'package:lead_gen_customer/widgets/basic_button.dart';
import 'package:lead_gen_customer/widgets/theme_text_field.dart';
import 'package:location/location.dart';
import 'package:lead_gen_customer/models/coordinates.dart';
import 'package:lead_gen_customer/http/current_location.dart';

class ContactScreen extends StatefulWidget {
  final DocumentReference leadRef;

  ContactScreen({
    Key? key,
    required this.leadRef,
  }) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  bool isAgreed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Find a HBOT provider near you',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Text(
            'How can our medical professionals contact you?',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          ThemeTextField(
            controller: _emailController,
            hintText: 'Email...',
            width: 170,
            textInputType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          ThemeTextField(
            controller: _phoneController,
            hintText: 'Phone...',
            width: 170,
            textInputType: TextInputType.number,
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: 40),
          Container(
            width: 300,
            child: CheckboxListTile(
              value: isAgreed,
              dense: true,
              title: Text(
                'You ackowledge that you\'ve read and agree to our terms of service and privacy policy.',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              onChanged: (value) {
                setState(() {
                  isAgreed = !isAgreed;
                });
              },
            ),
          ),
          SizedBox(height: 5),
          BasicButton(
            child: Text(
              'Done',
              style: basicButtonStyle,
            ),
            onPressed: () {},
            color: (_phoneController.text.length >= 10 &&
                    _emailController.text.contains('@') &&
                    _emailController.text.contains('.') &&
                    isAgreed)
                ? Colors.lightBlue
                : Colors.grey,
          ),
        ],
      ),
    );
  }
}
