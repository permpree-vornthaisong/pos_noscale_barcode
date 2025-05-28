import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_display.dart';

class data_display_provider with ChangeNotifier {
  List<data_display> data_displays = [data_display(index: "00", id: "id", name: "---", price: "0.00", type: "type", item: 0, unit: "KG")];

  List<data_display> get_all() {
    return data_displays;
  }

  Future<void> update(data_display data) async {
    data_displays[0] = data;
    notifyListeners();
  }

  Future<void> update_money(String data) async {
    data_displays[0].price = data;
    notifyListeners();
  }

  Future<void> update_name(String data) async {
    data_displays[0].name = data;
    notifyListeners();
  }

  Future<void> removeLastCharacter() async {
    if (data_displays.isNotEmpty) {
      String currentName = data_displays[0].name;
      if (currentName.isNotEmpty) {
        String updatedName = currentName.substring(0, currentName.length - 1);
        update_name(updatedName);
      }
    }
  }
}
