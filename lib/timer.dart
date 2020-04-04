import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Timer extends StatefulWidget {
    @override
    TimerState createState() => TimerState();

}

class TimerState extends State<Timer> with TickerProviderStateMixin {
    Timer timer = Timer();

    AnimationController controller;
    var inBreak = false;

    String get timerString {
        Duration duration = Duration(seconds: ((inBreak) ? breakInterval : repTime).inSeconds - (controller.duration.inSeconds * controller.value).floor());
        if (duration.inSeconds <= 60) {
            return '${(duration.inSeconds % 60).toString()}';
        } else {
            return '${duration.inMinutes}:${duration.inSeconds % 60}';
        }
    }

    @override
    void initState() {
        super.initState();

        controller = AnimationController(
            vsync: this,
            duration: Duration(seconds: 20),
        );

        setTimerState();
    }

    var repTime = Duration();
    var cyclesPerSet = 0;
    var cyclesRemaining = 1;
    var sets = 0;
    var setsRemaining = 1;
    var breakInterval = Duration();

    void setTimerState() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        setState(() {
            if (prefs.containsKey('repTime')) {
                repTime = Duration(seconds: prefs.getInt('repTime'));
                controller = AnimationController(
                    vsync: this,
                    duration: repTime,
                );
            }

            if (prefs.containsKey('cyclesPerSet')) {
                cyclesPerSet = prefs.getInt('cyclesPerSet');
            }

            if (prefs.containsKey('sets')) {
                sets = prefs.getInt('sets');
            }

            if (prefs.containsKey('breakInterval')) {
                breakInterval = Duration(seconds: prefs.getInt('breakInterval'));
            }
        });
    }

    @override
    Widget build(BuildContext context) {
        ThemeData themeData = Theme.of(context);
        return Scaffold(
//            backgroundColor: Colors.white10,
            body: Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                      return Stack(
                          children: <Widget>[
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 50.0),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                  child: Text(
                                      (inBreak) ? "REST" : "PUSH",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 40.0,
                                          color: (!inBreak) ? Colors.redAccent : Colors.greenAccent,
                                      )
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 15.0),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                          Expanded(
                                              child: Align(
                                                  alignment: FractionalOffset.center,
                                                  child: AspectRatio(
                                                      aspectRatio: 1.0,
                                                      child: Stack(
                                                          children: <Widget>[
                                                              Positioned.fill(
                                                                  child: CustomPaint(
                                                                      painter: CustomTimerPainter(
                                                                          animation: controller,
                                                                          backgroundColor: Colors.white,
                                                                          color: (inBreak) ? themeData.indicatorColor : Colors.redAccent,
                                                                      )),
                                                              ),
                                                              Align(
                                                                  alignment: FractionalOffset.center,
                                                                  child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: <Widget>[
                                                                          Text(
                                                                              timerString,
                                                                              style: TextStyle(
                                                                                  fontSize: 112.0,
                                                                                  color: Colors.white),
                                                                          ),
                                                                          AnimatedBuilder(
                                                                              animation: controller,
                                                                              builder: (context, child) {
                                                                                  return FloatingActionButton.extended(
                                                                                      onPressed: () {
                                                                                          if (controller.isAnimating)
                                                                                              controller.stop();
                                                                                          else {
                                                                                              controller.forward(
                                                                                                  from: controller.value,
                                                                                              );
//                                                              controller.reverse(
//                                                                  from: controller.value == 0.0
//                                                                      ? 1.0
//                                                                      : controller.value);

                                                                                              controller.addStatusListener((status) {
                                                                                                  if (status == AnimationStatus.completed) {
                                                                                                      setState(() {
                                                                                                          if (!inBreak) {
                                                                                                              cyclesRemaining++;
                                                                                                          }
                                                                                                          if (cyclesRemaining - 1 == cyclesPerSet) {
                                                                                                              // INITIATE BREAK
                                                                                                              controller.duration = breakInterval;
                                                                                                              inBreak = true;
                                                                                                              setsRemaining++; // AFTER BREAK
                                                                                                              cyclesRemaining = 1;

                                                                                                              if (setsRemaining - 1 == sets) {
                                                                                                                  controller.reset();
                                                                                                              }
                                                                                                          } else {
                                                                                                              inBreak = false;
                                                                                                              controller.duration = repTime;
                                                                                                          }
                                                                                                          controller.reset();
                                                                                                          controller.forward(from: 0.0);

                                                                                                      });
                                                                                                  }
                                                                                              });
                                                                                          }
                                                                                      },
                                                                                      icon: Icon(controller.isAnimating
                                                                                          ? Icons.pause
                                                                                          : Icons.play_arrow),
                                                                                      label: Text(
                                                                                          controller.isAnimating ? "Pause" : "Play"));
                                                                              }),
                                                                      ],
                                                                  ),
                                                              ),
                                                          ],
                                                      ),
                                                  ),
                                              ),
                                          ),
                                      ],
                                  ),
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
                                            child: Text(
                                                "Cycle $cyclesRemaining/$cyclesPerSet",
                                                style: TextStyle(
                                                    fontSize: 40.0,
                                                    color: Colors.white70,
                                                )
                                            ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
                                            child: Text(
                                                "Set $setsRemaining/$sets",
                                                style: TextStyle(
                                                    fontSize: 40.0,
                                                    color: Colors.white70,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                              ),
                          ],
                      );
                  }),
            ),
        );
    }
}

class CustomTimerPainter extends CustomPainter {
    CustomTimerPainter({
        this.animation,
        this.backgroundColor,
        this.color,
    }) : super(repaint: animation);

    final Animation<double> animation;
    final Color backgroundColor, color;

    @override
    void paint(Canvas canvas, Size size) {
        Paint paint = Paint()
            ..color = backgroundColor
            ..strokeWidth = 10.0
            ..strokeCap = StrokeCap.butt
            ..style = PaintingStyle.stroke;

        canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
        paint.color = color;
        double progress = animation.value * 2 * pi;
        canvas.drawArc(Offset.zero & size, pi * 1.5, progress, false, paint);
    }

    @override
    bool shouldRepaint(CustomTimerPainter old) {
        return animation.value != old.animation.value ||
            color != old.color ||
            backgroundColor != old.backgroundColor;
    }

}