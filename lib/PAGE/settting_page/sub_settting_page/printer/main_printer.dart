import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/printer/bill.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/printer/example_bill.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class MyDraggableWidget extends StatefulWidget {
  @override
  _MyDraggableWidgetState createState() => _MyDraggableWidgetState();
}

class _MyDraggableWidgetState extends State<MyDraggableWidget> {
  String draggableData = 'Drag me!';

  @override
  Widget build(BuildContext context) {
    final page_states = Provider.of<page_state_provider>(context, listen: false);
    final systems = Provider.of<system_provider>(context, listen: false);

    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 16,
            child: Container(
              color: Dark_threme.BG_shadow,
              child: Consumer2<edit_bill_provider, system_provider>(
                builder: (context, edit_bills, systems, child) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            edit_bills.update_state_form("1");
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: edit_bills.get_all()[0].form == "1" ? Colors.amberAccent : Colors.white),
                            child: Center(
                              child: Text(
                                (systems.get_all()[0].language == "thai" ? thai_text().printer_form1 : eng_text().printer_form1),
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        /*   GestureDetector(
                          onTap: () {
                            edit_bills.update_state_form("2");
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: edit_bills.get_all()[0].form == "2" ? Colors.amberAccent : Colors.white),
                            child: Center(
                              child: Text(
                                (systems.get_all()[0].language == "thai" ? thai_text().printer_form2 : eng_text().printer_form2),
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),*/
                        Expanded(child: Container()),
                        Container(
                          child: InkWell(
                            onTap: () {
                              page_states.update_state(2);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 80,
                              height: 80,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                          // Expanded(child: Container()),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
              flex: 100,
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                        flex: 30,
                        child: Container(
                          color: Dark_threme.BG,
                          child: edit_bill_widget(),
                        )),
                    //Expanded(flex: 30, child: Container(color: const Color.fromARGB(255, 138, 138, 138), child: example_bill())),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
