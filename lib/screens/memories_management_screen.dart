import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import './map_screen.dart';

import '../providers/memorie_provider.dart';
import '../helpers/location_helper.dart';

import '../models/memorie.dart';

class MemoriesManagementScreen extends StatefulWidget {
  static const route = 'memories-management';

  @override
  _MemoriesManagementScreenState createState() =>
      _MemoriesManagementScreenState();
}

class _MemoriesManagementScreenState extends State<MemoriesManagementScreen> {
  bool _loading = false;
  File _image;
  LatLng _selectedLocation;
  String _mapPreview;

  Future<void> _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future<void> _getLocation() async {
    Location currentLocation = Location();
    LocationData locationData = await currentLocation.getLocation();

    var selectedLocation = await Navigator.of(context)
        .pushNamed(MapScreen.route, arguments: locationData);

    setState(() {
      _selectedLocation = selectedLocation;
      _mapPreview = LocationHelper().getStaticMapImage(selectedLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    TextEditingController _descriptionController = TextEditingController();

    void _save() async {
      setState(() {
        _loading = true;
      });
      try {
        if (_image == null ||
            _selectedLocation == null ||
            _descriptionController.text == null) {
          return;
        }

        String formattedAddress = await LocationHelper.getAddress(
          _selectedLocation.latitude,
          _selectedLocation.longitude,
        );

        Memorie memorie = Memorie(
          null,
          _image.path,
          _selectedLocation.latitude,
          _selectedLocation.longitude,
          _descriptionController.text,
          formattedAddress,
        );

        await Provider.of<MemorieProvider>(context, listen: false)
            .insert(memorie);

        Navigator.of(context).pop();
      } catch (err) {
        print(err);
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          )
        ],
        title: Text(
          'Gerenciar Memória',
        ),
      ),
      body: SingleChildScrollView(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Container(
                    height: mediaQuery.size.height / 3,
                    color: Colors.black12,
                    child: _image != null
                        ? Image.file(
                            _image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: IconButton(
                              color: Theme.of(context).primaryColor,
                              iconSize: 70,
                              icon: Icon(Icons.add_a_photo),
                              onPressed: _getImage,
                            ),
                          ),
                  ),
                  Divider(),
                  Container(
                    height: mediaQuery.size.height / 3,
                    color: Colors.black12,
                    child: _mapPreview == null
                        ? Center(
                            child: IconButton(
                              color: Theme.of(context).primaryColor,
                              iconSize: 70,
                              icon: Icon(Icons.add_location),
                              onPressed: _getLocation,
                            ),
                          )
                        : Image.network(_mapPreview),
                  ),
                  Divider(),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    minLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Descreva aqui essa memória',
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
