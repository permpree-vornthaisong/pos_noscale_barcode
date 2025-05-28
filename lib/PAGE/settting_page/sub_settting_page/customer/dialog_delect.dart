import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

Future<void> delect_all_customer(context) async {
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
            height: 300,
            width: 400,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: 400,
                        child: Center(
                          child: Container(
                            child: Text(
                              "การลบข้อมูลไ่มสามารถกู้คืนได้",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                    Container(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await localDatabase.delete_all_customer();
                        await customers.resset_customer(context);

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ลบลูกค้า สำเร็จ'),
                          ),
                        );
                        /* Future.delayed(Duration(seconds: 1), () {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ลบลูกค้า สำเร็จ'),
                            ),
                          );
                        });*/
                      },
                      child: Container(
                        width: 150,
                        height: 80,
                        color: Colors.redAccent,
                        child: Container(
                          child: Center(
                            child: Text(
                              "ยืนยัน",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 150,
                        height: 80,
                        color: Colors.amber,
                        child: Container(
                          child: Center(
                            child: Text(
                              "ยกเลิก",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );
    },
  );
}

Future<void> delect_all_discount_customer(context) async {
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
            height: 300,
            width: 400,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: 400,
                        child: Center(
                          child: Container(
                            child: Text(
                              "การลบข้อมูลไ่มสามารถกู้คืนได้",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                    Container(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await localDatabase.delete_all_discount_customer();
                        await customers.resset_discount_customer(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ลบกลุ่มลูกค้า สำเร็จ'),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 80,
                        color: Colors.redAccent,
                        child: Container(
                          child: Container(
                            child: Center(
                              child: Text(
                                "ยืนยัน",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      width: 150,
                      height: 80,
                      color: Colors.amber,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "ยกเลิก",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );
    },
  );
}

Future<void> delect_customer(context, index) async {
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
            height: 300,
            width: 400,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: 400,
                        child: Center(
                          child: Container(
                            child: Text(
                              "การลบข้อมูลไ่มสามารถกู้คืนได้",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                    Container(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await localDatabase.delete_customer(customers.get_customer()[index].id);
                        await customers.resset_customer(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ลบลูกค้า สำเร็จ'),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 80,
                        color: Colors.redAccent,
                        child: GestureDetector(
                          child: Container(
                            child: Center(
                              child: Text(
                                "ยืนยัน",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      width: 150,
                      height: 80,
                      color: Colors.amber,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "ยกเลิก",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );
    },
  );
}

Future<void> delect_discount_customer(context, index) async {
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
            height: 300,
            width: 400,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: 400,
                        child: Center(
                          child: Container(
                            child: Text(
                              "การลบข้อมูลไ่มสามารถกู้คืนได้",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                    Container(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await localDatabase.delete_discount_customer(customers.get_discount_customer()[index].type);
                        await customers.resset_discount_customer(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ลบกลุ่มลูกค้า สำเร็จ'),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 80,
                        color: Colors.redAccent,
                        child: Container(
                          child: Container(
                            child: Center(
                              child: Text(
                                "ยืนยัน",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      width: 150,
                      height: 80,
                      color: Colors.amber,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "ยกเลิก",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );
    },
  );
}

Future<void> update_discount_customer(BuildContext context, int index) async {
  final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
  final localDatabase = LocalDatabase();

  final TextEditingController discountController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          height: 300,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "เปลี่ยนส่วนลดของ " + customers.get_discount_customer()[index].type,
                style: GoogleFonts.sarabun(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "จาก " + customers.get_discount_customer()[index].discount.toStringAsFixed(2) + "%",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final double discount = double.parse(discountController.text);
                  final String type = customers.get_discount_customer()[index].type; // Replace with actual logic to get type

                  await localDatabase.update_discount_customer_ByType(type: type, discount: discount);
                  await customers.resset_discount_customer(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('เปลี่ยนแปลงข้อมูลสำเร็จ'),
                    ),
                  );
                },
                child: Container(
                  color: Colors.greenAccent,
                  height: 60,
                  width: 160,
                  child: Center(
                    child: Text(
                      "ยืนยัน",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
