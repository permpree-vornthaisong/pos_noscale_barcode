import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/bar/scanner/barcode_scanner.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/bar/scanner/key_board.dart';
import 'package:provider/provider.dart';

class key_scanner extends StatefulWidget {
  const key_scanner({super.key});

  @override
  State<key_scanner> createState() => _key_scannerState();
}

class _key_scannerState extends State<key_scanner> {
  @override
  Widget build(BuildContext context) {
    List<Widget> page = [
      BarcodeScanner(),
      Key_board(),
    ];
    return Container(
      child: Consumer<scanner_state_provider>(
        builder: (context, scanner_states, child) {
          int selectedTabIndex = scanner_states.get_all()[0].state;

          return page[selectedTabIndex];
        },
      ),
    );
  }
}
