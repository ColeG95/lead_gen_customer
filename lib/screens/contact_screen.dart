import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_gen_customer/constants.dart';
import 'package:lead_gen_customer/responsive_widget.dart';
import 'package:lead_gen_customer/screens/submitted_screen.dart';
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
  final _formKey = GlobalKey<FormState>();

  bool get isValid {
    return (_phoneController.text.length >= 10 &&
        _emailController.text.contains('@') &&
        _emailController.text.contains('.') &&
        isAgreed);
  }

  void trySubmit() async {
    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      context: context,
    );
    bool isFormValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    try {
      if (isFormValid && isValid) {
        _formKey.currentState!.save();
        await widget.leadRef.update({
          'email': _emailController.text,
          'phone': _phoneController.text,
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => SubmittedScreen(leadRef: widget.leadRef),
            ),
            (route) => false);
      } else {
        throw ('Unable to validate form');
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor.withOpacity(.9),
        ),
      );
    }
  }

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
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity),
              Text(
                'How can our medical professionals contact you?',
                textAlign: TextAlign.center,
                style: titleTextStyle(context),
              ),
              SizedBox(height: 40),
              ThemeTextField(
                controller: _emailController,
                hintText: 'Email...',
                width: 220,
                textInputType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty ||
                      !value.contains('@') ||
                      !value.contains('.')) {
                    return 'Enter a valid email address';
                  } else if (value.contains(' ')) {
                    return 'Email cannot contain spaces';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 20),
              ThemeTextField(
                controller: _phoneController,
                hintText: 'Phone...',
                width: 220,
                textInputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.length < 10 || value.isEmpty) {
                    return 'Enter a valid phone number';
                  } else {
                    return null;
                  }
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
                onPressed: trySubmit,
                color: isValid ? Colors.lightBlue : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
