import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/memories_management_screen.dart';
import './screens/map_screen.dart';

import './providers/memorie_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: MemorieProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: HomeScreen(),
        routes: {
          MemoriesManagementScreen.route: (ctx) => MemoriesManagementScreen(),
          MapScreen.route: (_) => MapScreen(),
        },
      ),
    );
  }
}
