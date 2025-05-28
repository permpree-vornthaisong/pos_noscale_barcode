import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/cashier.dart';
import 'package:pos_noscale_barcode/A_MODEL/threme_state.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class cashier_provider with ChangeNotifier {
  List<cashier> cashiers = [
    cashier(name: "cashier", id: "00001", role: "staff"),
    cashier(name: "ADMIN_MR.A", id: "00002", role: "admin"),
    cashier(name: "MASTER_MR.A", id: "99999", role: "master"),
  ];
  String cashier_display = "";
  bool login_state = false;

  void update_state(bool state) {
    login_state = state;
    notifyListeners();
  }

  bool get_state() {
    return login_state;
  }

  Future<void> delect_by_id(context, String id) async {
    final localDatabase = LocalDatabase();

    localDatabase.delete_cashier_id(id);
    await reset_data(context);
  }

  List<String> findNameById(String id) {
    for (var cashier in cashiers) {
      if (cashier.id == id) {
        return [cashier.name, cashier.id, cashier.role, "true"];
      }
    }
    return ["-", "false"]; // คืนค่าว่างหากไม่พบ ID ที่ตรงกับใน List
  }

  Future<void> add_staff(context, String id, String name, String role) async {
    final localDatabase = LocalDatabase();

    await localDatabase.adddata_cashier(id: id, name: name, role: role);

    await reset_data(context);
  }

  Future<void> reset_data(context) async {
    final cashier_provider cashiers2 = Provider.of<cashier_provider>(context, listen: false);

    List<Map<String, dynamic>> _wholeDataList = [];

    final localDatabase = LocalDatabase();
    _wholeDataList = await localDatabase.readall_cashier();
    if (_wholeDataList.isNotEmpty) {
      ///  print(_wholeDataList);
      _data_cashier(_wholeDataList, context);
    } else {
      final localDatabase = LocalDatabase();

      for (int i = 0; i < cashiers.length; i++) {
        //cashier data = cashier(name: cashiers[i].name, id: cashiers[i].id, role: cashiers[i].role);
        await localDatabase.adddata_cashier(id: cashiers[i].id, name: cashiers[i].name, role: cashiers[i].role);
        //cashiers2.add_data(data);
      }
      // cashiers.add_data(cashier(name: "cashier", id: "00000", role: "staff"));

      ///  cashiers.add(cashier(name: "cashier", id: "00000"));
    }
    notifyListeners();
  }

  void _data_cashier(List<Map<String, dynamic>> dataList, context) {
    final cashier_provider cashiers = Provider.of<cashier_provider>(context, listen: false);

    cashiers.clear_all();
    for (Map<String, dynamic> data in dataList) {
      String id = data['id'] ?? '';
      String name = data['name'] ?? '';
      String role = data['role'] ?? '';

      cashier GG = cashier(name: name, id: id, role: role);
      cashiers.add_data(GG);
    }
    notifyListeners();
  }

  List<cashier> get_data() {
    return cashiers;
  }

  void clear_all() {
    cashiers.clear();
    notifyListeners();
  }

  void add_data(cashier data) {
    cashiers.add(data);
    notifyListeners();
  }
}

class lock_page_provider with ChangeNotifier {
  lock_page DATA = lock_page(p1: true, p2: true, p3: true, p4: true, p5: true, p6: true);

  lock_page get_data() {
    return DATA;
  }

  FutureOr<void> update_lock_page1(bool data) async {
    DATA.p1 = data;
    notifyListeners();
  }

  FutureOr<void> update_lock_page2(bool data) async {
    DATA.p2 = data;
    notifyListeners();
  }

  FutureOr<void> update_lock_page3(bool data) async {
    DATA.p3 = data;
    notifyListeners();
  }

  FutureOr<void> update_lock_page4(bool data) async {
    DATA.p4 = data;
    notifyListeners();
  }

  FutureOr<void> update_lock_page5(bool data) async {
    DATA.p5 = data;
    notifyListeners();
  }

  FutureOr<void> update_lock_page6(bool data) async {
    DATA.p6 = data;
    notifyListeners();
  }

  FutureOr<void> reset_data() async {
    List<Map<String, dynamic>> _wholeDataList = [];

    final localDatabase = LocalDatabase();

    _wholeDataList = await localDatabase.readall_lock_page();
    if (_wholeDataList.isEmpty) {
      localDatabase.adddata_lock_page(p1: DATA.p1, p2: DATA.p2, p3: DATA.p3, p4: DATA.p4, p5: DATA.p5, p6: DATA.p6);

      //   print("ADD _DATA");
    } else {
      for (Map<String, dynamic> data in _wholeDataList) {
        bool p1 = data['p1'] == 1;
        bool p2 = data['p2'] == 1;
        bool p3 = data['p3'] == 1;
        bool p4 = data['p4'] == 1;
        bool p5 = data['p5'] == 1;
        bool p6 = data['p6'] == 1;
//print("ADD 258");

        lock_page DATA_db = lock_page(p1: p1, p2: p2, p3: p3, p4: p4, p5: p5, p6: p6);

        DATA = DATA_db;
        notifyListeners();
      }
    }
  }

  FutureOr<void> save_data() async {
    final localDatabase = LocalDatabase();

    await localDatabase.updatedata_lock_page(p1: DATA.p1, p2: DATA.p2, p3: DATA.p3, p4: DATA.p4, p5: DATA.p5, p6: DATA.p6);

    await reset_data();
  }
}
