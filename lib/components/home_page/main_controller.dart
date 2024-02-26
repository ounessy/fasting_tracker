import 'package:fasting_tracker/components/utils/history_provider.dart';
import 'package:flutter/material.dart';

class MainController extends ChangeNotifier {
  final HistoryProvider historyProvider = HistoryProvider();
  HistoryModel? active;
  MainController();

  Future<bool> initiate() async {
    await historyProvider.open();
    return true;
  }
}
