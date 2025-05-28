import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/Stock.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class stock_provider with ChangeNotifier {
  List<Stock> data = [
    //Stock(unix: unix, data_time: data_time, units: units, type: type, id: id, state: state, who: who, num: num, other: other)
  ];
  String display_type_data = "";
  String display_id_data = "";
  String display_units_data = "";
  List<String> type_data = [];
  List<String> id_data = [];
  String get_display_type() {
    return display_type_data;
  }

  String get_display_id() {
    return display_id_data;
  }

  String get_display_units() {
    return display_units_data;
  }

  update_display_type(String data) {
    display_type_data = data;
    notifyListeners();
  }

  update_display_id(String data) {
    display_id_data = data;
    notifyListeners();
  }

  update_display_units(String data) {
    display_units_data = data;
    notifyListeners();
  }

  List<Stock> get_data() {
    return data;
  }

  void add_data(Stock DATA) {
    data.add(DATA);
    notifyListeners();
  }

  void clear_all() {
    data.clear();
    notifyListeners();
  }

  List<String> get_data_type() {
    return type_data;
  }

  List<String> get_data_id() {
    return id_data;
  }

  Future<void> reset_data(context) async {
    final time_search_stock_provider time_search_stocks = Provider.of<time_search_stock_provider>(context, listen: false);

    List<Map<String, dynamic>> _data_db = [];
    clear_all();
    final localDatabase = LocalDatabase();
    _data_db = await localDatabase.readStockByTimeRange(
        time_search_stocks.get_start_time(), time_search_stocks.get_end_time()); // getSum_Stock_ByIdAndName //readall_Stock

    _data_db = await localDatabase.read_stock_data_by_input(
        time_search_stocks.get_start_time(),
        time_search_stocks.get_end_time(), //
        display_id_data, //
        display_type_data, //
        display_units_data); //
    /*
    index_tra INTEGER PRIMARY KEY AUTOINCREMENT,
    unix INTEGER NOT NULL,
    date_time TEXT NOT NULL,
    units TEXT NOT NULL,
    type TEXT NOT NULL,
    id TEXT NOT NULL,
    name TEXT NOT NULL,
    state TEXT NOT NULL,
    who TEXT NOT NULL,
    num REAL NOT NULL,
    other TEXT NOT NULL
  
  
  
  */

    //  print(_data_db);

    for (Map<String, dynamic> dada in _data_db) {
      int unix = dada['unix'] ?? '';
      String data_time = dada['date_time'] ?? '';
      String units = dada['units'] ?? '';
      String type = dada['type'] ?? '';
      String id = dada['id'] ?? '';
      String state = dada['state'] ?? '';
      String name = dada['name'] ?? '';

      String who = dada['who'] ?? '';
      double num = dada['num'] ?? 0;
      String other = dada['other'] ?? '';

      Stock DATA =
          Stock(unix: unix, data_time: data_time, units: units, name: name, type: type, id: id, state: state, who: who, num: num, other: other);

      data.add(DATA);
    }
    data.sort((a, b) => (b.unix).compareTo((a.unix)));
    notifyListeners();
  }

  Future<void> reset_type_data() async {
    List<Map<String, dynamic>> _data_db = [];

    final localDatabase = LocalDatabase();

    _data_db = await localDatabase.getSum_Stock_ByIdAndName(); // getSum_Stock_ByIdAndName //readall_Stock
    type_data.add("ทั้งหมด");

    type_data += _data_db.map((data) => data['type'] as String).toList();

    notifyListeners();
  }

  Future<void> reset_id_data() async {
    List<Map<String, dynamic>> _data_db = [];

    final localDatabase = LocalDatabase();

    _data_db = await localDatabase.getSum_Stock_ByIdAndName(); // getSum_Stock_ByIdAndName //readall_Stock
    id_data.add("ทั้งหมด");

    id_data += _data_db.map((data) => data['id'] as String).toList();
    notifyListeners();
  }

  Future<void> delect_all() async {
    final localDatabase = LocalDatabase();

    await localDatabase.delete_all_stock();
    notifyListeners();
  }
}

