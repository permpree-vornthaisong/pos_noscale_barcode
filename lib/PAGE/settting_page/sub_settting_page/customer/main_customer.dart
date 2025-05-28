import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/system.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/customer.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/dialog_add.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/dialog_delect.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/excell_out.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/function.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/tab_type.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/type_customer.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class main_customer extends StatefulWidget {
  const main_customer({super.key});

  @override
  State<main_customer> createState() => _main_customerState();
}

class _main_customerState extends State<main_customer> {
  @override
  Widget build(BuildContext context) {
    final page_states = Provider.of<page_state_provider>(context, listen: false);
    final systems = Provider.of<system_provider>(context, listen: false);

    return Row(
      children: [
        Expanded(
            flex: 16,
            child: Container(
              color: Dark_threme.BG_shadow,
              child: Column(
                children: [
                  Expanded(child: tab_type_customer()),
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
            )),
        Expanded(
            flex: 100,
            child: Container(
              color: Dark_threme.BG,
              child: Column(
                children: [
                  Container(
                    height: 20,
                  ),
                  Expanded(
                      flex: 12,
                      child: Container(
                        color: Dark_threme.BG,
                        child: Row(children: [
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () async {
                                  await add_discount_customer_function(context);
                                },
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  child: Center(
                                      child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().customer_add_type : eng_text().customer_add_type),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await add_customer_function(context);
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().customer_add_cus : eng_text().customer_add_cus),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await delect_all_customer(context);
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().customer_clear_cus : eng_text().customer_clear_cus),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await delect_all_discount_customer(context);
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 160,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().customer_clear_type : eng_text().customer_clear_type),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final file_pickers = Provider.of<file_picker_excell_customer>(context, listen: false);
                              file_pickers.pickExcelFile(context);
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().customer_input : eng_text().customer_input),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              EXCEL_discount(context);
                              EXCEL_customer(context);
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().customer_output : eng_text().customer_output),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          //  buttom(),
                        ]),
                      )),
                  Expanded(
                      flex: 80,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 245,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: customer_detail(),
                              ),
                            ),
                            Container(
                                width: 5,
                                child: Container(
                                  color: Colors.black,
                                )),
                            Expanded(
                              flex: 220,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: type_customer(),
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            )),
      ],
    );
  }
}
