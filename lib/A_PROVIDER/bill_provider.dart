import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_product.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Scale_provider/main_scale_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_scanner_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/function/functiom_display.dart';
import 'package:provider/provider.dart';

class bill_provider with ChangeNotifier {
  List<data_product> bills = [];

  List<data_product> get_all() {
    return bills;
  }

  bool money_state = false;
  bool qrcode_state = false;

  bool Money_state() {
    return money_state;
  }

  bool Qrcode_state() {
    return qrcode_state;
  }

  Future<void> update_bill_price(int index, String data) async {
    bills[index].price = data;
    notifyListeners();
  }

  Future<void> update_Money_state(bool data) async {
    money_state = data;
    notifyListeners();
  }

  Future<void> update_Qrcode_state(bool data) async {
    qrcode_state = data;
    notifyListeners();
  }

  String pay_money = "0.00";

  String Pay_money() {
    return pay_money;
  }

  Future<void> update_pay_money(String data) async {
    pay_money = data;
    notifyListeners();
  }

  void removeDataAtIndex(int index) {
    if (index >= 0 && index < bills.length) {
      bills.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> removeDataAll() async {
    bills = []; //    bills.clear();

    notifyListeners();
  }

  Future<void> save_bills(context) async {} //kgp  kg  p

  Future<void> add_data(String money, String id, context) async {
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false); //data_scanner_provider
    final data_scanner_provider data_scanners = Provider.of<data_scanner_provider>(context, listen: false); //data_scanner_provider
    // final ScaleProvider Scales = Provider.of<ScaleProvider>(context, listen: false); //data_scanner_provider

    for (int i = 0; i < data_products.get_all().length; i++) {
      if (data_products.get_all()[i].id == id) {
        if (data_products.get_all()[i].unit == "KG") {
          bills.add(data_product(
              index: data_products.get_all()[i].index,
              id: data_products.get_all()[i].id,
              name: data_products.get_all()[i].name,
              price: data_products.get_all()[0].price,
              picture: "",
              type: data_products.get_all()[i].type,
              item: 1,
              unit: data_products.get_all()[i].unit,
              state: data_products.get_all()[i].state,
              other: data_products.get_all()[i].other,
              weight: data_scanners.get_all()[0].weight));
              
        } else if (data_products.get_all()[i].unit == "p") {
          //  print("p");
          bool state_p = false;
          for (int j = 0; j < bills.length; j++) {
            if (data_products.get_all()[i].id == bills[j].id) {
              bills[j].item++;
              // bills[j].price = (double.parse(bills[j].price) + double.parse(data_products.get_all()[i].price)).toString();
              state_p = true;
              break;
            } else {}
          }
          if (state_p) {
          } else {
            bills.add(data_product(
                index: data_products.get_all()[i].index,
                id: data_products.get_all()[i].id,
                name: data_products.get_all()[i].name,
                price: data_products.get_all()[i].price,
                picture: "",
                type: data_products.get_all()[i].type,
                item: 1,
                unit: data_products.get_all()[i].unit,
                state: data_products.get_all()[i].state,
                other: data_products.get_all()[i].other,
                weight: "0"));
          }
        }
      } else {}
    }

    notifyListeners();
  }

  Future<void> add_data_pick_up(String id, context) async {
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false); //data_scanner_provider
    final system_provider systems = Provider.of<system_provider>(context, listen: false); //data_scanner_provider
    final ScaleProvider Scales = Provider.of<ScaleProvider>(context, listen: false); //data_scanner_provider

    for (int i = 0; i < data_products.get_all().length; i++) {
      if (data_products.get_all()[i].id == id) {
        if (data_products.get_all()[i].unit == "KG") {
          if (systems.get_all()[0].weight_mode) {
            /*  print(data_products.get_all()[i].type);
            print(Scales.get_data());*/
            if (Scales.get_stable() && double.tryParse(Scales.get_data()) != null) {
              double check_scale = double.parse(Scales.get_data());
              double chexk_low_allow = double.parse(systems.get_all()[0].low_cash_allow);
              if (check_scale >= chexk_low_allow) {
                bills.add(data_product(
                    index: data_products.get_all()[i].index,
                    id: data_products.get_all()[i].id,
                    name: data_products.get_all()[i].name,
                    price: data_products.get_all()[i].price,
                    picture: "",
                    type: data_products.get_all()[i].type,
                    item: 1,
                    unit: data_products.get_all()[i].unit,
                    state: data_products.get_all()[i].state,
                    other: data_products.get_all()[i].other,
                    weight: Scales.get_data()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('low weight'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            }
          }
        } else if (data_products.get_all()[i].unit == "p") {
          //  print("p");
          bool state_p = false;
          for (int j = 0; j < bills.length; j++) {
            if (data_products.get_all()[i].id == bills[j].id) {
              bills[j].item++;
              // bills[j].price = (double.parse(bills[j].price) + double.parse(data_products.get_all()[i].price)).toString();
              state_p = true;
              break;
            } else {}
          }
          if (state_p) {
          } else {
            bills.add(data_product(
                index: data_products.get_all()[i].index,
                id: data_products.get_all()[i].id,
                name: data_products.get_all()[i].name,
                price: data_products.get_all()[i].price,
                picture: "",
                type: data_products.get_all()[i].type,
                item: 1,
                unit: data_products.get_all()[i].unit,
                state: data_products.get_all()[i].state,
                other: data_products.get_all()[i].other,
                weight: "0"));
          }
        }
      } else {}
    }

    notifyListeners();
  }

  void inof() {}
}
