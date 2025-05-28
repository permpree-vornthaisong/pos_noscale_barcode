import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/his_bill_provider.dart';
import 'package:provider/provider.dart';

void his_reset_index_bill(context) {
  final his_bills = Provider.of<his_bill_provider>(context, listen: false);

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: 100,
            width: 200,
            color: Colors.white,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  await his_bills.reset_time_bill(context);
                  Navigator.pop(context); // Close the dialog
                  //              Navigator.pop(context); // Close the dialog
                },
                child: Container(
                    height: 60,
                    width: 160,
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text(
                        "ยืนยัน",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 0, 0, 0), // Text color
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    )),
              ),
            ),
          ),
        );
      });
}

void his_delect_bill(context) {
  final his_bills = Provider.of<his_bill_provider>(context, listen: false);

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: 100,
            width: 200,
            color: Colors.white,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  await his_bills.delect_time_bill(context);
                  Navigator.pop(context); // Close the dialog
                  //              Navigator.pop(context); // Close the dialog
                },
                child: Container(
                    height: 60,
                    width: 160,
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text(
                        "ยืนยัน",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 0, 0, 0), // Text color
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    )),
              ),
            ),
          ),
        );
      });
}
