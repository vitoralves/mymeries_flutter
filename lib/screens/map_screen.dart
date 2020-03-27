import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  static const route = 'map';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _selectedLocation;

  void _setLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  LatLng _getMarker(LocationData initial) {
    if (_selectedLocation == null) {
      return LatLng(initial.latitude, initial.longitude);
    }

    return _selectedLocation;
  }

  void _save() {
    Navigator.of(context).pop(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    final LocationData locationData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione uma localização'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _selectedLocation == null ? null : _save,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            locationData.latitude,
            locationData.longitude,
          ),
          zoom: 16,
        ),
        mapType: MapType.normal,
        onTap: _setLocation,
        markers: {
          Marker(
            markerId: MarkerId('myMarker'),
            position: _getMarker(locationData),
          ),
        },
      ),
    );
  }
}
