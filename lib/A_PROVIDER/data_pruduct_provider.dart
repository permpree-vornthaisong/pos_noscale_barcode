import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_product.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_scanner_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/filter_numname_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class data_product_provider with ChangeNotifier {
  List<data_product> data_products = [];
  List<data_product> filters = [];
  List<data_product> filters_setting = [];

  List<data_product> get_all() {
    return filters;
  }

  List<data_product> get_all_setting() {
    return filters_setting;
  }

  List<data_product> get_all_nofilter() {
    return data_products;
  }

  void add_data(data_product data) {
    data_products.add(data);
    notifyListeners();
  }

  void update_data(int index, data_product data) {
    data_products[index] = data;
    notifyListeners();
  }

  void data_clear_all() {
    data_products.clear();
    notifyListeners();
  }

  Future<void> info(context) async {
    final data_scanner_provider data_scanners = Provider.of<data_scanner_provider>(context, listen: false);
    final type_data_provider type_datas = Provider.of<type_data_provider>(context, listen: false);
    final filter_num_name_provider filter_num_names = Provider.of<filter_num_name_provider>(context, listen: false);

    filters = data_products.where((data) => data.id.toLowerCase().contains(data_scanners.get_all()[0].data.toLowerCase())).toList();
    filters = filters.where((data) => data.type.toLowerCase().contains(type_datas.DATA_INDEX().toLowerCase())).toList();
    if (filter_num_names.get_all()[0].state == "name") {
      filters = filters.where((data) => data.name.toLowerCase().contains(filter_num_names.get_data_filter().toLowerCase())).toList();
    } else {
      filters = filters.where((data) => data.id.toLowerCase().contains(filter_num_names.get_data_filter().toLowerCase())).toList();
    }

    filters = filters.where((data) => data.id != "99999" && data.id.trim().isNotEmpty).toList(); //data.id != "999" &&
    filters.sort((a, b) => a.id.compareTo(b.id));

    notifyListeners();
  }

  Future<void> info_setting(context) async {
    final type_data_provider type_datas = Provider.of<type_data_provider>(context, listen: false);

    filters_setting =
        data_products.where((data) => data.id != "99999" && data.type.toLowerCase().contains(type_datas.DATA_INDEX_setting().toLowerCase())).toList();
    //   print(filters_setting.length);
    filters_setting.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

    notifyListeners();
  }

  Future<void> change_price(context, String id, String PRICE) async {
    final localDatabase = LocalDatabase();
    await localDatabase.updatedata_price_product(id: id, price: PRICE);
    final type_datas = Provider.of<type_data_provider>(context, listen: false);

    await reset_data(context);
    await info(context);
    await info_setting(context);

/*
    await type_datas.update_filter_setting("");
    await type_datas.update_filter("");
    await info_setting(context);
    await info(context);*/
    notifyListeners();
  }

  Future<void> delect_index(context, int data) async {
    final type_datas = Provider.of<type_data_provider>(context, listen: false);
    final data_products = Provider.of<data_product_provider>(context, listen: false);

    // print(data_products.get_all_nofilter()[data].index);
    // print(data_products.get_all_nofilter()[data].index);
    // print(data_products.get_all_nofilter()[data].index);

    final localDatabase = LocalDatabase();

    await localDatabase.deleteDataByIndex((data_products.get_all_setting()[data].id));
    await reset_data(context);
    /*await type_datas.update_filter_setting("");
    await type_datas.update_filter("");
    await type_datas.clear_data_all();*/
    await info_setting(context);
    await info(context);
    notifyListeners();
  }

  Future<void> delect_type(context, String data) async {
    final type_datas = Provider.of<type_data_provider>(context, listen: false);

    final localDatabase = LocalDatabase();
    await localDatabase.deleteDataByTYPE(data);
    await reset_data(context);

    await type_datas.update_filter_setting("");
    await type_datas.update_filter("");

    await type_datas.clear_data_all();
    await info_setting(context);
    await info(context);
    notifyListeners();
  }

  Future<void> clear_first() async {
    data_products.removeAt(0);

    notifyListeners();
  }

  Future<void> clear_all_data() async {
    data_products.clear();

    notifyListeners();
  }

  Future<void> reset_data(context) async {
    final localDatabase = LocalDatabase();
    List<Map<String, dynamic>> _wholeDataList = [];

    _wholeDataList = await localDatabase.readall_data_product();
    // print(_wholeDataList.length);
    //  print(_wholeDataList.length);
    // print(_wholeDataList.length);
    //  print("reset");
    // if (_wholeDataList.isNotEmpty) {
    //// ????
    _data_product(_wholeDataList, context);
    // } else {
    // }
    notifyListeners();
  }

  void _data_product(List<Map<String, dynamic>> dataList, context) {
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    data_products.clear_all_data();

    // data_products.add_data(data_product(index: "", id: "", name: "", price: "", picture: "", type: "", item: 0, unit: "", other: "", state: ""));
    for (Map<String, dynamic> data in dataList) {
      // print("add");
      // print(data['index_tra'] ?? '');
      // print("add");

      String index = data['index_tra'].toString();
      String id = data['id'] ?? '';
      String name = data['name'] ?? '';
      String price = data['price'] ?? '';
      String picture = data['picture'] ?? '';
      String type = data['type'] ?? '';
      int item = 1;
      String other = data['other'] ?? '';
      String unit = data['units'] ?? '';
      String state = data['state'] ?? '';

      String weight = data['weight'] ?? '';

      data_product GG = data_product(
          index: index,
          id: id,
          name: name,
          price: price,
          picture: picture,
          type: type,
          item: item,
          unit: unit,
          other: other,
          state: state,
          weight: weight);

      data_products.add_data(GG);
    }
    // data_products.clear_first();
  }

  int state_color = 0;
  int get_state_color() {
    return state_color;
  }

  void update_state_color(int data) {
    state_color = data;
    notifyListeners();
  }
}
