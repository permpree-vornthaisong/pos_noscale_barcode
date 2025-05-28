import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/display_data/display_data.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/display_data/key_display.dart';
import 'package:provider/provider.dart';

class manage_display_data extends StatefulWidget {
  const manage_display_data({super.key});

  @override
  State<manage_display_data> createState() => _manage_display_dataState();
}

class _manage_display_dataState extends State<manage_display_data> {
  @override
  Widget build(BuildContext context) {
    List<Widget> page = [display_data(), key_display()];
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
