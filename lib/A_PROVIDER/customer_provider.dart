import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/customer.dart';
import 'package:pos_noscale_barcode/A_MODEL/threme_state.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class customer_provider with ChangeNotifier {
  List<customer> customers = [
    customer(INDEX: "", name: "-", id: "000000", type: "ธรรมดา"),
    // customer(INDEX: "", name: "-", id: "000000", type: "ประจำ"),
  ];
  List<discount_customer> discount_customers = [discount_customer(type: "ธรรมดา", discount: 0.00)];

  //, discount_customer(type: "ประจำ", discount: 5.00)
  List<discount_customer> display_discount_customers = [];
  List<customer> customer_filter = []; // data filter
  List<customer> customer_display_filter = []; // data filter

  String filtter_data = ""; //  filter

  String display_type = "";

  String display_name = "";
  String display_id = "";

  String get_data_filter() {
    return filtter_data;
  }

  List<customer> get_customer() {
    return customers;
  }

  List<discount_customer> get_discount_customer() {
    return discount_customers;
  }

  String get_display_id() {
    return display_id;
  }

  String get_display_type() {
    return display_type;
  }

  String get_display_name() {
    return display_name;
  }

//////////////////////////////////////////
  Future<void> update_display_name(String data) async {
    display_name = data;
    notifyListeners();
  }

  Future<void> update_display_id(String data) async {
    display_id = data;
    notifyListeners();
  }

  Future<void> update_display_type(String data) async {
    display_type = data;
    notifyListeners();
  }

////////////////////////////////////////////////////////
  double get_discount_form_type(String DATA) {
    display_discount_customers = discount_customers.where((data) => data.type.toLowerCase().contains(DATA.toLowerCase())).toList();
    if (display_discount_customers.length == 0) {
      return 0.00;
    } else {
      return display_discount_customers[0].discount;
    }
  }

  Future<void> get_customer_display_name(String filter) async {
    // แสดง data ที่โดน filter
    customer_display_filter = customers.where((data) => data.id.toLowerCase().contains(filter.toLowerCase())).toList();

    display_name = customer_display_filter.isNotEmpty && customer_display_filter[0].name != null ? customer_display_filter[0].name : "------";
    display_type = customer_display_filter.isNotEmpty && customer_display_filter[0].type != null ? customer_display_filter[0].type : "------";
    display_id = customer_display_filter.isNotEmpty && customer_display_filter[0].id != null ? customer_display_filter[0].id : "------";

    notifyListeners();
  }

  List<customer> get_customer_filtter() {
    // แสดง data ที่โดน filter
    customer_filter = customers.where((data) => data.type.toLowerCase().contains(filtter_data.toLowerCase())).toList();
    //  print(customer_filter.length);
    //  notifyListeners();
    return customer_filter;
  }

  Future<void> resset_discount_customer(context) async {
    final localDatabase = LocalDatabase();
    List<Map<String, dynamic>> _wholeDataList = [];

    _wholeDataList = await localDatabase.readall_discount_customer();
    /* if (_wholeDataList.length == 0) {
      customers = [
        customer(INDEX: "", name: "-", id: "000000", type: "ธรรมดา"),
        // customer(INDEX: "", name: "-", id: "000000", type: "ประจำ"),
      ];
    }*/
    // print(_wholeDataList.length);
    // print(_wholeDataList.length);
    // print(_wholeDataList.length);
    // print("reset");
    // if (_wholeDataList.isNotEmpty) {
    //// ????
    _discount_customer_data(_wholeDataList, context);
    // }
    notifyListeners();
  }

  Future<void> resset_customer(context) async {
    final localDatabase = LocalDatabase();
    List<Map<String, dynamic>> _wholeDataList = [];

    _wholeDataList = await localDatabase.readall_customer();
    /*if (_wholeDataList.length == 0) {
      discount_customers = [discount_customer(type: "ธรรมดา", discount: 0.00)];
    }*/
    // print(_wholeDataList.length);
    // print(_wholeDataList.length);
    //  print(_wholeDataList.length);
    // print("reset");
    // if (_wholeDataList.isNotEmpty) {
    //// ????
    _customer_data(_wholeDataList, context);
    //}
    notifyListeners();
  }

///////////////////////////////////////////////////////
  void _discount_customer_data(List<Map<String, dynamic>> dataList, context) {
    final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
    customers.clear_discount_customer_all();
    for (Map<String, dynamic> data in dataList) {
      // print("add");
      String index = data['index_tra'].toString();

      String type = data['type'] ?? '';
      double discount = data['discount'] ?? 0.00;

      discount_customer DATA = discount_customer(type: type, discount: discount);
      customers.add_discount_customer(DATA);
    }
    notifyListeners();
  }

  void _customer_data(List<Map<String, dynamic>> dataList, context) {
    final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
    customers.clear_customer_all();
    for (Map<String, dynamic> data in dataList) {
      // print("add");
      String index = data['index_tra'].toString();
      String id = data['id'] ?? '';
      String name = data['name'] ?? '';
      String type = data['type'] ?? '';

      customer DATA = customer(INDEX: index, name: name, id: id, type: type);
      customers.add_customer(DATA);
    }
    notifyListeners();
  }

  void update_filter_data(String data) {
    // อัปเดท data ของ filter
    // print(data);
    filtter_data = data;
    notifyListeners();
  }

  Future<void> add_customer(customer data) async {
    customers.add(data);
    notifyListeners();
  }

  Future<void> add_discount_customer(discount_customer data) async {
    discount_customers.add(data);
    notifyListeners();
  }

  Future<void> update_customer(customer data, int index) async {
    // print(data);
    customers[index] = data;

    notifyListeners();
  }

  Future<void> update_discount_customer(discount_customer data, int index) async {
    //  print(data);
    discount_customers[index] = data;

    notifyListeners();
  }

  Future<void> clear_customer_all() async {
    customers.clear();
    notifyListeners();
  }

  Future<void> clear_discount_customer_all() async {
    discount_customers.clear();
    notifyListeners();
  }
}
