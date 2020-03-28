import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  String getStaticMapImage(LatLng location) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${location.latitude},${location.longitude}&zoom=20&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C${location.latitude},${location.longitude}&key=AIzaSyDdTRSWDeXZrFNNqWSmECLvY-JIECFWD9A';
  }

  static Future<String> getAddress(double lat, double lng) async {
    var response = await http.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=AIzaSyDdTRSWDeXZrFNNqWSmECLvY-JIECFWD9A');
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