class stock_display_provider with ChangeNotifier {
  List<display_stock> data = [];
  List<String> type_data = [];
  List<String> id_data = [];

  String display_type_data = "";
  String display_num_data = "";

  String get_num_data() {
    return display_num_data;
  }

  void update_num_data(String DATA) {
    display_num_data = DATA;
    notifyListeners();
  }

  String get_display_type() {
    return display_type_data;
  }

  void update_display_type(String DATA) {
    display_type_data = DATA;
    notifyListeners();
  }

  List<String> get_data_type() {
    return type_data;
  }

  List<String> get_id_type() {
    return id_data;
  }

  List<display_stock> get_data() {
    List<display_stock> _data_type = display_type_data == "ทั้งหมด"
        ? data
        : data.where((stock) {
            return stock.type.toLowerCase().contains(display_type_data.toLowerCase());
          }).toList();

    List<display_stock> _data_num = _data_type.where((stock) {
      return stock.id.toLowerCase().contains(display_num_data.toLowerCase());
    }).toList();

    return _data_num;
  }

  void add_data(display_stock DATA) {
    data.add(DATA);
    notifyListeners();
  }

  void clear_all() {
    data.clear();
    notifyListeners();
  }

  Future<void> reset_data() async {
    List<Map<String, dynamic>> _data_db = [];
    clear_all();
    final localDatabase = LocalDatabase();

    _data_db = await localDatabase.getSum_Stock_ByIdAndName(); // getSum_Stock_ByIdAndName //readall_Stock
    // print(_data_db);
    for (Map<String, dynamic> dada in _data_db) {
      String id = dada['id'] ?? '';
      String name = dada['name'] ?? '';
      String units = dada['units'] ?? '';
      String type = dada['type'] ?? '';
      double sum = 0;

      if (units == "KG") {
        double sums = dada['sum'] ?? 0.0; // Ensure 'sum' is not null
        String formattedSum = sums.toStringAsFixed(3); // Format to 3 decimal places)
        sum = double.parse(formattedSum);
      } else if (units == "p") {
        double sums = dada['sum'] ?? 0.0; // Ensure 'sum' is not null
        String formattedSum = sums.toStringAsFixed(0); // Format to 3 decimal places)
        sum = double.parse(formattedSum);
      }

      display_stock DATA = display_stock(id: id, units: units, type: type, name: name, sum: sum);

      data.add(DATA);
    }

    data.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

    notifyListeners();
  }

  Future<void> update_data(
      String units, String id, String type, String name, String state, String who, String other, double data_new, context) async {
    final time_search_his_provider time_search_hiss = Provider.of<time_search_his_provider>(context, listen: false);

    final localDatabase = LocalDatabase();

    localDatabase.add_Stock(
        unix: time_search_hiss.getUnixNow(),
        date_time: time_search_hiss.getFormattedTimeNow(),
        units: units,
        id: id,
        type: type,
        name: name,
        state: state,
        who: who,
        num: data_new,
        other: other);

    //localDatabase.update_stock_NumById(id, data_new);
    await reset_data();

    await reset_type_data();
  }

  Future<void> reset_type_data() async {
    List<Map<String, dynamic>> _data_db = [];

    final localDatabase = LocalDatabase();

    _data_db = await localDatabase.getSum_Stock_ByIdAndName(); // getSum_Stock_ByIdAndName //readall_Stock
    type_data = _data_db.map((data) => data['type'] as String).toList();
    type_data.add("ทั้งหมด");
    notifyListeners();
  }

  Future<void> reset_id_data() async {
    List<Map<String, dynamic>> _data_db = [];

    final localDatabase = LocalDatabase();

    _data_db = await localDatabase.getSum_Stock_ByIdAndName(); // getSum_Stock_ByIdAndName //readall_Stock
    type_data = _data_db.map((data) => data['id'] as String).toList();
    id_data.add("ทั้งหมด");
    notifyListeners();
  }
}
