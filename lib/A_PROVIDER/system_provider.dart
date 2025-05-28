import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/system.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class system_provider with ChangeNotifier {
  List<System> Systems = [
    System(
        activate: false,
        SN: "123456000",
        language: "thai",
        vat: "7",
        vat_num: "111111111",
        discount_mode: false,
        vat_mode: false,
        format_input: "1",
        printter: "internal", //external
        low_cash_allow: "0.100",
        drawer_manual: true,
        login_mode: false,
        weight_mode: false,
        number_prompt_pay: "0123456789",
        cashier: "-", ////
        role: "-")
  ];

  List<System> get_all() {
    return Systems;
  }

  void add_data(System data) {
    Systems.add(data);
    notifyListeners();
  }

  void clear_all() {
    Systems.clear();
    notifyListeners();
  }

  void update_activate_mode(bool data) {
    Systems[0].activate = data;
    notifyListeners();
  }

  void update_discoount_mode(bool data) {
    Systems[0].discount_mode = data;
    notifyListeners();
  }

  void update_login_mode(bool data) {
    Systems[0].login_mode = data;
    notifyListeners();
  }

  void update_weight_mode(bool data) {
    Systems[0].weight_mode = data;
    notifyListeners();
  }

  void update_vat_mode(bool data) {
    Systems[0].vat_mode = data;
    notifyListeners();
  }

  void update_drawer_manual(bool data) {
    Systems[0].drawer_manual = data;
    notifyListeners();
  }

  void update_low_cash_allow(String data) {
    Systems[0].low_cash_allow = data;
    notifyListeners();
  }

  void update_Vat(String data) {
    Systems[0].vat = data;
    notifyListeners();
  }

  void update_Vat_num(String data) {
    Systems[0].vat_num = data;
    notifyListeners();
  }

  void update_printter(String data) {
    Systems[0].printter = data;
    notifyListeners();
  }

  void update_format_input(String data) {
    Systems[0].format_input = data;
    notifyListeners();
  }

  void update_SN(String data) {
    Systems[0].SN = data;
    notifyListeners();
  }

  void update_number_qr(String data) {
    Systems[0].number_prompt_pay = data;
    print(Systems[0].number_prompt_pay);

    notifyListeners();
  }

  void update_cashier(String data) {
    Systems[0].cashier = data;
    notifyListeners();
  }

  void update_role(String data) {
    Systems[0].role = data;
    notifyListeners();
  }

  void update_language(String data) {
    Systems[0].language = data;
    notifyListeners();
  }

  Future<void> prepare_data(context) async {
    final localDatabase = LocalDatabase();
    List<Map<String, dynamic>> _wholeDataList = [];
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    _wholeDataList = await localDatabase.readall_systems();
    if (_wholeDataList.length == 0) {
      String CASHIER = "-";
      String ROLE = "-";
      if (systems.get_all()[0].login_mode) {
        CASHIER = systems.get_all()[0].cashier;
        ROLE = systems.get_all()[0].role;
      }

      print(systems.get_all()[0].number_prompt_pay);
      await localDatabase.adddata_systems(
        activate: systems.get_all()[0].activate,
        discount_mode: systems.get_all()[0].discount_mode,
        vat_mode: systems.get_all()[0].vat_mode,
        login_mode: systems.get_all()[0].login_mode,
        SN: systems.get_all()[0].SN,
        number_prompt_pay: systems.get_all()[0].number_prompt_pay,
        cashier: CASHIER,
        role: ROLE,
        language: systems.get_all()[0].language,
        vat: systems.get_all()[0].vat,
        vat_num: systems.get_all()[0].vat_num,
        format_input: systems.get_all()[0].format_input,
        printter: systems.get_all()[0].printter,
        weight_mode: systems.get_all()[0].weight_mode,
        low_cash_allow: systems.get_all()[0].low_cash_allow,
        drawer_manual: systems.get_all()[0].drawer_manual,
      );
    } else {
      _data_product(_wholeDataList, context);
    }
  }

  void _data_product(List<Map<String, dynamic>> dataList, context) {
    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    systems.clear_all();
    for (Map<String, dynamic> data in dataList) {
      bool activate = data['activate'] == 1;
      bool discount_mode = data['discount_mode'] == 1;
      bool login_mode = data['login_mode'] == 1;
      bool vat_mode = data['vat_mode'] == 1;
      bool weight_mode = data['weight_mode'] == 1;
      bool drawer_manual = data['drawer_manual'] == 1;

      String vat = data['vat'] ?? '';
      String vat_num = data['vat_num'] ?? '';
      String format_input = data['format_input'] ?? '';
      String printter = data['printter'];
      String SN = data['SN'] ?? '';
      String number_prompt_pay = data['number_prompt_pay'] ?? '';
      String cashier = "";
      String role = "";
      print(number_prompt_pay);

      if (login_mode == true) {
        cashier = data['cashier'] ?? '';
        role = data['role'] ?? '';
      } else if (login_mode == false) {
        cashier = '-';
        role = '-';
      }
      /* cashier = data['cashier'] ?? '';
      role = data['role'] ?? '';*/
      String low_cash_allow = data['low_cash_allow'] ?? '';

      String language = data['language'] ?? '';
      // print(login_mode);

      // print(cashier);
      //  print(role);

      System GG = System(
          activate: activate,
          vat: vat,
          vat_num: vat_num,
          discount_mode: discount_mode,
          login_mode: login_mode,
          SN: SN,
          vat_mode: vat_mode,
          number_prompt_pay: number_prompt_pay,
          cashier: cashier,
          role: role,
          language: language,
          format_input: format_input,
          printter: printter,
          weight_mode: weight_mode,
          drawer_manual: drawer_manual,
          low_cash_allow: low_cash_allow);
      systems.add_data(GG);
    }
  }
}
