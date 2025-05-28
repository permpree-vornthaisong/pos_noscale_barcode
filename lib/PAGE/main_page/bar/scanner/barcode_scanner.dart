import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_display.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_display_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_scanner_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:provider/provider.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  RawKeyEventDataAndroid? _keyEvent;
  bool state_scan = false;
  int state = 0;
  bool color_state_bar = false;
  bool state_timer = true;
  List<String> GG = [];
  Timer? timer;
  int count_timer = 0;
  String NUM = "";

  @override
  void initState() {
    super.initState();
    // Set focus to the searchController when the widget is first built
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final scanner_state_provider scanner_states = Provider.of<scanner_state_provider>(context, listen: false);
    // _focusNode.requestFocus();

    return GestureDetector(
      onDoubleTap: () {
        scanner_states.update_state(1);
      },
      onTap: () {
        // Request focus when tapped on the GestureDetector
        setState(() {
          color_state_bar = !color_state_bar;
        });
        _focusNode.requestFocus();
      },
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (RawKeyEvent event) {
          state_scan = true;
          if (state_timer) {
            TIME_DIV();
          }
          setState(() {
            _keyEvent = event.data as RawKeyEventDataAndroid;
          });
          if (_keyEvent != null) {
            if (state < 24) {
              GG.add(_keyEvent!.keyLabel);
              count_timer = 0;
              state++;
            } else if (state >= 24) {
              //  == 24
              state_scan = false;
            }
          }
        },
        child: Container(
          padding: EdgeInsets.all(5),
          color: Colors.black,
          child: Icon(
            Icons.barcode_reader,
            size: 30,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }

  Future<void> TIME_DIV() async {
    final data_scanners = Provider.of<data_scanner_provider>(context, listen: false);
    final data_products = Provider.of<data_product_provider>(context, listen: false);
    final data_display_provider data_displays = Provider.of<data_display_provider>(context, listen: false); //bill_provider
    final bills = Provider.of<bill_provider>(context, listen: false);
    final type_datas = Provider.of<type_data_provider>(context, listen: false);

    bool out_put_state = true;
    timer = Timer.periodic(Duration(milliseconds: 5), (Timer t) async {
      state_timer = false;
      count_timer++;
      if (!state_scan) {
        count_timer = 0;
        state_scan = true;
        //  print("start_scaner");
      }
      if (count_timer >= 100 && out_put_state) {
        out_put_state = false;
        if (GG.length != 0 && GG.length > 23) {
          //  print(GG);
          //  print(GG.length);
          //   print(result(GG));
          setState(() {
            NUM = result(GG);
            //   print(NUM);
          });

          data_scanners.update_data(NUM, context);
          data_products.info(context);
          // Your code to be executed after a 2-second delay
          if (data_products.get_all().length != 0) {
            data_display GG2 = data_display(
                index: data_products.get_all()[0].index ?? "",
                id: data_products.get_all()[0].id ?? "",
                name: data_products.get_all()[0].name ?? "",
                price: data_scanners.get_all()[0].money ?? "",
                type: data_products.get_all()[0].type ?? "",
                item: data_products.get_all()[0].item ?? 0,
                unit: data_products.get_all()[0].unit ?? "");
            //   print(GG);
            data_displays.update(GG2);
          }

          bills.add_data(data_displays.get_all()[0].price, data_displays.get_all()[0].id, context);

          data_scanners.reset();
          //  print("Delayed code executed after  s100onds");
          type_datas.update_filter("");
          data_products.info(context);
        }

        GG = [];

        state_timer = true;
        count_timer = 0;
        state = 0;

        t.cancel();
      }
    });
  }

  String result(List<String> DATA) {
    String DATA_OUT = "";
    DATA_OUT += DATA[0]; //1
    DATA_OUT += DATA[2]; //2
    DATA_OUT += DATA[4]; //3
    DATA_OUT += DATA[6]; //4
    DATA_OUT += DATA[8]; //5
    DATA_OUT += DATA[10]; //6
    DATA_OUT += DATA[12]; //7
    DATA_OUT += DATA[14]; //8
    DATA_OUT += DATA[16]; //9
    DATA_OUT += DATA[18]; //10
    DATA_OUT += DATA[20]; //11
    DATA_OUT += DATA[22]; //12
    //  DATA_OUT += DATA[24]; //13

    return DATA_OUT;
  }
}
