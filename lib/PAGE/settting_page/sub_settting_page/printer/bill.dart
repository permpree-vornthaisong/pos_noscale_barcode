import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/page_management.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/printer/function.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
//import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class edit_bill_widget extends StatefulWidget {
  const edit_bill_widget({super.key});

  @override
  State<edit_bill_widget> createState() => _edit_billState();
}

class _edit_billState extends State<edit_bill_widget> {
  // String _hintText = 'Enter your text here';

  TextEditingController _HEADS = TextEditingController();
  TextEditingController _NAMES = TextEditingController();
  TextEditingController _ADDRESSS = TextEditingController();
  TextEditingController _PHONSE = TextEditingController();
  TextEditingController _TAXS = TextEditingController();
  TextEditingController _SNS = TextEditingController();
  TextEditingController _ID_BILLS = TextEditingController();
  TextEditingController _CUSTOMERS = TextEditingController();
  TextEditingController _TEXT1S = TextEditingController();
  TextEditingController _TEXT2S = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final edit_billss = Provider.of<edit_bill_provider>(context, listen: false);

      _HEADS.text = edit_billss.get_all()[0].HEADS;
      _NAMES.text = edit_billss.get_all()[0].NAMES;
      _ADDRESSS.text = edit_billss.get_all()[0].ADDRESSS;

      _PHONSE.text = edit_billss.get_all()[0].PHONSE;

      _TAXS.text = edit_billss.get_all()[0].TAXS;
      _SNS.text = edit_billss.get_all()[0].SNS;
      _ID_BILLS.text = edit_billss.get_all()[0].ID_BILLS;
      _CUSTOMERS.text = edit_billss.get_all()[0].CUSTOMERS;
      _TEXT1S.text = edit_billss.get_all()[0].TEXT1S;
      _TEXT2S.text = edit_billss.get_all()[0].TEXT2S;

