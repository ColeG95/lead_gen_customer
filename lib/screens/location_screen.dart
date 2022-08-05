import 'package:flutter/material.dart';
import 'package:lead_gen_customer/widgets/basic_button.dart';
import 'package:location/location.dart';
import 'package:lead_gen_customer/models/coordinates.dart';
import 'package:lead_gen_customer/http/current_location.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({Key? key}) : super(key: key);

  TextEditingController _controller = TextEditingController();

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

    Coordinates currentLocationCoords =
        await CurrentLocation().getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Find an HBOT provider near you',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Text(
            'For Most Accurate Results',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          BasicButton(
            onPressed: () {
              getCurrentLocation(context);
            },
            child: Text(
              'Get Current Location',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Or',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 170,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Zip Code...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlue,
                  ),
                ),
                isDense: true,
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
