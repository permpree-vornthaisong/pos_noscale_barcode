import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/bar/scanner/manage_key_scan.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/customer/customer_type.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/customer/customer_name.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class customer_search extends StatefulWidget {
  const customer_search({super.key});

  @override
  State<customer_search> createState() => _customer_searchState();
}

class _customer_searchState extends State<customer_search> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final customer_provider customers = Provider.of<customer_provider>(context, listen: false);

      customers.update_display_type(""); //customers.get_discount_customer()[0].type
      customers.update_display_name("----");
      customers.update_display_id("----");
      customers.update_display_type("----");

      //customers.update_display_id(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    return Container(
      height: 50,
      color: Colors.black38,
      child: Container(
        margin: EdgeInsets.fromLTRB(1, 5, 1, 5),
        child: Container(
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await _select_customer(context);
                },
                child: Container(
                  width: 180,
                  color: Dark_threme.BG,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(2),
                      color: Colors.black,
                      child: Center(
                          child: Text(
                        systems.get_all()[0].language == "thai" ? thai_text().tab_customer : eng_text().tab_customer,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontStyle: FontStyle.normal,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
              Expanded(child: customer_name()),
              Expanded(
                  child: Container(
                margin: EdgeInsets.fromLTRB(1, 1, 1, 1),
                color: Colors.white,
                child: customer_type(),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _select_customer(context) async {
    final TextEditingController _textController4 = TextEditingController();
    final customer_provider customers = Provider.of<customer_provider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            height: 200,
            width: 500,
            child: Column(children: [
              TextField(
                controller: _textController4,
                keyboardType: TextInputType.number,
                style: GoogleFonts.sarabun(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.normal,
                ),
                decoration: InputDecoration(
                  hintText: "รหัสลูกค้า",
                ),
                onChanged: (value) {
                  _textController4.text = value;
                  setState(() {
                    // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                  });
                },
              ),
              Container(
                height: 50,
              ),
              GestureDetector(
                onTap: () async {
                  customers.get_customer_display_name(_textController4.text);

                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Center(
                    child: Container(
                      width: 160,
                      height: 50,
                      child: Center(
                          child: Text(
                        "ยืนยัน",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      )),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.greenAccent),
                    ),
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
