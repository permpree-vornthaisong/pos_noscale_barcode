import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/activate/function.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/system/add_staff.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/system/delect_staff.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/system/function.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/system/list_staff.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class main_system extends StatefulWidget {
  const main_system({super.key});

  @override
  State<main_system> createState() => _main_systemState();
}

class _main_systemState extends State<main_system> {
  TextEditingController _vat = TextEditingController();
  TextEditingController _vat_num = TextEditingController();

  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

  TextEditingController _low_cash = TextEditingController();

  List<String> _options = ['0', '1', '2', '3', 'jhs'];
  List<String> _printter = ["internal", "external"];

  String _selectedValue = "";
  @override
  Widget build(BuildContext context) {
    final page_states = Provider.of<page_state_provider>(context, listen: false);
    final systems = Provider.of<system_provider>(context, listen: false);

    return Container(
      color: Dark_threme.BG,
      child: Row(
        children: [
          Expanded(
              flex: 16,
              child: Container(
                color: Dark_threme.BG_shadow,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      child: Column(children: [
                        Container(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final localDatabase = LocalDatabase();

                            // final activate_provider activates = Provider.of<activate_provider>(context, listen: false);
                            final system_provider systems = Provider.of<system_provider>(context, listen: false);
                            //  final page_state_provider page_states = Provider.of<page_state_provider>(context, listen: false);

                            await localDatabase.updatedata_state_systems(
                              activate: true,
                              discount_mode: systems.get_all()[0].discount_mode,
                              vat_mode: systems.get_all()[0].vat_mode,
                              login_mode: systems.get_all()[0].login_mode,
                              SN: systems.get_all()[0].SN,
                              number_prompt_pay: systems.get_all()[0].number_prompt_pay,
                              cashier: systems.get_all()[0].cashier,
                              role: systems.get_all()[0].role,
                              language: systems.get_all()[0].language,
                              vat: systems.get_all()[0].vat,
                              vat_num: systems.get_all()[0].vat_num,
                              format_input: systems.get_all()[0].format_input,
                              printter: systems.get_all()[0].printter,
                              weight_mode: systems.get_all()[0].weight_mode,
                              low_cash_allow: systems.get_all()[0].low_cash_allow,
                              drawer_manual: systems.get_all()[0].drawer_manual,
                            );

                            await systems.prepare_data(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('บันทึกสำเสร็จ'),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                            child: Center(
                              child: Text(
                                (systems.get_all()[0].language == "thai" ? thai_text().system_save : eng_text().system_save),
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
                        ),
                        Expanded(child: Container())
                      ]),
                    )),
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
          Expanded(flex: 10, child: Container()),
          Expanded(
              flex: 100,
              child: Container(
                  child: Container(
                height: 2000,
                child: Consumer<system_provider>(
                  builder: (context, systems, child) {
                    /*   _controller.text = edit_bills.get_all()[0].HEADS;*/
                    _controller2.text = systems.get_all()[0].SN;

                    _controller3.text = systems.get_all()[0].number_prompt_pay;

                    _controller4.text = systems.get_all()[0].cashier;

                    _low_cash.text = systems.get_all()[0].low_cash_allow;

                    _vat.text = systems.get_all()[0].vat.toString();
                    _vat_num.text = systems.get_all()[0].vat_num.toString();

                    _selectedValue = systems.get_all()[0].format_input; // Default selected value

                    return SingleChildScrollView(
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
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_login_mode : eng_text().system_login_mode),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                        value: systems.get_all()[0].login_mode,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            systems.update_login_mode(!systems.get_all()[0].login_mode);
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
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_vat_mode : eng_text().system_vat_mode),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                        value: systems.get_all()[0].vat_mode,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            systems.update_vat_mode(!systems.get_all()[0].vat_mode);
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
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_discount_mode : eng_text().system_discount_mode),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                        value: systems.get_all()[0].discount_mode,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            systems.update_discoount_mode(!systems.get_all()[0].discount_mode);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //////////////////////////////////////////////////////////
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_THAI : eng_text().system_THAI),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                        value: systems.get_all()[0].language == "thai",
                                        onChanged: (bool? value) {
                                          systems.update_language("thai");
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
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_ENG : eng_text().system_ENG),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                        value: systems.get_all()[0].language == "ENG",
                                        onChanged: (bool? value) {
                                          systems.update_language("ENG");
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          ///////////////////////////////////////////////////////////////////////////////
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_prompt_pay : eng_text().system_prompt_pay),
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
                                    controller: _controller3,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "",
                                    ),
                                    onChanged: (value) {
                                      /* setState(() {
                                        _controller3.text = value;
                                      });*/
                                      // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                                      systems.update_number_qr(value);
                                      // print(value);
                                    },
                                  ),
                                )),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 50,
                                  height: 50,
                                  /*child: Container(
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
                                  ),*/
                                )
                              ],
                            ),
                          ),
                          ///////////////////////////////////////////////////////////////////////
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_vat : eng_text().system_vat),
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
                                    controller: _vat,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: systems.get_all()[0].vat.toString(),
                                    ),
                                    //  keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                                      systems.update_Vat(value);
                                    },
                                  ),
                                )),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 50,
                                  height: 50,
                                  /*child: Container(
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
                                  ),*/
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
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_num_vat : eng_text().system_num_vat),
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
                                    controller: _vat_num,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: systems.get_all()[0].vat_num.toString(),
                                    ),
                                    //  keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                                      systems.update_Vat_num(value);
                                    },
                                  ),
                                )),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 50,
                                  height: 50,
                                  /*child: Container(
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
                                  ),*/
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
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_format : eng_text().system_format),
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
                                  child: DropdownButton<String>(
                                    value: systems.get_all()[0].format_input,
                                    items: _options.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      systems.update_format_input(newValue!);
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
                                        value: systems.get_all()[0].weight_mode,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            systems.update_weight_mode(!systems.get_all()[0].weight_mode);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container())
                              ],
                            ),
                          ),
                          ///////////////////////////////////////////////////////////////////////////////
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_printter : eng_text().system_printter),
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
                                  child: DropdownButton<String>(
                                    value: systems.get_all()[0].printter,
                                    items: _printter.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      systems.update_printter(newValue!);
                                    },
                                  ),
                                )),
                                /* Container(
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
                                        value: systems.get_all()[0].weight_mode,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            systems.update_weight_mode(!systems.get_all()[0].weight_mode);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),*/
                                Expanded(child: Container())
                              ],
                            ),
                          ),
                          ///////////////////////////////////////////////////////////////////////////////
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_lowest_weight : eng_text().system_lowest_weight),
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
                                    controller: _low_cash,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                                      systems.update_low_cash_allow(value);
                                    },
                                  ),
                                )),
                                /* Container(
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
                                        value: systems.get_all()[0].weight_mode,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            systems.update_weight_mode(!systems.get_all()[0].weight_mode);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),*/
                                Expanded(child: Container())
                              ],
                            ),
                          ),
                          ///////////////////////////////////////////////////////////////////////////////
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_drawer : eng_text().system_drawer),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                        value: systems.get_all()[0].drawer_manual,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            systems.update_drawer_manual(!systems.get_all()[0].drawer_manual);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container())
                              ],
                            ),
                          ),

                          ////////////////////////////////////////////////
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_SN : eng_text().system_SN),
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
                                    controller: _controller2,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: systems.get_all()[0].SN,
                                    ),
                                    onChanged: (value) {
                                      // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                                      systems.update_SN(value);
                                    },
                                  ),
                                )),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 50,
                                  height: 50,
                                  /*child: Container(
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
                                  ),*/
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
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_cashier : eng_text().system_cashier),
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
                                  child: Text(
                                    systems.get_all()[0].cashier,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                )),
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
                                  width: 200,
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_cashier_role : eng_text().system_cashier_role),
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
                                  child: Text(
                                    systems.get_all()[0].role,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pick_cashier(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 80,
                              color: Color.fromARGB(255, 255, 255, 255),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: const Color.fromARGB(255, 19, 56, 87),
                                  child: Text(
                                    (systems.get_all()[0].language == "thai" ? thai_text().system_cashier_input : eng_text().system_cashier_input),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                          ),
                          Visibility(visible: systems.get_all()[0].role != "staff" && systems.get_all()[0].login_mode, child: AddStaff()),
                          Visibility(visible: systems.get_all()[0].role != "staff" && systems.get_all()[0].login_mode, child: delect_staff()),
                          Visibility(visible: systems.get_all()[0].role != "staff" && systems.get_all()[0].login_mode, child: list_staff()),

                          // Expanded(child: Container()),
                          Container(
                            height: 100,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ))),
          Expanded(flex: 50, child: Container())
        ],
      ),
    );
  }
}