      // Your code to be executed after the delay
    });
  }

  @override
  Widget build(BuildContext context) {
    final systems = Provider.of<system_provider>(context, listen: false);

    return Container(
        height: 1500,
        child: /* Consumer<page_manage>(
        builder: (context, HH, child) {
          /*   _HEADS.text = edit_bills.get_all()[0].HEADS;
          _NAMES.text = edit_bills.get_all()[0].NAMES;
          _ADDRESSS.text = edit_bills.get_all()[0].ADDRESSS;

          _PHONSE.text = edit_bills.get_all()[0].PHONSE;

          _TAXS.text = edit_bills.get_all()[0].TAXS;
          _SNS.text = edit_bills.get_all()[0].SNS;
          _ID_BILLS.text = edit_bills.get_all()[0].ID_BILLS;
          _CUSTOMERS.text = edit_bills.get_all()[0].CUSTOMERS;
          _TEXT1S.text = edit_bills.get_all()[0].TEXT1S;
          _TEXT2S.text = edit_bills.get_all()[0].TEXT2S;*/

          // _controller3.text = edit_bills.get_all()[0].vat_num;

          return*/
            SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_bill : eng_text().printer_bill),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _HEADS,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /* decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].HEADS,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_HEAD(value);
                          });
                        },
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].head,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_head(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].head);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_name : eng_text().printer_name),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _NAMES,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /* decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].NAMES,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_NAME(value);
                          });
                        },
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].name,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_name(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].name);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////
              /*  Container(
                  margin: EdgeInsets.all(5),
                  height: 60,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 150,
                        child: Text(
                          (systems.get_all()[0].language == "thai" ? thai_text().printer_vat : eng_text().printer_vat),
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                              /* margin: EdgeInsets.all(5),
                        child: TextField(
                          controller: _controller3,
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                          decoration: InputDecoration(
                            hintText: edit_bills.get_all()[0].TAXS,
                          ),
                          onChanged: (value) {
                            setState(() {
                              // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                              edit_bills.update_state_TAX(value);
                            });
                          },
                        ),*/
                              )),
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 50,
                        height: 50,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Color.fromARGB(255, 0, 0, 0),
                          child: Center(
                            child: Checkbox(
                              checkColor: Colors.white,
                              //  fillColor: MaterialStateProperty.resolveWith(white),
                              value: edit_bills.get_all()[0].tax,
                              onChanged: (bool? value) {
                                setState(() {
                                  edit_bills.update_state_tax(!edit_bills.get_all()[0].tax);
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),*/
              ///////////////////////////////////////////////////////////////////////////////

              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_address : eng_text().printer_address),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _ADDRESSS,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /* decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].ADDRESSS,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_ADDRESSS(value);
                          });
                        },
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].address,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_address(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].address);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_phone : eng_text().printer_phone),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _PHONSE,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /* decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].PHONSE,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_PHONSE(value);
                          });
                        },
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].phone,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_phone(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].phone);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_vat : eng_text().printer_vat),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          /*   margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _TAXS,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /*decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].TAXS,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_TAX(value);
                          });
                        },
                      ),
                    )*/
                          ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].tax,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_tax(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].tax);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_sn : eng_text().printer_sn),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            /*  margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _SNS,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /*decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].SNS,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_SNS(value);
                          });
                        },
                      ),*/
                            )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].sn,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_sn(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].sn);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_id_bill : eng_text().printer_id_bill),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            /* margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _ID_BILLS,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /*  decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].ID_BILLS,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_ID_BILLS(value);
                          });
                        },
                      ),*/
                            )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].id_bill,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_id_bill(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].id_bill);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              /*Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_customer : eng_text().printer_customer),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _CUSTOMERS,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /*decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].CUSTOMERS,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_CUSTOMERS(value);
                          });
                        },
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].customer,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_customer(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].customer);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),*/
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_text1 : eng_text().printer_text1),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _TEXT1S,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /* decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].TEXT1S,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_TEXT1(value);
                          });
                        },
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].text1,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_text1(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].text1);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_text2 : eng_text().printer_text2),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                        controller: _TEXT2S,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                        /*   decoration: InputDecoration(
                            hintText: Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].TEXT2S,
                          ),*/
                        onChanged: (value) {
                          setState(() {
                            // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                            Provider.of<edit_bill_provider>(context, listen: false).update_state_TEXT2(value);
                          });
                        },
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].text2,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_text2(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].text2);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 120,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 150,
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().printer_picture : eng_text().printer_picture),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Image.memory(
                      base64Decode(Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].PICTURE),
                      fit: BoxFit.cover, // หรือกำหนดการแสดงผลตามต้องการ
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await image_logo_in(context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: 250,
                        height: 80,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Text(
                            "นำเข้า logo",
                            style: GoogleFonts.sarabun(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      /* child: TextField(
                          controller: _TEXT1S,
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                          decoration: InputDecoration(
                            hintText: edit_bills.get_all()[0].TEXT1S,
                          ),
                          onChanged: (value) {
                            setState(() {
                              // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                              edit_bills.update_state_TEXT1(value);
                            });
                          },
                        ),*/
                    )),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Checkbox(
                            checkColor: Colors.white,
                            //  fillColor: MaterialStateProperty.resolveWith(white),
                            value: Provider.of<edit_bill_provider>(context, listen: true).get_all()[0].pic,
                            onChanged: (bool? value) {
                              setState(() {
                                Provider.of<edit_bill_provider>(context, listen: false)
                                    .update_state_pic(!Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].pic);
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              /*  Container(
                  margin: EdgeInsets.all(5),
                  height: 60,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 80,
                        child: Text(
                          "ลูกค้า",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 50,
                        height: 50,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Color.fromARGB(255, 0, 0, 0),
                          child: Center(
                            child: Checkbox(
                              checkColor: Colors.white,
                              //  fillColor: MaterialStateProperty.resolveWith(white),
                              value: edit_bills.get_all()[0].customer,
                              onChanged: (bool? value) {
                                setState(() {
                                  edit_bills.update_state_customer(!edit_bills.get_all()[0].customer);
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),*/

              Container(
                height: 50,
              ),
              Container(
                  alignment: AlignmentDirectional.centerEnd,
                  // color: const Color.fromARGB(0, 255, 255, 255),
                  height: 65,
                  child: GestureDetector(
                    onTap: () async {
                      await _update_data_edite_bill();
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                      height: 55,
                      width: 120,
                      child: Center(
                        child: Text(
                          (systems.get_all()[0].language == "thai" ? thai_text().printer_save : eng_text().printer_save),
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        )

        ///  },
        /// ),
        );
  }

  Future<void> _update_data_edite_bill() async {
    final edit_bills = Provider.of<edit_bill_provider>(context, listen: false);

    final localDatabase = LocalDatabase();
    //         form: edit_bills.get_all()[0].form,

    await localDatabase.updatedata_edit_bill(
        form: edit_bills.get_all()[0].form,
        PICTURE: edit_bills.get_all()[0].PICTURE,
        pic: edit_bills.get_all()[0].pic,
        head: edit_bills.get_all()[0].head,
        name: edit_bills.get_all()[0].name,
        address: edit_bills.get_all()[0].address,
        phone: edit_bills.get_all()[0].phone,
        tax: edit_bills.get_all()[0].tax,
        sn: edit_bills.get_all()[0].sn,
        id_bill: edit_bills.get_all()[0].id_bill,
        customer: edit_bills.get_all()[0].customer,
        text1: edit_bills.get_all()[0].text1,
        text2: edit_bills.get_all()[0].text2,
        HEADS: edit_bills.get_all()[0].HEADS,
        NAMES: edit_bills.get_all()[0].NAMES,
        ADDRESSS: edit_bills.get_all()[0].ADDRESSS,
        PHONSE: edit_bills.get_all()[0].PHONSE,
        TAXS: edit_bills.get_all()[0].TAXS,
        SNS: edit_bills.get_all()[0].SNS,
        ID_BILLS: edit_bills.get_all()[0].ID_BILLS,
        CUSTOMERS: edit_bills.get_all()[0].CUSTOMERS,
        TEXT1S: edit_bills.get_all()[0].TEXT1S,
        TEXT2S: edit_bills.get_all()[0].TEXT2S);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกค่าสำเสร็จ '),
      ),
    );

    edit_bills.prepare_data(context);
  }
}
