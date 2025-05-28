import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/his_bill_provider.dart';
import 'package:provider/provider.dart';

class sumhisbill extends StatefulWidget {
  const sumhisbill({super.key});

  @override
  State<sumhisbill> createState() => _sumhisbillState();
}

class _sumhisbillState extends State<sumhisbill> {
  @override
  Widget build(BuildContext context) {
    return Consumer<his_bill_provider>(
      builder: (context, his_bills, child) {
        double SUM_MONEY_NET = 0.00;
        int SUM_LIST = 0;

        if (his_bills.get_all().isNotEmpty) {
          // SUM_LIST = his_bills.get_all().length;
          for (int i = 0; i < his_bills.get_all().length; i++) {
            String DATA = his_bills.get_all()[i].state;
            List<String> parts = DATA.split('/');
            if (parts[1] == "yes") {
              SUM_LIST++;
              SUM_MONEY_NET = SUM_MONEY_NET + double.parse(his_bills.get_all()[i].sum_money);
            }
          }
        }

        return Container(
          height: 200,
          //  color: Colors.amber,
          child: Container(
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      "สรุปรายการ",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      SUM_LIST.toString(),
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      "สรุปรายรับ",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(5),
                  height: 20,
                  child: Center(
                    child: Text(
                      SUM_MONEY_NET.toStringAsFixed(2),
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
