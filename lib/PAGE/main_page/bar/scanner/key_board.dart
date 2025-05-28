import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_display_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_scanner_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/bar/scanner/function.dart';
import 'package:provider/provider.dart';

class Key_board extends StatefulWidget {
  const Key_board({super.key});

  @override
  State<Key_board> createState() => _key_boardState();
}

class _key_boardState extends State<Key_board> {
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
  Widget build(BuildContext context) {
    final scanner_state_provider scanner_states = Provider.of<scanner_state_provider>(context, listen: false);
    final data_scanners = Provider.of<data_scanner_provider>(context, listen: false);
    final data_products = Provider.of<data_product_provider>(context, listen: false);
    final data_displays = Provider.of<data_display_provider>(context, listen: false);

    //  _focusNode.requestFocus();

    return GestureDetector(
      onDoubleTap: () {
        scanner_states.update_state(0);
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
          if (event is RawKeyDownEvent) {
            // Handle key down event
            //  print("Physical key: ${event.physicalKey.debugName}");
            //  print("Key down: ${event.logicalKey}");

            // print("Key down: ${event.logicalKey.keyLabel.toString()}");

            // print("Character: ${event.character.toString()}");
            if (data_displays.get_all()[0].price != "0.00") {
              data_displays.update_money("0.00");
            }
            test(event.character.toString(), event.logicalKey.keyLabel.toString(), context);
          }
        },
        child: Container(
          padding: EdgeInsets.all(5),
          color: Colors.black,
          child: Icon(
            Icons.keyboard_hide_outlined,
            size: 30,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
