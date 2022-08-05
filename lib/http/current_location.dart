import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lead_gen_customer/models/coordinates.dart';

class CurrentLocation {
  Future<Coordinates> getCurrentLocation() async {
    final url = Uri.parse(
        'https://www.googleapis.com/geolocation/v1/geolocate?key=${dotenv.env['GOOGLE_API_KEY']}');
    final response = await http.post(url);
    final body = json.decode(response.body)['location'];
    return Coordinates(latitude: body['lat'], longitude: body['lng']);
  }
}
