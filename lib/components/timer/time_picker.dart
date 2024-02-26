import 'package:fasting_tracker/components/home_page/main_controller.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final ValueNotifier<int> duration;
  final MainController mainController;
  const TimePicker(
      {super.key, required this.duration, required this.mainController});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  _TimePickerState();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getTextButton(onPressed: _subHour, txt: "-"),
        ValueListenableBuilder(
            valueListenable: widget.duration,
            builder: (context, value, _) {
              //widget.mainController.active.duration = value;
              return RichText(
                  text: TextSpan(style: _getTimerTextStyle(), children: [
                TextSpan(text: value.toString()),
                TextSpan(
                    text: " hr",
                    style: _getTimerTextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .fontSize)),
              ]));
            }),
        _getTextButton(onPressed: _addHour, txt: "+")
      ],
    );
  }

  TextStyle _getTimerTextStyle({double? fontSize, Color? color}) {
    fontSize = fontSize ?? Theme.of(context).textTheme.displayMedium!.fontSize;
    color = color ?? Colors.black;
    return TextStyle(fontSize: fontSize, color: color);
  }

  void _addHour() {
    widget.duration.value = widget.duration.value + 1;
  }

  void _subHour() {
    widget.duration.value =
        widget.duration.value > 0 ? widget.duration.value - 1 : 0;
  }

  Widget _getTextButton(
      {required Function() onPressed,
      required String txt,
      TextStyle? textStyle}) {
    return TextButton(
        onPressed: onPressed,
        child: Text(txt, style: textStyle ?? _getTimerTextStyle()));
  }
}
