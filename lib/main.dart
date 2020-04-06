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
                primarySwatch: Colors.purple,
                accentColor: Colors.amber,
                secondaryHeaderColor: Colors.redAccent,
                errorColor: Colors.black54,
                hintColor: Colors.black38,
            ),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                // Unused
                primarySwatch: Colors.green,
                // Accents and highlighted text
                accentColor: Colors.greenAccent,
                // Push colours
                secondaryHeaderColor: Colors.redAccent,
                // Text colours and circle colours
                errorColor: Colors.white,
                // Lighter text colours
                hintColor: Colors.white70,
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
