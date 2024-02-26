import 'package:fasting_tracker/components/home_page/main_controller.dart';
import 'package:fasting_tracker/components/utils/history_provider.dart';
import 'package:flutter/material.dart';

class TimerController extends AnimationController {
  bool wasActive = false;

  Duration? _delay;
  final MainController mainController;

  TimerController(TickerProvider vsync, {required this.mainController})
      : super(vsync: vsync);

  Duration? get delay => _delay;

  DateTime? startTime;

  final historyProvider = HistoryProvider();

  /// Sets the animation delay
  void setDelay(Duration delay) {
    _delay = delay;
  }

  /// Calculates controller start value from specified duration [startDuration]
  double? _calculateStartValue(Duration? startDuration) {
    startDuration = (startDuration != null && (startDuration > duration!))
        ? duration
        : startDuration;
    return startDuration == null
        ? null
        : (1 - (startDuration.inMilliseconds / duration!.inMilliseconds));
  }

  /// This starts the controller animation.
  ///
  /// If [startFrom] is specified, the new value is calculated
  /// and starts from that value, rather than from the [lowerBound]
  void start({bool useDelay = true, Duration? startFrom}) {
    startTime = DateTime.now();
    mainController.historyProvider.insert(HistoryModel(
        startTime: startTime.toString(), endTime: null, duration: 5));
    if (useDelay && !wasActive && (_delay != null)) {
      wasActive = true;
      Future.delayed(_delay!, () {
        forward(from: _calculateStartValue(startFrom));
      });
    } else {
      forward(from: _calculateStartValue(startFrom));
    }
  }

  Duration getPasserTime() {
    return startTime != null
        ? DateTime.now().difference(startTime!)
        : const Duration();
  }

  /// This pauses the animation
  void end() {
    stop();
    mainController.active!.endTime = DateTime.now().toString();
    mainController.historyProvider.update(mainController.active!);
  }

  /// This resets the value back to the [lowerBound]
  @override
  void reset() {
    wasActive = false;
    super.reset();
  }

  /// This resets and starts the controller animation.
  ///
  /// If [startFrom] is specified, the animation value is calculated
  /// and starts from that value, rather than from the [lowerBound]
  void restart({bool useDelay = true, Duration? startFrom}) {
    reset();
    start(startFrom: startFrom);
  }

  /// This Reduces the length of time elapsed by the specified duration.
  ///
  /// This doesn't override the initial SimpleTimer widget duration
  /// The specified duration is used to calculate the start value
  ///
  /// The [start] value sets whether or not start the timer after the
  /// value change (defaults to `false`).
  ///
  /// The [animationDuration] value sets the length of time used to animate
  /// from the previous value to the new value
  void add(Duration duration,
      {bool start = false,
      Duration changeAnimationDuration = const Duration(seconds: 0)}) {
    duration = (duration > this.duration!) ? this.duration! : duration;
    double newValue =
        value - (duration.inMilliseconds / this.duration!.inMilliseconds);
    animateBack(newValue, duration: changeAnimationDuration);
    if (start) {
      forward();
    }
  }

  /// This increases the length of time elapsed by the specified duration [duration].
  ///
  /// This doesn't override the initial SimpleTimer widget duration.
  /// The specified duration is used to calculate the start value
  ///
  /// The [start] value sets whether or not start the timer after the
  /// value change (defaults to `false`).
  ///
  /// The [animationDuration] value sets the length of time used to animate
  /// from the previous value to the new value
  void subtract(Duration duration,
      {bool start = false,
      Duration changeAnimationDuration = const Duration(seconds: 0)}) {
    duration = (duration > this.duration!) ? this.duration! : duration;
    double newValue =
        value + (duration.inMilliseconds / this.duration!.inMilliseconds);
    animateTo(newValue, duration: changeAnimationDuration);
    if (start) {
      forward();
    }
  }
}
