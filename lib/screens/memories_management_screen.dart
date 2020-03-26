import 'package:flutter/material.dart';

class MemoriesManagementScreen extends StatelessWidget {
  static const route = 'memories-management';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    TextEditingController _descriptionController;

    void _save() {}

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _save,
          )
        ],
        title: Text(
          'Gerenciar Memória',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: mediaQuery.size.height / 3,
              color: Colors.black12,
              child: Center(
                child: IconButton(
                  color: Theme.of(context).primaryColor,
                  iconSize: 70,
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () => print('alo'),
                ),
              ),
            ),
            Divider(),
            Container(
              height: mediaQuery.size.height / 3,
              color: Colors.black12,
              child: Center(
                child: IconButton(
                  color: Theme.of(context).primaryColor,
                  iconSize: 70,
                  icon: Icon(Icons.add_location),
                  onPressed: () => print('alo'),
                ),
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
