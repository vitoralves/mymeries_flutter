import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  String getStaticMapImage(LatLng location) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${location.latitude},${location.longitude}&zoom=20&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C${location.latitude},${location.longitude}&key=AIzaSyDdTRSWDeXZrFNNqWSmECLvY-JIECFWD9A';
  }
}
