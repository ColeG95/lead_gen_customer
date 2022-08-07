import 'dart:io';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SubmittedScreen extends StatelessWidget {
  final DocumentReference leadRef;

  const SubmittedScreen({
    Key? key,
    required this.leadRef,
  }) : super(key: key);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            Text(
              'You\'re Done!',
              textAlign: TextAlign.center,
              style: titleTextStyle(context),
            ),
            SizedBox(height: 20),
            Text(
              'We\'ll reach out to you soon!',
              textAlign: TextAlign.center,
              style: titleTextStyle(context),
            ),
            SizedBox(height: 40),
            Container(
              width: 400,
              child: Text(
                'If you have not yet been prescribed HBOT, one of our physicians will reach out to you. Then, if appropriate, we can talk about scheduling your appointments. This process may take several days due to high demand.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              child: TextButton(
                onPressed: () {
                  html.window.open(
                      'https://finance.yahoo.com/news/effective-treatment-now-available-millions-140100158.html?guce_referrer=aHR0cHM6Ly93d3cuZ29vZ2xlLmZpLw&guce_referrer_sig=AQAAAA9QEa3n7nafi8nMCBKNxvx2WYP6IkVTl2BrtmplqIsQ8AdJsQubZ7bTZE0EQIc9nkdxb8yrVrs-cfEk3TSS4WXCVGl0lLflMwWcfhGihvd_3SOR3xzh9Q2rXpwnmqQBeei2L7Jr1il-KVhdnDxctendlmBE9FakZOqXWw4EXOx8',
                      "_self");
                },
                child: Text(
                  'Read about the latest science on HBOT for long covid.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
