import 'package:fasting_tracker/components/home_page/main_controller.dart';
import 'package:flutter/material.dart';

class SettingsUI extends StatelessWidget {
  final MainController mainController;
  const SettingsUI({super.key, required this.mainController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(children: [
        Center(
          child: TextButton(
            onPressed: () {
              mainController.historyProvider.deleteAll();
            },
            child: Text("Delete History"),
          ),
        ),
      ]),
    );
  }
}
