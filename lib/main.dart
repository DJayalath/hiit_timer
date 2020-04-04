import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'settings.dart';
import 'timer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(HIITTimer());
  });
}

class HIITTimer extends StatelessWidget {
  // Root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIIT Timer',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        //primaryColor: Colors.greenAccent,
        accentColor: Colors.greenAccent,
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.green,
          )
        )
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.settings),
                ),
                Tab(
                  icon: Icon(Icons.timer),
                ),
              ],
            ),
            title: Text("HIIT Timer"),
          ),
          body: TabBarView(
            children: [
              Settings(),
              Timer(),
            ],
          )
        )
      ),
    );
  }
}
