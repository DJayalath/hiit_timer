import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

import 'utility.dart';

class CustomTimerPainter extends CustomPainter {
    final Animation<double> animation;

    final Color backgroundColor, color;

    CustomTimerPainter({
        this.animation,
        this.backgroundColor,
        this.color,
    }) : super(repaint: animation);

    @override
    void paint(Canvas canvas, Size size) {
        Paint paint = Paint()
            ..color = backgroundColor
            ..strokeWidth = 10.0
            ..strokeCap = StrokeCap.butt
            ..style = PaintingStyle.stroke;

        Size realSize = Size(size.width, size.width);
        canvas.drawCircle(realSize.center(Offset.zero), realSize.width / 2.0, paint);
        paint.color = color;
        double progress = animation.value * 2 * pi;
        canvas.drawArc(Offset.zero & realSize, pi * 1.5, progress, false, paint);
    }

    @override
    bool shouldRepaint(CustomTimerPainter old) {
        return animation.value != old.animation.value ||
            color != old.color ||
            backgroundColor != old.backgroundColor;
    }
}

class Timer extends StatefulWidget {
    @override
    TimerState createState() => TimerState();
}

class TimerState extends State<Timer> with TickerProviderStateMixin {

    // Cache for audio files to play
    static AudioCache cache = new AudioCache();

    // Instance of Timer
    Timer timer = Timer();

    AnimationController controller;

    // Track break status
    var breakTime = false;
    // Track play/pause status
    bool isStopped = true;

    // Time per rep
    var repTime = Duration();

    var cyclesPerSet = 0;
    var currentCycle = 1;

    var sets = 0;
    var currentSet = 1;

    var breakInterval = Duration();

    String get timerString {
        Duration duration = Duration(
            seconds: ((breakTime) ? breakInterval : repTime).inSeconds -
                (controller.duration.inSeconds * controller.value).floor());
        if (duration.inSeconds < 60) {
            return '${duration.inSeconds}';
        } else {
            return '${Utility.getMMSS(duration)}';
        }
    }

    void resetTimer(animation) {
        setState(() {
            currentSet = 1;
            currentCycle = 1;
            breakTime = false;
            isStopped = true;
            animation.reset();
        });
    }

