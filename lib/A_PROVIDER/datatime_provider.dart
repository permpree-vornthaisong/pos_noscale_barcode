import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class time_search_his_provider with ChangeNotifier {
  List<time_search_his> time_search_hiss = [
    time_search_his(Y: 0, M: 0, D: 0, h: 0, m: 0, s: 0), //A
    time_search_his(Y: 0, M: 0, D: 0, h: 23, m: 59, s: 59), //B
  ];

  int get_start_time() {
    time_search_his startTime = time_search_hiss[0];
    DateTime dateTime = DateTime(startTime.Y, startTime.M, startTime.D, startTime.h, startTime.m, startTime.s);
    return dateTime.millisecondsSinceEpoch ~/ 1000; // Convert to seconds
  }

  int get_end_time() {
    time_search_his endTime = time_search_hiss[1];
    DateTime dateTime = DateTime(endTime.Y, endTime.M, endTime.D, endTime.h, endTime.m, endTime.s);
    return dateTime.millisecondsSinceEpoch ~/ 1000; // Convert to seconds
  }

  String getFormattedTimeNow() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(now);
  }

  int getUnixNow() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch ~/ 1000; // Convert to seconds
  }

  List<time_search_his> get_all() {
    return time_search_hiss;
  }

  void addTransaction(time_search_his statement) {
    time_search_hiss.add(statement);
    notifyListeners();
  }
  /////////////////////////////////////////////////////
/////////////////////////////////////////////////////

  void update_Y_start(int NUM) {
    time_search_hiss[0].Y = NUM;
    notifyListeners();
  }

  void update_M_start(int NUM) {
    time_search_hiss[0].M = NUM;
    notifyListeners();
  }

  void update_D_start(int NUM) {
    time_search_hiss[0].D = NUM;
    notifyListeners();
  }

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
  void update_Y_END(int NUM) {
    time_search_hiss[1].Y = NUM;
    notifyListeners();
  }

  void update_M_END(int NUM) {
    time_search_hiss[1].M = NUM;
    notifyListeners();
  }

  void update_D_END(int NUM) {
    time_search_hiss[1].D = NUM;
    notifyListeners();
  }

  Future<void> NOW_TIME() async {
    final now = DateTime.now();

    // ตั้งค่า time_search_hiss ให้เป็นปีนี้ เดือนนี้ วันนี้
    time_search_hiss[0] = time_search_his(
      Y: now.year,
      M: now.month,
      D: now.day,
      h: 0,
      m: 0,
      s: 0,
    );

    time_search_hiss[1] = time_search_his(
      Y: now.year,
      M: now.month,
      D: now.day,
      h: 23,
      m: 59,
      s: 59,
    );
    notifyListeners();
  }

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
  void clearAllData() {
    time_search_hiss.clear();
    notifyListeners();
  }
}

class time_search_stock_provider with ChangeNotifier {
  List<time_search_his> time_search_hiss = [
    time_search_his(Y: 0, M: 0, D: 0, h: 0, m: 0, s: 0), //A
    time_search_his(Y: 0, M: 0, D: 0, h: 23, m: 59, s: 59), //B
  ];

  int get_start_time() {
    time_search_his startTime = time_search_hiss[0];
    DateTime dateTime = DateTime(startTime.Y, startTime.M, startTime.D, startTime.h, startTime.m, startTime.s);
    return dateTime.millisecondsSinceEpoch ~/ 1000; // Convert to seconds
  }

  int get_end_time() {
    time_search_his endTime = time_search_hiss[1];
    DateTime dateTime = DateTime(endTime.Y, endTime.M, endTime.D, endTime.h, endTime.m, endTime.s);
    return dateTime.millisecondsSinceEpoch ~/ 1000; // Convert to seconds
  }

  String formatDateTime(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
  }

  String get_start_time_formatted() {
    int startTime = get_start_time();
    return formatDateTime(startTime);
  }

  String get_end_time_formatted() {
    int endTime = get_end_time();
    return formatDateTime(endTime);
  }

  String getFormattedTimeNow() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(now);
  }

  int getUnixNow() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch ~/ 1000; // Convert to seconds
  }

  List<time_search_his> get_all() {
    return time_search_hiss;
  }

  void addTransaction(time_search_his statement) {
    time_search_hiss.add(statement);
    notifyListeners();
  }
  /////////////////////////////////////////////////////
/////////////////////////////////////////////////////

  void update_Y_start(int NUM) {
    time_search_hiss[0].Y = NUM;
    notifyListeners();
  }

  void update_M_start(int NUM) {
    time_search_hiss[0].M = NUM;
    notifyListeners();
  }

  void update_D_start(int NUM) {
    time_search_hiss[0].D = NUM;
    notifyListeners();
  }

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
  void update_Y_END(int NUM) {
    time_search_hiss[1].Y = NUM;
    notifyListeners();
  }

  void update_M_END(int NUM) {
    time_search_hiss[1].M = NUM;
    notifyListeners();
  }

  void update_D_END(int NUM) {
    time_search_hiss[1].D = NUM;
    notifyListeners();
  }

  Future<void> NOW_TIME() async {
    final now = DateTime.now();

    // ตั้งค่า time_search_hiss ให้เป็นปีนี้ เดือนนี้ วันนี้
    time_search_hiss[0] = time_search_his(
      Y: now.year,
      M: now.month,
      D: now.day,
      h: 0,
      m: 0,
      s: 0,
    );

    time_search_hiss[1] = time_search_his(
      Y: now.year,
      M: now.month,
      D: now.day,
      h: 23,
      m: 59,
      s: 59,
    );
    notifyListeners();
  }

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
  void clearAllData() {
    time_search_hiss.clear();
    notifyListeners();
  }
}

class time_search_his {
  int Y = 0;
  int M = 0;
  int D = 0;

  int h = 0;

  int m = 0;

  int s = 0;
  time_search_his({
    required this.Y,
    required this.M,
    required this.D,
    required this.h,
    required this.m,
    required this.s,
  });
}
