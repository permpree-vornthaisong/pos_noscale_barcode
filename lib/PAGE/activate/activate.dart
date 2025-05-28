import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/active.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';

import 'package:provider/provider.dart';

class main_active_page extends StatefulWidget {
  const main_active_page({super.key});

  @override
  State<main_active_page> createState() => _main_active_pageState();
}

class _main_active_pageState extends State<main_active_page> {
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<activate_provider>(builder: (context, actives, child) {
      return Container(
        color: const Color.fromARGB(255, 109, 98, 98),
        child: Center(
          child: Container(
            height: 540,
            width: 600,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(children: [
                        Expanded(
                            child: Container(
                          child: Center(
                            child: Text(
                              actives.get_data().b1.toString(),
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                          child: TextField(
                            controller: _textController1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),

                              //labelText: 'Enter text here',
                            ),
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.sarabun(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(children: [
                        Expanded(
                            child: Container(
                          child: Center(
                            child: Text(
                              actives.get_data().b2.toString(),
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                          child: TextField(
                            controller: _textController2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),

                              //labelText: 'Enter text here',
                            ),
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.sarabun(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(children: [
                        Expanded(
                            child: Container(
                          child: Center(
                            child: Text(
                              actives.get_data().b3.toString(),
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                          child: TextField(
                            controller: _textController3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),

                              //labelText: 'Enter text here',
                            ),
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.sarabun(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (_textController1.text.isNotEmpty && _textController2.text.isNotEmpty && _textController3.text.isNotEmpty) {
                              _active_(_textController1.text, _textController2.text, _textController3.text, context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("กรุณา กรอกรหัส"),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 80,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 9, 161, 29),
                            ),
                            child: Center(
                              child: Text(
                                "ยืนยัน",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _active_(String b1, String b2, String b3, context) async {
    final actives = Provider.of<activate_provider>(context, listen: false);
    final page_states = Provider.of<page_state_provider>(context, listen: false);

    int B1 = int.parse(b1); //b2
    int B2 = int.parse(b2); //b3
    int B3 = int.parse(b3); //b1

    int C_B1 = actives.get_data().b2 ~/ 2 + 2;
    int C_B2 = actives.get_data().b3 ~/ 4 + 4;
    int C_B3 = actives.get_data().b1 ~/ 6 + 6;

    if (B1 == C_B1 && B2 == C_B2 && B3 == C_B3) {
      await actives.active_system(context);
      await page_states.update_state(1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            width: 300,
            // Adjust width here
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.black, // Background color of SnackBar
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            child: Text(
              "รหัสผิด",
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 24.0, // Text size
              ),
              textAlign: TextAlign.center, // Center text
            ),
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating, // Makes the SnackBar float above other content
          margin: EdgeInsets.all(16.0), // Margin around the SnackBar
        ),
      );

      setState(() {
        _textController1.text = "";
        _textController2.text = "";
        _textController3.text = "";
      });
    }
  }
}


/*





import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/PAGE/activate/function.dart';
import 'package:pos_noscale_barcode/colour.dart';

class activate extends StatefulWidget {
  const activate({super.key});

  @override
  State<activate> createState() => _activateState();
}

class _activateState extends State<activate> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  Color buttonColor1 = Colors.black12;
  Color buttonColor2 = Colors.black12;

  void changeButtonColor1() {
    setState(() {
      buttonColor1 = Colors.green; // เปลี่ยนสีปุ่มเป็นสีเขียว
    });
    // ใช้ Timer เพื่อเปลี่ยนสีกลับเป็นสีเดิมหลังจากเวลาที่กำหนด
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        buttonColor1 = Colors.black12; // เปลี่ยนสีปุ่มกลับเป็นสีเดิม
      });
    });
  }

  void changeButtonColor2() {
    setState(() {
      buttonColor2 = Colors.green; // เปลี่ยนสีปุ่มเป็นสีเขียว
    });
    // ใช้ Timer เพื่อเปลี่ยนสีกลับเป็นสีเดิมหลังจากเวลาที่กำหนด
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        buttonColor2 = Colors.black12; // เปลี่ยนสีปุ่มกลับเป็นสีเดิม
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      color: Dark_threme.BG_shadow,
      height: screenSize.height,
      width: screenSize.width,
      child: Center(
        child: Container(
          color: Colors.white,
          height: 320,
          width: 400,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      "activate",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: controller1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'ชื่อ', // กำหนด hintText เริ่มต้น
                  ),
                  onChanged: (value) {
                    setState(() {
                      // ถ้ามีการพิมพ์ใน TextField ให้กำหนด hintText เป็น null เพื่อให้หายไป
                      hintText:
                      null;
                    });
                  },
                ),
                TextField(
                  controller: controller2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'ที่ไหน', // กำหนด hintText เริ่มต้น
                  ),
                  onChanged: (value) {
                    setState(() {
                      // ถ้ามีการพิมพ์ใน TextField ให้กำหนด hintText เป็น null เพื่อให้หายไป
                      hintText:
                      null;
                    });
                  },
                ),
                TextField(
                  controller: controller3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'รุ่นเครื่องอะไร', // กำหนด hintText เริ่มต้น
                  ),
                  onChanged: (value) {
                    setState(() {
                      // ถ้ามีการพิมพ์ใน TextField ให้กำหนด hintText เป็น null เพื่อให้หายไป
                      hintText:
                      null;
                    });
                  },
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          changeButtonColor1(); // เมื่อคลิกที่ปุ่ม จะเปลี่ยนสี

                          await Future.delayed(Duration(milliseconds: 200), () async {
                            await ACTIVE_PRODUCT(context);
                            // await activate_req(context, controller1.text, controller2.text, controller3.text);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(30, 0, 10, 0),
                          width: 100,
                          height: 60,
                          color: buttonColor1,
                          child: Center(
                            child: Text(
                              "ส่งข้อมูล",
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
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          changeButtonColor2();
                          await Future.delayed(Duration(milliseconds: 200), () async {
                            await activate_confirm(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 30, 0),
                          width: 100,
                          height: 60,
                          color: buttonColor2,
                          child: Center(
                            child: Text(
                              "ปลดล๊อค",
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
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

*/



/*
        await Future.delayed(Duration(milliseconds: 200), () async {
                            await ACTIVE_PRODUCT(context);
                            // await activate_req(context, controller1.text, controller2.text, controller3.text);
                          });

*/
/*

   Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          changeButtonColor(); // เมื่อคลิกที่ปุ่ม จะเปลี่ยนสี
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200), // กำหนดเวลาในการ animate
                          margin: EdgeInsets.fromLTRB(30, 0, 10, 0),
                          width: 100,
                          height: 60,
                          color: buttonColor, // กำหนดสีของปุ่ม
                          child: Center(
                            child: Text(
                              "ส่งข้อมูล",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          changeButtonColor(); // เมื่อคลิกที่ปุ่ม จะเปลี่ยนสี
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200), // กำหนดเวลาในการ animate
                          margin: EdgeInsets.fromLTRB(10, 0, 30, 0),
                          width: 100,
                          height: 60,
                          color: buttonColor, // กำหนดสีของปุ่ม
                          child: Center(
                            child: Text(
                              "ปลดล๊อค",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
*/