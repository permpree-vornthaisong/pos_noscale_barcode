import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

Future<void> add_customer_function(context) async {
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController3 = TextEditingController();
  final localDatabase = LocalDatabase();

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
            height: 400,
            width: 300,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _textController1,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "รหัส",
                      ),
                    ),
                    TextField(
                      controller: _textController2,
                      // keyboardType: TextInputType.number,
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "ชื่อ",
                      ),
                    ),
                    TextField(
                      controller: _textController3,
                      // keyboardType: TextInputType.number,
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "กลุ่มลูกค้า",
                      ),
                    ),
                    Container(
                      height: 50,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (_textController1.text != "" && _textController2.text != "" && _textController3.text != "") {
                            await localDatabase.adddata_customer(
                                id: _textController1.text, name: _textController2.text, type: _textController3.text, context: context);
                            await customers.resset_customer(context);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('เพิ่มข้อมูลลูกค้าสำเสร็จ'),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.greenAccent),
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
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      );
    },
  );
}

Future<void> add_discount_customer_function(context) async {
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
  final localDatabase = LocalDatabase();

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
            height: 400,
            width: 300,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _textController1,
                      // keyboardType: TextInputType.number,
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "กลุ่มลูกค้า",
                      ),
                    ),
                    TextField(
                      controller: _textController2,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "ส่วนลด",
                      ),
                    ),
                    Container(
                      height: 50,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (_textController1.text != "" && _textController2.text != "") {
                            await localDatabase.adddata_discount_customer(type: _textController1.text, discount: double.parse(_textController2.text));
                            await customers.resset_discount_customer(context);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('เพิ่มข้อมูลกลุ่มลูกค้าสำเสร็จ'),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.greenAccent),
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
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      );
    },
  );
}

Future<void> delect_all_discount_cfustomer(context) async {
  final customer_provider customers = Provider.of<customer_provider>(context, listen: false);

  final localDatabase = LocalDatabase();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog();
      });
}
