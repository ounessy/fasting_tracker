import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:convert';

const historyTableName = "history";

HistoryModel historyModelFromJson(String str) =>
    HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  int? id;
  String startTime;
  String? endTime;
  int? duration;

  HistoryModel({
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.id,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        id: json["id"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
        "duration": duration,
      };
}

class HistoryProvider {
  Database? db;

  Future<Database?> open() async {
    db = await openDatabase("$historyTableName.db", version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $historyTableName 
          (id INTEGER PRIMARY KEY autoincrement, duration int, startTime TEXT, endTime TEXT)''');
    });
    return db;
  }

  Future<HistoryModel> insert(HistoryModel history) async {
    history.id = await db!.insert(historyTableName, history.toJson());
    return history;
  }

  void readCurrent() {}

  Future<List<HistoryModel>?> readHistory() async {
    ///if (db == null) {
    ///  await open();
    ///}

    ///db!.insert(
    ///    historyTableName,
    ///    HistoryModel(startTime: "startTime", endTime: "endTime", duration: 12)
    ///        .toJson());
    List<Map<String, dynamic>> _hist = await db!.query(historyTableName);
    List<HistoryModel> hist = [];
    if (_hist.isNotEmpty) {
      for (var element in _hist) {
        hist.add(HistoryModel.fromJson(element));
      }
      return hist;
    }
    return null;
  }

  void deleteAll() {
    db!.delete(historyTableName);
  }

  Future<HistoryModel?> checkForActive() async {
    ///if (db == null) {
    ///  await open();
    ///}

    List<Map<String, dynamic>> active =
        await db!.query(historyTableName, where: 'endTime is NULL ;');
    if (active.isNotEmpty) {
      return HistoryModel.fromJson(active.first);
    }
    return null;
  }

  Future<int> update(HistoryModel history) async {
    ///if (db == null) {
    ///  await open();
    ///}
    return await db!
        .update(historyTableName, history.toJson(), where: 'endTime is NULL;');
  }
}
