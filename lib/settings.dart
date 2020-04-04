import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

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
    Widget build(BuildContext context) {
        // TODO: implement build
        return Scaffold (
            body: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.topCenter,
                child: ListView(
                    children: <Widget>[
                        ListTile(
                            onTap: () => repPicker(),
                            title: Text('Time / Rep'),
                            subtitle: Text(
                                "${_printDuration(repTime)}",
                            ),
                        ),
                        ListTile(
                            onTap: () => cyclePicker(),
                            title: Text('Cycles / Set'),
                            subtitle: Text(
                                "$cyclesPerSet Cycles",
                            ),
                        ),
                        ListTile(
                            onTap: () => setPicker(),
                            title: Text('Sets'),
                            subtitle: Text(
                                "$sets Sets",
                            )
                        ),
                        ListTile(
                            onTap: () => breakPicker(),
                            title: Text('Break interval (between sets)'),
                            subtitle: Text(
                                "${_printDuration(breakInterval)}",
                            )
                        )
                    ]
                )
            )
        );
    }

    void repPicker() {
        Picker(
            adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(begin: 0, initValue: repTime.inMinutes % 60, end: 60, suffix: Text(' minutes')),
                NumberPickerColumn(begin: 0, initValue: repTime.inSeconds % 60, end: 60, suffix: Text(' seconds')),
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
            confirmTextStyle: TextStyle(inherit: false, color: Colors.red, fontSize: 22),
            title: const Text('Select duration'),
            selectedTextStyle: TextStyle(color: Colors.blue),
            onConfirm: (Picker picker, List<int> value) {
                setState(() {
                    // You get your duration here
                    repTime = Duration(minutes: picker.getSelectedValues()[0], seconds: picker.getSelectedValues()[1]);
                });
            },
        ).showDialog(context);
    }

    void cyclePicker() {
        Picker(
            adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(begin: 0, initValue: cyclesPerSet, end: 20, suffix: Text(' cycles')),
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
            confirmTextStyle: TextStyle(inherit: false, color: Colors.red, fontSize: 22),
            title: const Text('Select duration'),
            selectedTextStyle: TextStyle(color: Colors.blue),
            onConfirm: (Picker picker, List<int> value) {
                setState(() {
                    // You get your duration here
                    cyclesPerSet = picker.getSelectedValues()[0];
                });
            },
        ).showDialog(context);
    }

    void setPicker() {
        Picker(
            adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(begin: 0, initValue: sets, end: 20, suffix: Text(' sets')),
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
            confirmTextStyle: TextStyle(inherit: false, color: Colors.red, fontSize: 22),
            title: const Text('Select duration'),
            selectedTextStyle: TextStyle(color: Colors.blue),
            onConfirm: (Picker picker, List<int> value) {
                setState(() {
                    // You get your duration here
                    sets = picker.getSelectedValues()[0];
                });
            },
        ).showDialog(context);
    }

    void breakPicker() {
        Picker(
            adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(begin: 0, initValue: breakInterval.inMinutes % 60, end: 60, suffix: Text(' minutes')),
                NumberPickerColumn(begin: 0, initValue: breakInterval.inSeconds % 60, end: 60, suffix: Text(' seconds')),
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
            confirmTextStyle: TextStyle(inherit: false, color: Colors.red, fontSize: 22),
            title: const Text('Select duration'),
            selectedTextStyle: TextStyle(color: Colors.blue),
            onConfirm: (Picker picker, List<int> value) {
                setState(() {
                    // You get your duration here
                    breakInterval = Duration(minutes: picker.getSelectedValues()[0], seconds: picker.getSelectedValues()[1]);
                });
            },
        ).showDialog(context);
    }

    String _printDuration(Duration duration) {
        String twoDigits(int n) {
            if (n >= 10) return "$n";
            return "0$n";
        }

        String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
        return "$twoDigitMinutes:$twoDigitSeconds";
    }
}