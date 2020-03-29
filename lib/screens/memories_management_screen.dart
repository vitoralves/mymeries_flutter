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
  Memorie _memorie = Memorie();
  TextEditingController _descriptionController = TextEditingController();
  bool _loading = false;
  String _mapPreview;
  bool _isInit = true;

  Future<void> _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    Memorie memorie = _memorie;
    memorie.image = image.path;
    setState(() {
      _memorie = memorie;
    });
  }

  Future<void> _getLocation() async {
    Location currentLocation = Location();
    LocationData locationData = await currentLocation.getLocation();

    var selectedLocation = await Navigator.of(context)
        .pushNamed(MapScreen.route, arguments: locationData) as LatLng;

    setState(() {
      _memorie.latitude = selectedLocation.latitude;
      _memorie.longitude = selectedLocation.longitude;
      _mapPreview = LocationHelper().getStaticMapImage(selectedLocation);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final int id = ModalRoute.of(context).settings.arguments;
      if (id != null) {
        _memorie = Provider.of<MemorieProvider>(context).getById(id);
        _mapPreview = LocationHelper()
            .getStaticMapImage(LatLng(_memorie.latitude, _memorie.longitude));
        _descriptionController.text = _memorie.description;
      }
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    void _save() async {
      setState(() {
        _loading = true;
      });
      try {
        if (_memorie.image == null ||
            _memorie.latitude == null ||
            _descriptionController.text == null) {
          return;
        }

        _memorie.formattedAddress = await LocationHelper.getAddress(
          _memorie.latitude,
          _memorie.longitude,
        );

        _memorie.description = _descriptionController.text;

        await Provider.of<MemorieProvider>(context, listen: false)
            .insert(_memorie);

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
                    child: _memorie.image != null
                        ? GestureDetector(
                            onTap: _getImage,
                            child: Hero(
                              tag: _memorie.id == null ? 'tag' : _memorie.id,
                              child: Image.file(
                                File(_memorie.image),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                        : GestureDetector(
                            onTap: _getLocation,
                            child: Image.network(_mapPreview),
                          ),
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
