import 'package:flutter/material.dart';
import 'package:lead_gen_customer/constants.dart';
import 'package:lead_gen_customer/screens/contact_screen.dart';
import 'package:lead_gen_customer/widgets/basic_button.dart';
import 'package:lead_gen_customer/widgets/theme_text_field.dart';
import 'package:location/location.dart';
import 'package:lead_gen_customer/models/coordinates.dart';
import 'package:lead_gen_customer/http/current_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController _controller = TextEditingController();

  Coordinates? coordinates;

  String? zip;

  DocumentReference? leadRef;

  void getCurrentLocation(BuildContext context) async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      context: context,
    );

    try {
      coordinates = await CurrentLocation().getCurrentLocation();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Success!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.lightBlue,
        ),
      );
      trySubmit(context);
    } catch (e) {
      Navigator.pop(context);
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

  void trySubmit(BuildContext context) async {
    if (_controller.text.length >= 4 || coordinates != null) {
      try {
        leadRef = await FirebaseFirestore.instance.collection('leads').add({
          'coordinates': {
            'latitude': coordinates == null ? null : coordinates!.latitude,
            'longitude': coordinates == null ? null : coordinates!.longitude,
          },
          'zipCode': zip,
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ContactScreen(leadRef: leadRef!),
          ),
        );
      } catch (e) {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fill in your location.',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          BasicButton(
            onPressed: () {
              getCurrentLocation(context);
            },
            child: Text(
              'Get Current Location',
              style: basicButtonStyle,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'OR',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          ThemeTextField(
            controller: _controller,
            hintText: 'Zip Code...',
            width: 170,
            textInputType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                zip = value;
              });
            },
          ),
          SizedBox(height: 40),
          BasicButton(
            child: Text(
              'Next',
              style: basicButtonStyle,
            ),
            onPressed: () {
              trySubmit(context);
            },
            color: (_controller.text.length >= 4 || coordinates != null)
                ? Colors.lightBlue
                : Colors.grey,
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
