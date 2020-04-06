import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utility.dart';

class Settings extends StatefulWidget {
    @override
    SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {

    Settings settings = Settings();

    var repTime = Duration();
    var cyclesPerSet = 0;
    var sets = 0;
    var breakInterval = Duration();

    @override
    void initState() {
        super.initState();
        setPreferences();
    }

    void setPreferences() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        setState(() {
            if (prefs.containsKey('repTime')) {
                repTime = Duration(seconds: prefs.getInt('repTime'));
            }

            if (prefs.containsKey('cyclesPerSet')) {
                cyclesPerSet = prefs.getInt('cyclesPerSet');
            }

            if (prefs.containsKey('sets')) {
                sets = prefs.getInt('sets');
            }

            if (prefs.containsKey('breakInterval')) {
                breakInterval =
                    Duration(seconds: prefs.getInt('breakInterval'));
            }
        });
    }

    void storeKey(String key, int value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt(key, value);
    }

    @override
    Widget build(BuildContext context) {
        // TODO: implement build
        ThemeData themeData = Theme.of(context);
        return Scaffold(
            body: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.topCenter,
                child: ListView(
                    children: <Widget>[
                        ListTile(
                            onTap: () => repPicker(themeData),
                            title: Text('Time / Rep'),
                            subtitle: Text(
                                "${Utility.getMMSS(repTime)}",
                            ),
                        ),
                        ListTile(
                            onTap: () => cyclePicker(themeData),
                            title: Text('Cycles / Set'),
                            subtitle: Text(
                                "$cyclesPerSet Cycles",
                            ),
                        ),
                        ListTile(
                            onTap: () => setPicker(themeData),
                            title: Text('Sets'),
                            subtitle: Text(
                                "$sets Sets",
                            )
                        ),
                        ListTile(
                            onTap: () => breakPicker(themeData),
                            title: Text('Break interval (between sets)'),
                            subtitle: Text(
                                "${Utility.getMMSS(breakInterval)}",
                            )
                        )
                    ]
                )
            )
        );
    }

    void repPicker(ThemeData themeData) {
        Picker(
            adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(begin: 0,
                    initValue: repTime.inMinutes % 60,
                    end: 60,
                    suffix: Text(' minutes')),
                NumberPickerColumn(begin: 0,
                    initValue: repTime.inSeconds % 60,
                    end: 60,
                    suffix: Text(' seconds')),
            ]),
            delimiter: <PickerDelimiter>[
                PickerDelimiter(
                    child: Container(
                        width: 20.0,
                        alignment: Alignment.center,
                        child: Icon(Icons.more_vert),
                    ),
                )
            ],
            hideHeader: true,
            confirmText: 'OK',
            title: const Text('Select Duration'),
            selectedTextStyle: TextStyle(color: themeData.secondaryHeaderColor),
            onConfirm: (Picker picker, List<int> value) {
                // You get your duration here
                setState(() {
                    repTime = Duration(minutes: picker.getSelectedValues()[0],
                        seconds: picker.getSelectedValues()[1]);
                    storeKey("repTime", repTime.inSeconds);
                });
            },
        ).showDialog(context);
    }

    void cyclePicker(themeData) {
        Picker(
            adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(begin: 0,
                    initValue: cyclesPerSet,
                    end: 20,
                    suffix: Text(' cycles')),
            ]),
            delimiter: <PickerDelimiter>[
                PickerDelimiter(
                    child: Container(
                        width: 20.0,
                        alignment: Alignment.center,
                        child: Icon(Icons.more_vert),
                    ),
                )
            ],
            hideHeader: true,
            confirmText: 'OK',
            title: const Text('Select duration'),
            selectedTextStyle: TextStyle(color: themeData.secondaryHeaderColor),
            onConfirm: (Picker picker, List<int> value) {
                setState(() {
                    // You get your duration here
                    cyclesPerSet = picker.getSelectedValues()[0];
                    storeKey("cyclesPerSet", cyclesPerSet);
                });
            },
        ).showDialog(context);
    }

    void setPicker(themeData) {
        Picker(
            adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(
                    begin: 0, initValue: sets, end: 20, suffix: Text(' sets')),
            ]),
            delimiter: <PickerDelimiter>[
                PickerDelimiter(
                    child: Container(
                        width: 20.0,
                        alignment: Alignment.center,
                        child: Icon(Icons.more_vert),
                    ),
                )
            ],
            hideHeader: true,
            confirmText: 'OK',
            title: const Text('Select duration'),
            selectedTextStyle: TextStyle(color: themeData.secondaryHeaderColor),
            onConfirm: (Picker picker, List<int> value) {
                setState(() {
                    // You get your duration here
                    sets = picker.getSelectedValues()[0];
                    storeKey("sets", sets);
                });
            },
        ).showDialog(context);
    }

    void breakPicker(themeData) {
        Picker(
            adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(begin: 0,
                    initValue: breakInterval.inMinutes % 60,
                    end: 60,
                    suffix: Text(' minutes')),
                NumberPickerColumn(begin: 0,
                    initValue: breakInterval.inSeconds % 60,
                    end: 60,
                    suffix: Text(' seconds')),
            ]),
            delimiter: <PickerDelimiter>[
                PickerDelimiter(
                    child: Container(
                        width: 20.0,
                        alignment: Alignment.center,
                        child: Icon(Icons.more_vert),
                    ),
                )
            ],
            hideHeader: true,
            confirmText: 'OK',
            title: const Text('Select duration'),
            selectedTextStyle: TextStyle(color: themeData.secondaryHeaderColor),
            onConfirm: (Picker picker, List<int> value) {
                setState(() {
                    // You get your duration here
                    breakInterval = Duration(
                        minutes: picker.getSelectedValues()[0],
                        seconds: picker.getSelectedValues()[1]);
                    storeKey("breakInterval", breakInterval.inSeconds);
                });
            },
        ).showDialog(context);
    }
}