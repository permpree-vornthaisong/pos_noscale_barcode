import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/system.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/bar/scanner/key_board.dart';
import 'package:provider/provider.dart';

void dialog_head_stock(BuildContext context, int index) {
  final stockDisplays = Provider.of<stock_display_provider>(context, listen: false);
  final stocks = Provider.of<stock_provider>(context, listen: false);

  // สร้าง TextEditingController หากต้องการใช้กับ TextField
  final TextEditingController textController1 = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  textController1.text = "0";
  textController2.text = "0";

  double SUM = (stockDisplays.get_data()[index].sum + double.parse(textController1.text) ?? 0) - (double.parse(textController2.text) ?? 0);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Container(
            height: 400,
            width: 400,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 15), // เพิ่มระยะห่างด้านบน

                // เพิ่ม Text ตามที่คุณต้องการ
                Text(
                  'เปลี่ยนแปลง stock',
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                ),

                SizedBox(height: 20), // เพิ่มระยะห่างระหว่าง Text และ TextField
                Text(
                  'เดิม ' + stockDisplays.get_data()[index].sum.toString() + "  " + stockDisplays.get_data()[index].units,
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 10), // เพิ่มระยะห่างระหว่าง Text และ TextField

                // เพิ่ม TextField
                Row(children: [
                  Expanded(
                      child: Container(
                    child: Center(
                      child: Text(
                        "ลด",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: textController2,
                        /* decoration: InputDecoration(
                          labelText: 'เพิ่ม',
                          border: OutlineInputBorder(),
                        ),*/
                        onChanged: (value) {
                          SUM = stockDisplays.get_data()[index].sum + double.parse(textController1.text) - double.parse(textController2.text);
                        },
                        keyboardType: TextInputType.number, // กำหนดแป้นพิมพ์เป็นตัวเลข
                      ),
                    ),
                  ),
                  Expanded(child: Container())
                ]),
                SizedBox(height: 10), // เพิ่มระยะห่างระหว่าง TextField และ Container

                Row(children: [
                  Expanded(
                      child: Container(
                    child: Center(
                      child: Text(
                        "เพิ่ม",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: textController1,
                        /*  decoration: InputDecoration(
                          labelText: 'ค่าใหม่',
                          border: OutlineInputBorder(),
                        ),*/
                        onChanged: (value) {
                          SUM = stockDisplays.get_data()[index].sum + double.parse(textController1.text) - double.parse(textController2.text);
                        },
                        keyboardType: TextInputType.number, // กำหนดแป้นพิมพ์เป็นตัวเลข
                      ),
                    ),
                  ),
                  Expanded(child: Container())
                ]),
                SizedBox(height: 15), // เพิ่มระยะห่างระหว่าง TextField และ Container

                Text(
                  " จาก " + stockDisplays.get_data()[index].sum.toString() + "  >>>>>  " + " เป็น " + SUM.toString(),
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 15), // เพิ่มระยะห่างระหว่าง TextField และ Container

                // เพิ่ม Container
                Row(children: [
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      // stockDisplays.update_data(stockDisplays.get_data()[index].id, SUM);

                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 60,
                      width: 100,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          'ยกเลิก',
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      final Systems = Provider.of<system_provider>(context, listen: false);
                      double DATA = double.parse(textController1.text) - double.parse(textController2.text);

                      stockDisplays.update_data(
                          stockDisplays.get_data()[index].units,
                          stockDisplays.get_data()[index].id,
                          stockDisplays.get_data()[index].type,
                          stockDisplays.get_data()[index].name,
                          "staff/" + (DATA > 0 ? "increase" : "decrease"),
                          Systems.get_all()[0].cashier,
                          "-",
                          DATA,
                          context);
                      stocks.reset_data(context);
                      // stockDisplays.reset_data();

                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 60,
                      width: 100,
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          'ยืนยัน',
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ]),

                // SizedBox(height: 20), // เพิ่มระยะห่างด้านล่าง

                // ปุ่มเพื่อปิด Dialog
                /* ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),*/
              ],
            ),
          ),
        ),
      );
    },
  );
}
