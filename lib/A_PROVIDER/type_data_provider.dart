import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_product.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:provider/provider.dart';

class type_data_provider with ChangeNotifier {
  List<type_data> type_datas = [type_data(type: "type")];
  List<type_data> type_datas_filtter_sellect = [type_data(type: "?")];

  String type_datas_filter = "";
  String type_datas_setting = "";

  String type_select = "";

  String get_type_scelect() {
    return type_select;
  }

  void update_type_select(String data) {
    type_select = data;
    //print(type_select);
    notifyListeners();
  }

  List<type_data> DATA_Select() {
    return type_datas_filtter_sellect;
  }

  String DATA_INDEX() {
    return type_datas_filter;
  }

  String DATA_INDEX_setting() {
    return type_datas_setting;
  }

  List<type_data> get_all() {
    return type_datas;
  }

  Future<void> info_select(String DATA) async {
    type_datas_filtter_sellect = type_datas.where((data) => data.type.toLowerCase().contains(DATA.toLowerCase())).toList();
    notifyListeners();
  }

  Future<void> info(context) async {
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    // print("Button Pressed");
    // print(data_products.get_all().length);
    // print(type_datas.length);

    clear_data_all();

    for (var product in data_products.get_all_nofilter()) {
      bool typeExists = type_datas.any((type) => type.type == product.type);

      if (!typeExists) {
        type_data GG = type_data(type: product.type);
        //  print("Processing item 2");
        add_data(GG);
      }
    }

    notifyListeners();
  }

  void add_data(type_data data) {
    type_datas.add(data);
    notifyListeners();
  }

  Future<void> update_filter(String data) async {
    //print(data);
    type_datas_filter = data;
    // print(type_datas_filter);

    notifyListeners();
  }

  Future<void> update_filter_setting(String data) async {
    // print(data);
    type_datas_setting = data;
    //  print(type_datas_filter);

    notifyListeners();
  }

  Future<void> clear_data_all() async {
    type_datas.clear();
    notifyListeners();
  }
}
