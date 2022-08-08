import 'package:flutter/material.dart';
import 'package:lead_gen_customer/constants.dart';
import 'package:lead_gen_customer/responsive_widget.dart';
import 'package:lead_gen_customer/screens/contact_screen.dart';
import 'package:lead_gen_customer/widgets/basic_button.dart';
import 'package:lead_gen_customer/widgets/theme_text_field.dart';
import 'package:location/location.dart';
import 'package:lead_gen_customer/models/coordinates.dart';
import 'package:lead_gen_customer/http/current_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platform_device_id/platform_device_id.dart';

class LocationScreen extends StatefulWidget {
  final void Function(Widget) changeScreen;

  LocationScreen({
    Key? key,
    required this.changeScreen,
  }) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController _controller = TextEditingController();

  Coordinates? coordinates;

  String? zip;

  DocumentReference? leadRef;

  String? deviceId;

  @override
  void initState() {
    super.initState();

    getDeviceId();
  }

  void getDeviceId() async {
    deviceId = await PlatformDeviceId.getDeviceId;
  }

  void getCurrentLocation(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      context: context,
    );

    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Navigator.of(context).pop();
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Navigator.of(context).pop();
        return;
      }
    }

    try {
      coordinates = await CurrentLocation().getCurrentLocation();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location Capture Success!',
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
          'deviceId': deviceId,
          'dateAdded': DateTime.now(),
          'condition': 'long covid',
          'email': null,
          'phone': null,
        });
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (_) => ContactScreen(leadRef: leadRef!),
        //   ),
        // );
        widget.changeScreen(ContactScreen(leadRef: leadRef!));
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
    return Center(
      child: Container(
        width: ResponsiveWidget.isSmallScreen(context) ? 300 : 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(.4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
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
                fontSize: 16,
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
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
