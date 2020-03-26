import 'package:flutter/material.dart';

import './memories_management_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Memories'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () =>
                Navigator.of(context).pushNamed(MemoriesManagementScreen.route),
          ),
        ],
      ),
    );
  }
}
