import 'package:firebase_auth/firebase_auth.dart';
import 'show_otp_dialog.dart';
import 'package:lead_gen_customer/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // PHONE SIGN IN
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
    VoidCallback success,
    VoidCallback failure,
  ) async {
    TextEditingController codeController = TextEditingController();
    // if (kIsWeb) {
    // Works only on web
    ConfirmationResult result = await _auth.signInWithPhoneNumber(phoneNumber);

    // Diplay Dialog Box To accept OTP
    showOTPDialog(
      codeController: codeController,
      context: context,
      onPressed: () async {
        try {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          await _auth.signInWithCredential(credential);
          Navigator.of(context).pop();
          success();
        } catch (e) {
          failure();
        }
      },
    );
    // }
    // else {
    //   // FOR ANDROID, IOS
    //   await _auth.verifyPhoneNumber(
    //     phoneNumber: phoneNumber,
    //     //  Automatic handling of the SMS code
    //     verificationCompleted: (PhoneAuthCredential credential) async {
    //       // !!! works only on android !!!
    //       await _auth.signInWithCredential(credential);
    //     },
    //     // Displays a message when verification fails
    //     verificationFailed: (e) {
    //       showSnackBar(context, e.message!);
    //     },
    //     // Displays a dialog box when OTP is sent
    //     codeSent: ((String verificationId, int? resendToken) async {
    //       showOTPDialog(
    //         codeController: codeController,
    //         context: context,
    //         onPressed: () async {
    //           PhoneAuthCredential credential = PhoneAuthProvider.credential(
    //             verificationId: verificationId,
    //             smsCode: codeController.text.trim(),
    //           );
    //
    //           // !!! Works only on Android, iOS !!!
    //           await _auth.signInWithCredential(credential);
    //           Navigator.of(context).pop(); // Remove the dialog box
    //         },
    //       );
    //     }),
    //     codeAutoRetrievalTimeout: (String verificationId) {
    //       // Auto-resolution timed out...
    //     },
    //   );
    // }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }
}
