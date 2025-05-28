import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/setting_page.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class MainLockPage extends StatefulWidget {
  const MainLockPage({super.key});

  @override
  State<MainLockPage> createState() => _MainLockPageState();
}

class _MainLockPageState extends State<MainLockPage> {
  @override
  Widget build(BuildContext context) {
    final systems = Provider.of<system_provider>(context, listen: false);

    return Consumer<lock_page_provider>(builder: (context, lock_pages, child) {
      return Container(
        color: Dark_threme.BG_shadow,
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()), // Spacer at the top
            Container(
              child: Row(
                children: [
                  Expanded(flex: 1, child: Container()), // Spacer on the left
                  Container(
                    color: Dark_threme.BG,
                    width: 400,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.black38,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                "Lock Page",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white, // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                systems.get_all()[0].language == "thai" ? thai_text().page_setting_system : eng_text().page_setting_system,
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white, // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              )),
                              Transform.scale(
                                  scale: 1.8,
                                  child: Checkbox(
                                      value: lock_pages.get_data().p1,
                                      onChanged: (bool? value) {
                                        lock_pages.update_lock_page1(!lock_pages.get_data().p1);
                                      })),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                systems.get_all()[0].language == "thai" ? thai_text().page_setting_data_center : eng_text().page_setting_data_center,
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white, // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              )),
                              Transform.scale(
                                  scale: 1.8,
                                  child: Checkbox(
                                      value: lock_pages.get_data().p2,
                                      onChanged: (bool? value) {
                                        lock_pages.update_lock_page2(!lock_pages.get_data().p2);
                                      })),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                systems.get_all()[0].language == "thai" ? thai_text().page_setting_product : eng_text().page_setting_product,
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white, // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              )),
                              Transform.scale(
                                  scale: 1.8,
                                  child: Checkbox(
                                      value: lock_pages.get_data().p3,
                                      onChanged: (bool? value) {
                                        lock_pages.update_lock_page3(!lock_pages.get_data().p3);
                                      })),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                systems.get_all()[0].language == "thai" ? thai_text().page_setting_printer : eng_text().page_setting_printer,
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white, // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              )),
                              Transform.scale(
                                  scale: 1.8,
                                  child: Checkbox(
                                      value: lock_pages.get_data().p4,
                                      onChanged: (bool? value) {
                                        lock_pages.update_lock_page4(!lock_pages.get_data().p4);
                                      })),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                systems.get_all()[0].language == "thai" ? thai_text().page_setting_customer : eng_text().page_setting_customer,
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white, // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              )),
                              Transform.scale(
                                  scale: 1.8,
                                  child: Checkbox(
                                      value: lock_pages.get_data().p5,
                                      onChanged: (bool? value) {
                                        lock_pages.update_lock_page5(!lock_pages.get_data().p5);
                                      })),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                systems.get_all()[0].language == "thai" ? thai_text().page_setting_history : eng_text().page_setting_history,
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white, // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              )),
                              Transform.scale(
                                  scale: 1.8,
                                  child: Checkbox(
                                      value: lock_pages.get_data().p6,
                                      onChanged: (bool? value) {
                                        lock_pages.update_lock_page6(!lock_pages.get_data().p6);
                                      })),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: Container()), // Spacer on the left
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(children: [
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      final page_states = Provider.of<page_state_provider>(context, listen: false);

                      page_states.update_state(2);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      color: Colors.black,
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
                ),
                Expanded(flex: 10, child: Container()),
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      _save_lock_page(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      color: Colors.black,
                      width: 160,
                      height: 80,
                      child: Center(
                        child: Text(
                          "save",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white, // Text color
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 12, child: Container()),
              ]),
            ),
          ],
        ),
      );
    });
  }

  void _save_lock_page(context) {
    final lock_pages = Provider.of<lock_page_provider>(context, listen: false);

    lock_pages.save_data();

    // final systems = Provider.of<system_provider>(context, listen: false);
  }
}
