import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'analog_clock.dart';

class Timer extends StatefulWidget {
    @override
    TimerState createState() => TimerState();

}

class TimerState extends State<Timer> {
    Timer timer = Timer();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                alignment: Alignment.topCenter,
                child: AnalogClock(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.white),
                        color: Colors.transparent,
                        shape: BoxShape.circle),
                    width: 350.0,
                    isLive: false,
                    hourHandColor: Colors.greenAccent,
                    minuteHandColor: Colors.greenAccent,
                    showSecondHand: false,
                    numberColor: Colors.white,
                    showNumbers: false,
                    textScaleFactor: 2.5,
                    showTicks: true,
                    showDigitalClock: true,
                    digitalClockColor: Colors.white,
                    datetime: DateTime(2019, 1, 1, 9, 12, 15),
                ),
            ),
        );
    }
}