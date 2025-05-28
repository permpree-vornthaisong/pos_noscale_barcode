import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_noscale_barcode/A_MODEL/his_bill.dart';
import 'package:pos_noscale_barcode/A_MODEL/system.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class his_bill_provider with ChangeNotifier {
  List<his_bill> his_bills = [
    /*  his_bill(
        sn: sn,
        id_bill: id_bill,
        cahier: cahier,
        date_time: data_time,
        tax: tax,
        sum_money: sum_money,
        pay_money: pay_money,
        money_back: money_back,
        method_pay: method_pay,
        sum_list: sum_list,
        sum_detial_list: sum_detial_list,
        state: state,
        detial: detial)*/
  ];

  List<his_bill> get_all() {
    return his_bills;
  }

  Future<void> getdata(context) async {
    final localDatabase = LocalDatabase();
    List<Map<String, dynamic>> _bill_list = [];

    final time_search_his_provider time_search_hiss = Provider.of<time_search_his_provider>(context, listen: false);

    final his_bill_provider time_searchs = Provider.of<his_bill_provider>(context, listen: false);

    _bill_list = await localDatabase.readall_bill_time(

        /// info
        DateTime(
          time_search_hiss.get_all()[0].Y,
          time_search_hiss.get_all()[0].M,
          time_search_hiss.get_all()[0].D,
          time_search_hiss.get_all()[0].h,
          time_search_hiss.get_all()[0].m,
          time_search_hiss.get_all()[0].s,
          // 2024,
          // 1,
          // 1,
        ),
        DateTime(
          time_search_hiss.get_all()[1].Y,
          time_search_hiss.get_all()[1].M,
          time_search_hiss.get_all()[1].D,
          time_search_hiss.get_all()[1].h,
          time_search_hiss.get_all()[1].m,
          time_search_hiss.get_all()[1].s,
        ));

    print(_bill_list.length);

    //_bill_list = await localDatabase.readall_head_bill();
    await time_searchs.read_his_bill(_bill_list, context);

    notifyListeners();
  }

  void sortAscending() {
    his_bills.sort((a, b) => int.parse(a.id_bill).compareTo(int.parse(b.id_bill)));
    notifyListeners();
  }

  // ฟังก์ชันเรียงลำดับจากมากไปน้อย
  void sortDescending() {
    his_bills.sort((a, b) => int.parse(b.id_bill).compareTo(int.parse(a.id_bill)));
    notifyListeners();
  }

  void clear_all() {
    his_bills.clear();
    //  print("CLEAR SUCCESS");

    notifyListeners();
  }

  Future<void> add_data(his_bill data) async {
    his_bills.add(data);
    //  print("ADD SUCCESS");
    notifyListeners();
  }

  Future<void> save_bills(context) async {
    final localDatabase = LocalDatabase();
    int INDEX = await localDatabase.readall_index_bill(); //readall_index_bill  //getColumnCount
    String INDEXString = (INDEX).toString().padLeft(5, '0');

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    // print('Current date and time: $formattedDate');
    final bill_provider bills = Provider.of<bill_provider>(context, listen: false);

    final edit_bill_provider edit_bills = Provider.of<edit_bill_provider>(context, listen: false);
    final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    String T_list = bills.get_all().length.toString();
    int item_all = 0;
    double sum_money = 0.00;
    double sum_money_t = 0.00;
    double vat = 0.00;
    double sum_money_before_vat = 0.00;
    double discount = 0.00;

    double pay_back = 0.00;
    double pay_money = 0.00;

    double sum_weight = 0.00;

    if (bills.get_all().isNotEmpty) {
      for (int i = 0; i < bills.get_all().length; i++) {
        item_all = item_all + bills.get_all()[i].item;
        sum_weight = sum_weight + double.parse(bills.get_all()[i].weight);
        if (bills.get_all()[i].unit == "KG") {
          sum_money = sum_money + double.parse(bills.get_all()[i].price) * double.parse(bills.get_all()[i].weight);
        } else {
          sum_money = sum_money + double.parse(bills.get_all()[i].price) * bills.get_all()[i].item;
        }

        sum_money_t = sum_money; ////****** */
      }
      if (systems.get_all()[0].discount_mode) {
        discount = (sum_money * customers.get_discount_form_type(customers.get_display_type()) / 100);
      }

      sum_money_before_vat = sum_money - discount;

      if (systems.get_all()[0].vat_mode) {
        vat = (sum_money_before_vat * double.parse(systems.get_all()[0].vat) / 100);
      }
      //sum_money_before_vat
      sum_money = sum_money_before_vat + vat;
      // print(sum_money);
      // print(item_all);

      //  print(item_all);
      //  print(sum_money);
    }
    pay_money = double.parse(bills.Pay_money());
    pay_back = double.parse(bills.Pay_money()) - sum_money;

    if (bills.Qrcode_state()) {
      pay_back = 0.00;
      pay_money = sum_money;
    }

    List<Map<String, dynamic>> detailList = [];

    for (int i = 0; i < bills.get_all().length; i++) {
      Map<String, dynamic> detailMap = {
        'id': bills.get_all()[i].id, 
        'name': bills.get_all()[i].name,
        'item': bills.get_all()[i].item, //int
        'price': bills.get_all()[i].price,
        'price_all': bills.get_all()[i].unit == "KG"
            ? (double.parse(bills.get_all()[i].weight) * double.parse(bills.get_all()[i].price)).toStringAsFixed(2)
            : (double.parse(bills.get_all()[i].price) * bills.get_all()[i].item).toStringAsFixed(2),
        'type': bills.get_all()[i].type,

        'weight': bills.get_all()[i].weight,
        'units': bills.get_all()[i].unit,
      };

      detailList.add(detailMap);
      print(detailMap);
    }
/*
    his_bill GG = his_bill(
        sn: systems.get_all()[0].SN,
        id_bill: INDEXString,
        cahier: systems.get_all()[0].cashier,
        date_time: formattedDate,
        tax_id: edit_bills.get_all()[0].TAXS,
        tax_money: vat.toStringAsFixed(2),
        sum_money_before_tax: sum_money_before_vat.toStringAsFixed(2),
        sum_money: sum_money.toStringAsFixed(2),
        pay_money: pay_money.toStringAsFixed(2),
        money_back: pay_back.toStringAsFixed(2),
        method_pay: bills.Qrcode_state() ? "Qr-code/000000000" : "rought",
        sum_list: bills.get_all().length.toString(),
        sum_detial_list: item_all.toString(),
        state: systems.get_all()[0].vat_mode ? "offline/yes/vat" : "offline/yes/no-vat", //vat
        detial: detailList);
    print(GG);*/

    print(customers.get_display_id());
    print(customers.get_display_type());

    await localDatabase.adddata_his_bill(
      sn: systems.get_all()[0].SN,
      id_bill: INDEXString,
      cahier: systems.get_all()[0].cashier,
      date_time: formattedDate,

      tax_id: edit_bills.get_all()[0].TAXS ?? '',
      tax_money: vat.toStringAsFixed(2) ?? '',
      customer: customers.get_display_id() ?? '',
      type_customer: customers.get_display_type(),
      discount_customer: (customers.get_discount_form_type(customers.get_display_type()) / 100).toStringAsFixed(2),
      sum_money_t: sum_money_t.toStringAsFixed(2),
      discount: discount.toStringAsFixed(2),
      sum_money_before_tax: sum_money_before_vat.toStringAsFixed(2),
      sum_money: sum_money.toStringAsFixed(2),
      pay_money: pay_money.toStringAsFixed(2),
      money_back: pay_back.toStringAsFixed(2),

      method_pay: bills.Qrcode_state() ? "Qr-code/${systems.get_all()[0].number_prompt_pay}" : "rought",
      sum_list: bills.get_all().length.toString(),
      sum_detial_list: item_all.toString(),
      sum_weight: sum_weight.toStringAsFixed(3),
      state: systems.get_all()[0].vat_mode ? "offline/yes/vat" : "offline/yes/no-vat", //vat
      detial: jsonEncode(detailList),
    );
  }

  Future<void> read_his_bill(List<Map<String, dynamic>> dataList, context) async {
    final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false); //data_scanner_provider
    his_bills.clear_all();

    for (Map<String, dynamic> data in dataList) {
      int id_tra = data['id_tra'] ?? '';
      String sn = data['sn'] ?? '';
      String id_bill = data['id_bill'] ?? '';
      String cahier = data['cahier'] ?? '';
      String date_time = data['date_time'] ?? '';
      String tax_id = data['tax_id'] ?? '';
      String tax_money = data['tax_money'] ?? '';

      String customer = data['customer'] ?? '';
      String type_customer = data['type_customer'] ?? '';
      String discount_customer = data['discount_customer'] ?? '';
      String sum_money_t = data['sum_money_t'] ?? '';
      String discount = data['discount'] ?? '';

      String sum_money_before_tax = data['sum_money_before_tax'] ?? '';
      String sum_money = data['sum_money'] ?? '';
      String pay_money = data['pay_money'] ?? '';
      String money_back = data['money_back'] ?? '';
      String method_pay = data['method_pay'] ?? '';
      String sum_list = data['sum_list'] ?? '';
      String sum_detial_list = data['sum_detial_list'] ?? '';
      String sum_weight = data['sum_weight'] ?? '';

      String state = data['state'] ?? '';
      String detial = data['detial'] ?? '';

      List<Map<String, dynamic>> decodedDetailList = (jsonDecode(detial) as List).cast<Map<String, dynamic>>();
//print("decodedDetailList");
      //  print(decodedDetailList);

      his_bill GG = his_bill(
          INDEX: id_tra,
          sn: sn,
          id_bill: id_bill,
          cahier: cahier,
          date_time: date_time,
          tax_id: tax_id,
          tax_money: tax_money,
          customer: customer,
          type_customer: type_customer,
          discount_customer: discount_customer,
          sum_money_t: sum_money_t,
          discount: discount,
          sum_money_before_tax: sum_money_before_tax,
          sum_money: sum_money,
          pay_money: pay_money,
          money_back: money_back,
          method_pay: method_pay,
          sum_list: sum_list,
          sum_detial_list: sum_detial_list,
          sum_weight: sum_weight,
          state: state,
          detial: decodedDetailList);

      his_bills.add_data(GG);

      /*   print("------------------------------");

      print(id_tra);
      print(sn);
      print(id_bill); //
      print(cahier); //
      print(date_time); //
      print(tax_id); //
      print(tax_money); //tax_money
      print(sum_weight); //sum_weight

      print(customer); //รหัสลูกค้า
      print(type_customer); //กลุ่มลูกค้า
      print(sum_money_t); //เงินก่อนลด
      print(discount); // ส่วนลด
      print(discount_customer); //% ลด

      print(sum_money_before_tax); // เงินก่อน vat
      print(sum_money); //// เงินสุทธิ
      print(pay_money); //รับมา
      print(method_pay); //วิธีการจ่าย
      print(pay_money); //ทอน
      print(sum_list); //จำนวนรายการ
      print(sum_detial_list); //จำนวนสินค้า
      print(state); //สถานะ
      print(detial);
      print("------------------------------");*/
    }
  }

  Future<void> state_no(int index, context) async {
    final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false); //data_scanner_provider
    final localDatabase = LocalDatabase();

    String DATA = his_bills.get_all()[index].state;
    List<String> parts = DATA.split('/');
    if (parts[1] == "yes") {
      await localDatabase.updatedata_state_his_bill(index: his_bills.get_all()[index].INDEX, state: parts[0] + "/" + "no" + "/" + parts[2]);
    } else if (parts[1] == "no") {
      await localDatabase.updatedata_state_his_bill(index: his_bills.get_all()[index].INDEX, state: parts[0] + "/" + "yes" + "/" + parts[2]);
    }
  }

  Future<void> reset_time_bill(context) async {
    final localDatabase = LocalDatabase();

    await localDatabase.updatedata_index_bill(INDEXS: 0);
  }

  Future<void> delect_time_bill(context) async {
    List<Map<String, dynamic>> _bill_list = [];

    final localDatabase = LocalDatabase();
    final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false);
    final time_search_his_provider time_search_hiss = Provider.of<time_search_his_provider>(context, listen: false);

    await localDatabase.deleteBillByTimeRange(

        /// info
        DateTime(
          time_search_hiss.get_all()[0].Y,
          time_search_hiss.get_all()[0].M,
          time_search_hiss.get_all()[0].D,
          time_search_hiss.get_all()[0].h,
          time_search_hiss.get_all()[0].m,
          time_search_hiss.get_all()[0].s,
          // 2024,
          // 1,
          // 1,
        ),
        DateTime(
          time_search_hiss.get_all()[1].Y,
          time_search_hiss.get_all()[1].M,
          time_search_hiss.get_all()[1].D,
          time_search_hiss.get_all()[1].h,
          time_search_hiss.get_all()[1].m,
          time_search_hiss.get_all()[1].s,
        ));

    await getdata(context);
    // await localDatabase.deleteBillByTimeRange(timeA, timeB)
  }
}