    @override
    Widget build(BuildContext context) {
        ThemeData themeData = Theme.of(context);
        return Scaffold(
            body: Column(
                children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(
                            0.0, 40.0, 0.0, 20.0,
                        ),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text((breakTime) ? "REST" : "PUSH",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 60.0,
                                    color: (!breakTime) ? themeData.secondaryHeaderColor : themeData.accentColor,
                                ),
                            ),
                        ),
                    ),
                    Container(
                        // Internal padding (pushes things inside closer together)
                        margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        height: 300.0,
                        width: 300.0,
                        child: AnimatedBuilder(
                            animation: controller,
                            child: FloatingActionButton(
//                                label: Text(
//                                    "Reset",
//                                ),
                                child: Icon(
                                    Icons.cancel,
                                ),
                                backgroundColor: themeData.secondaryHeaderColor,
                                onPressed: () => resetTimer(controller),
                            ),
                            builder: (context, child) {
                                return Stack(
                                    children: <Widget>[
                                        Positioned.fill(
                                            child: CustomPaint(
                                                painter: CustomTimerPainter(
                                                    animation: controller,
                                                    backgroundColor: themeData.errorColor,
                                                    color: (breakTime) ? themeData.accentColor : themeData.secondaryHeaderColor,
                                                ),
                                            ),
                                        ),
                                        Align(
                                            alignment: FractionalOffset.center,
                                            child: Container(
                                                height: 170,
                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                      FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text(
                                                              timerString,
                                                              style: TextStyle(
                                                                  fontSize: 90.0,
                                                                  color: themeData.errorColor,
                                                              ),
                                                          ),
                                                      ),
                                                      Container(
                                                          width: 150,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[
                                                                  AnimatedBuilder(
                                                                      animation: controller,
                                                                      builder: (context, child) {
                                                                          return FloatingActionButton(
                                                                              onPressed: () {
                                                                                  if (controller.isAnimating) {
                                                                                      isStopped = true;
                                                                                      Wakelock.disable();
                                                                                      controller.stop();
                                                                                      setState(() {

                                                                                      });
                                                                                  } else {
                                                                                      isStopped = false;
                                                                                      Wakelock.enable();
                                                                                      controller.forward(from: controller.value);

                                                                                      controller.addStatusListener((status) {
                                                                                          if (status == AnimationStatus.completed) {
                                                                                              setState(() {
                                                                                                  if (!breakTime) {
                                                                                                      currentCycle++;
                                                                                                      if (currentCycle - 1 == cyclesPerSet) {
                                                                                                          playRestSound();
                                                                                                      } else {
                                                                                                          playPushSound();
                                                                                                      }
                                                                                                  }
                                                                                                  if (currentCycle - 1 == cyclesPerSet) {
                                                                                                      // INITIATE BREAK
                                                                                                      controller.duration = breakInterval;
                                                                                                      breakTime = true;
                                                                                                      currentSet++; // AFTER BREAK
                                                                                                      currentCycle = 1;
                                                                                                  } else {
                                                                                                      breakTime = false;
                                                                                                      playPushSound();
                                                                                                      controller.duration = repTime;
                                                                                                  }
                                                                                                  if (currentSet - 1 == sets) {
                                                                                                      currentSet = 1;
                                                                                                      currentCycle = 1;
                                                                                                      controller.reset();
                                                                                                      controller.stop();
                                                                                                      Wakelock.disable();
                                                                                                  } else {
                                                                                                      controller.reset();
                                                                                                      controller.forward(from: 0.0);
                                                                                                  }
                                                                                              });
                                                                                          }
                                                                                      });
                                                                                  }
                                                                              },
                                                                              child: Icon(
                                                                                  (() {
                                                                                      if (isStopped) {
                                                                                          return Icons.play_arrow;
                                                                                      } else {
                                                                                          return Icons.pause;
                                                                                      }
                                                                                  }())
                                                                              ),
//                                                                              label: Text(""
//                                                                                  controller.isAnimating ? "Pause" : "Start"
//                                                                              )
                                                                          );
                                                                      }),
                                                                  child,
                                                              ],
                                                          ),
                                                      ),
                                                  ],
                                              ),
                                            ),
                                        ),
                                    ],
                                );
                            }
                        ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 60.0, 0, 0.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                                Column(
                                    children: <Widget>[
                                        Center(
                                            child: Text(
                                                "$currentCycle/$cyclesPerSet",
                                                style: TextStyle(
                                                    fontSize: 60.0,
                                                    color: themeData.accentColor,
                                                )
                                            ),
                                        ),
                                        Center(
                                            child: Text(
                                                "cycles",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: themeData.hintColor,
                                                )
                                            )
                                        ),
                                    ],
                                ),
                                Column(
                                    children: <Widget>[
                                        Center(
                                            child: Text(
                                                "$currentSet/$sets",
                                                style: TextStyle(
                                                    fontSize: 60.0,
                                                    color: themeData.accentColor,
                                                ),
                                            ),
                                        ),
                                        Center(
                                            child: Text(
                                                "sets",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: themeData.hintColor,
                                                )
                                            )
                                        ),
                                    ],
                                )
                            ],
                        ),
                    )
                ],
            )
        );
    }

    @override
    void dispose() {
        controller.dispose();
        super.dispose();
    }

    @override
    void initState() {
        super.initState();

        controller = AnimationController(
            vsync: this,
            duration: Duration(seconds: 20),
        );

        cache.loadAll(["push.wav", "rest.wav"]);
        setTimerState();
    }

    Future<AudioPlayer> playPushSound() async {
        return await cache.play("push.wav");
    }

    Future<AudioPlayer> playRestSound() async {
        return await cache.play("rest.wav");
    }

    void setTimerState() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        setState(() {
            if (prefs.containsKey('repTime')) {
                repTime = Duration(seconds: prefs.getInt('repTime'));
                controller.duration = repTime;
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
}
