import 'package:flutter/material.dart';
import 'package:lead_gen_customer/screens/contact_screen.dart';
import 'package:lead_gen_customer/screens/location_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Widget screenWidget;

  void changeScreen(Widget screen) {
    setState(() {
      screenWidget = screen;
    });
  }

  @override
  void initState() {
    super.initState();
    screenWidget = LocationScreen(changeScreen: changeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/mountains.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // backgroundColor: Colors.grey[200],
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white.withOpacity(.4),
            title: Text(
              'Find a HBOT provider near you',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: screenWidget,
        ),
      ],
    );
  }
}
