import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';

class activate {
  int b1 = 0;
  int b2 = 0;
  int b3 = 0;
  bool active = false;
  activate({required this.b1, required this.b2, required this.b3, required this.active});
}

class activate_provider with ChangeNotifier {
  activate DATA = activate(b1: 0, b2: 0, b3: 0, active: false);

  activate get_data() {
    return DATA;
  }

  Future<void> prepare_data() async {
    List<Map<String, dynamic>> product_db = [];

    final localDatabase = LocalDatabase();

    product_db = await localDatabase.getAll_active();

    if (product_db.length > 0) {
      for (Map<String, dynamic> data in product_db) {
        int b1 = data['b1'];
        int b2 = data['b2'];
        int b3 = data['b3'];
        bool active = data['active'] == 1;

        activate DATA_DB = activate(b1: b1, b2: b2, b3: b3, active: active);

        update_data(DATA_DB);
      }
    } else {
      final random = Random();

      int b1 = random.nextInt(5001); // nextInt(5001) generates a number from 0 to 5000
      int b2 = random.nextInt(5001); // nextInt(5001) generates a number from 0 to 5000
      int b3 = random.nextInt(5001); // nextInt(5001) generates a number from 0 to 5000
      bool active = false;
      localDatabase.add_activate(b1: b1, b2: b2, b3: b3, active: false);
      activate DATA_DB = activate(b1: b1, b2: b2, b3: b3, active: active);

      update_data(DATA_DB);
    }
  }

  void update_data(activate data) {
    DATA = data;
    notifyListeners();
  }

  Future<void> active_system(context) async {
    final localDatabase = LocalDatabase();

    await localDatabase.update_activate(b1: DATA.b1, b2: DATA.b2, b3: DATA.b3, active: true, context: context);

    await prepare_data();
  }
}
