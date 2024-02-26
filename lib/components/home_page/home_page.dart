import 'package:fasting_tracker/components/history/grid.dart';
import 'package:fasting_tracker/components/home_page/main_controller.dart';
import 'package:fasting_tracker/components/settings/settings_ui.dart';
import 'package:fasting_tracker/components/timer/timer_ui.dart';
import 'package:fasting_tracker/components/utils/error_ui.dart';
import 'package:fasting_tracker/components/utils/loading.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  final mainController = MainController();

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      TimerUI(mainController: mainController),
      HistoryGrid(
        mainController: mainController,
      ),
      SettingsUI(mainController: mainController)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fasting Track',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: FutureBuilder(
            future: mainController.initiate(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ErrorUI(error_text: snapshot.error.toString());
              } else if (snapshot.hasData) {
                return ValueListenableBuilder(
                    valueListenable: _selectedIndex,
                    builder: (context, value, _) {
                      return _widgetOptions[value];
                    });
              }
              return const CustomLoading();
            }),
        bottomNavigationBar: BottomNavigationBar(
          items: _getBottomMenu(),
          currentIndex: _selectedIndex.value,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomMenu() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.timer),
        label: 'Timer',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'History',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];
  }
}
