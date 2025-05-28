import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_product.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:provider/provider.dart';

class data_scanner_provider with ChangeNotifier {
  List<data_scanner> data_scanners = [data_scanner(data: "", money: "0.00", weight: "0.000")];

  List<data_scanner> get_all() {
    return data_scanners;
  }

  void update_data(String data, context) {
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);

    String result = data.substring(0, 6); //2-6

    String result2 = "";
    bool state = false;
    int index = 0;
    data_scanners[0].data = result;

    if (data[0] == "2" && data[1] == "0") {
      //  print("sdfsdf");
      //  result = data;
      for (int i = 0; i < data_products.get_all_nofilter().length; i++) {
        index = i;
        if (data_products.get_all_nofilter()[i].id == data_scanners[0].data) {
          state = true;
          index = i;
          break;
        } else {}
      }

      if (state) {
        //  print("object");
        if (data_products.get_all_nofilter()[index].unit == "KG") {
          // print("object2");

          //print("kg");
          result2 = (double.parse(data.substring(7, 12)) / 1000.00).toStringAsFixed(3); // 3 ตำแหน่ง

          // print("money");
          // print(result2);
          data_scanners[0].weight = result2;
          data_scanners[0].money = "0.00";
        } else {
          /// result2 = (double.parse(data.substring(7, 12)) / 100.00).toStringAsFixed(2);
          /// data_scanners[0].money = data_products.get_all_nofilter()[index].price;
          /// data_scanners[0].weight = "0.000";
        }
      }
    } else {
      ///  print("TTTT");
      data_scanners[0].data = data;
      //   print(data_scanners[0].data);

      for (int i = 0; i < data_products.get_all_nofilter().length; i++) {
        index = i;
        if (data_products.get_all_nofilter()[i].id == data_scanners[0].data) {
          state = true;
          index = i;
          break;
        } else {}
      }

      if (state) {
        //  if (data_products.get_all_nofilter()[index].unit == "KG") {
        ///   result2 = (double.parse(data.substring(7, 12)) / 1000.00).toStringAsFixed(3); // 3 ตำแหน่ง

        // print("money");
        // print(result2);
        ///   data_scanners[0].weight = result2;
        ///     data_scanners[0].money = "0.00";
        //} else {
        //// result2 = (double.parse(data.substring(7, 12)) / 100.00).toStringAsFixed(2);
        data_scanners[0].money = data_products.get_all_nofilter()[index].price;
        data_scanners[0].weight = "0.000";
        // }
      }
    }

    notifyListeners();
  }

  Future<void> reset() async {
    data_scanners[0].data = "";

    notifyListeners();
  }
}
