import 'package:fasting_tracker/components/home_page/main_controller.dart';
import 'package:fasting_tracker/components/timer/emuns.dart';
import 'package:flutter/material.dart';
import 'package:fasting_tracker/components/timer/clock.dart';

import 'timer_controller.dart';

class TimerUI extends StatefulWidget {
  final MainController mainController;
  const TimerUI({Key? key, required this.mainController}) : super(key: key);

  @override
  _TimerUIState createState() => _TimerUIState();
}

class _TimerUIState extends State<TimerUI> with SingleTickerProviderStateMixin {
  late TimerController _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;

  @override
  void initState() {
    // initialize timercontroller
    _timerController =
        TimerController(this, mainController: widget.mainController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Expanded(
            child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ClockUI(
            duration: const Duration(hours: 5),
            mainController: widget.mainController,
            controller: _timerController,
            timerStyle: _timerStyle,
            onStart: handleTimerOnStart,
            onEnd: handleTimerOnEnd,
            valueListener: timerValueChangeListener,
            backgroundColor: Colors.grey,
            progressIndicatorColor: Colors.green,
            progressIndicatorDirection: _progressIndicatorDirection,
            progressTextCountDirection: _progressTextCountDirection,
            progressTextStyle: const TextStyle(color: Colors.black),
            strokeWidth: 10,
          ),
        )),
        Column(
          children: <Widget>[
            const Text(
              "Timer Status",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FutureBuilder(
                    future:
                        widget.mainController.historyProvider.checkForActive(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        widget.mainController.active = snapshot.data;
                        return TextButton(
                            onPressed: _timerController.end,
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: Text("End",
                                style: TextStyle(color: Colors.white)));
                      }
                      return TextButton(
                          onPressed: _timerController.start,
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: Text("Start",
                              style: TextStyle(color: Colors.white)));
                    }),
              ],
            )
          ],
        ),
      ],
    ));
  }

  void _setCountDirection(TimerProgressTextCountDirection countDirection) {
    setState(() {
      _progressTextCountDirection = countDirection;
    });
  }

  void _setProgressIndicatorDirection(
      TimerProgressIndicatorDirection progressIndicatorDirection) {
    setState(() {
      _progressIndicatorDirection = progressIndicatorDirection;
    });
  }

  void _setStyle(TimerStyle timerStyle) {
    setState(() {
      _timerStyle = timerStyle;
    });
  }

  void timerValueChangeListener(Duration timeElapsed) {}

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd() {
    print("timer has ended");
  }
}
