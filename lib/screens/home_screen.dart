import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/memorie_provider.dart';
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
      backgroundColor: Colors.grey,
      body: FutureBuilder(
          future: Provider.of<MemorieProvider>(context, listen: false).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Consumer<MemorieProvider>(
              builder: (ctx, provider, _) {
                return ListView.separated(
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      leading: Image.file(
                        File(provider.getMemories()[index].image),
                      ),
                      title:
                          Text(provider.getMemories()[index].formattedAddress),
                      subtitle: Text(provider.getMemories()[index].description),
                    );
                  },
                  separatorBuilder: (ctx, _) => Divider(),
                  itemCount: provider.getMemories().length,
                );
              },
            );
          }),
    );
  }
}
