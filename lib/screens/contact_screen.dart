import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart'
    as ap;

import '../auth/firebase_auth_methods.dart';

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

  final _auth = FirebaseAuth.instance;

  bool isAgreed = true;
  final _formKey = GlobalKey<FormState>();

  bool get isValid {
    return (_phoneController.text.length >= 10 &&
        _emailController.text.contains('@') &&
        _emailController.text.contains('.') &&
        isAgreed);
  }

  Future<void> phoneSignIn() async {
    String phoneNumber = _phoneController.text;
    await FirebaseAuthMethods(_auth).phoneSignIn(
      context,
      phoneNumber.contains('+')
          ? phoneNumber
          : phoneNumber = '+1 ' + phoneNumber,
      OTPSuccess,
      OTPFailure,
    );
  }

  void OTPSuccess() async {
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
  }

  void OTPFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Incorrect OTP',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor.withOpacity(.9),
      ),
    );
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
        var recaptchaVerifier = RecaptchaVerifier(
          container: null,
          size: RecaptchaVerifierSize.compact,
          theme: RecaptchaVerifierTheme.dark,
          onSuccess: () async {
            print('reCAPTCHA Completed!');
          },
          onError: (FirebaseAuthException error) async {
            print("error");
            print(error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error.message.toString(),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Theme.of(context).errorColor.withOpacity(.9),
              ),
            );
          },
          onExpired: () async {
            print('reCAPTCHA Expired!');
          },
          auth: ap.FirebaseAuthPlatform.instanceFor(
            app: Firebase.app(),
            pluginConstants: {},
          ),
        );
        await phoneSignIn();
      } else {
        Navigator.of(context).pop();
        throw ('Form is invalid');
      }
    } catch (e) {
      // Navigator.of(context).pop();
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

  // void sendOTP(String phoneNumber, PhoneCodeSent codeSent,
  //     PhoneVerificationFailed verificationFailed) {
  //   if (!phoneNumber.contains('+')) phoneNumber = '+1 ' + phoneNumber;
  //   _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     timeout: Duration(seconds: 120),
  //     verificationCompleted: (PhoneAuthCredential cred) {
  //       print('VERIFICATION COMPLETED');
  //     },
  //     verificationFailed: verificationFailed,
  //     codeSent: codeSent,
  //     codeAutoRetrievalTimeout: (String str) {
  //       print('CODE AUTO RETRIEVAL TIMEOUT');
  //     },
  //   );
  // }
  //
  // void codeSent(String verificationId, int forceResendingToken) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => OTPScreen(
  //                 phoneNumber: _phoneController.text,
  //                 verificationId: verificationId,
  //               )));
  // }
  //
  // void verificationFailed(FirebaseAuthException exception) {
  //   print('VERIFICATION FAILED');
  // }

  @override
  void initState() {
    super.initState();

    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: ResponsiveWidget.isSmallScreen(context) ? 300 : 550,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(.4),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
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
                      color: Colors.grey[700],
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
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
