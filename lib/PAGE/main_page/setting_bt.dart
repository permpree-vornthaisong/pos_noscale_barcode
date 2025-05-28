import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:provider/provider.dart';

class setting_bt extends StatefulWidget {
  const setting_bt({super.key});

  @override
  State<setting_bt> createState() => _setting_btState();
}

class _setting_btState extends State<setting_bt> {
  @override
  Widget build(BuildContext context) {
    final page_state_provider page_states = Provider.of<page_state_provider>(context, listen: false);

    return InkWell(
      onTap: () {
        page_states.update_state(2);
      },
      child: Container(
        padding: EdgeInsets.all(1),
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Icon(
          Icons.settings_sharp,
          size: 30,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
