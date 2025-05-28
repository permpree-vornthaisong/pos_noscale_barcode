import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:provider/provider.dart';

class customer_name extends StatefulWidget {
  const customer_name({super.key});

  @override
  State<customer_name> createState() => _customer_nameState();
}

class _customer_nameState extends State<customer_name> {
  @override
  Widget build(BuildContext context) {
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    return Container(
      child: Consumer<customer_provider>(
        builder: (context, customers, child) {
          return Container(
            color: Colors.white,
            margin: EdgeInsets.all(1),
            child: Container(
              child: Center(
                  child: Text(
                (systems.get_all()[0].language == "thai" ? thai_text().tab_name : "") + customers.get_display_name(),
                style: GoogleFonts.sarabun(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.normal,
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}
