import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/filter_num_name.dart';

class filter_num_name_provider with ChangeNotifier {
  List<filter_num_name> filter_num_names = [filter_num_name(state: "name")];
  String filter_datas = "";

  String get_data_filter() {
    return filter_datas;
  }

  void update_data(String data) {
    filter_datas = data;
    notifyListeners();
  }

  List<filter_num_name> get_all() {
    return filter_num_names;
  }

  void update_state(String data) {
    filter_num_names[0].state = data;
    print(filter_num_names[0].state);
    notifyListeners();
  }
}
