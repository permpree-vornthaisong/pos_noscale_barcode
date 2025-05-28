import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/cashier_login/text_controller.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:pos_noscale_barcode/text.dart';
import 'package:provider/provider.dart';

class cashier_login extends StatefulWidget {
  const cashier_login({super.key});

  @override
  State<cashier_login> createState() => _cashier_loginState();
}

class _cashier_loginState extends State<cashier_login> {
  final TextEditingController controller1 = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  String TEXT_TYPEs = "";
  @override
  void initState() {
    super.initState();
    controller1.addListener(() {
      // เมื่อมีการเปลี่ยนค่าใน TextField ให้ทำอะไรบางอย่าง (ตามที่ต้องการ)
    });
  }

  @override
  Widget build(BuildContext context) {
    //////////////////////////
    _focusNode.requestFocus();
    //_focusNode2.unfocus();
    //////////////////////////
    String TEXT_TYPE = "";
    final cashier_provider cashiers = Provider.of<cashier_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    final page_state_provider page_states = Provider.of<page_state_provider>(context, listen: false);

    return Container(
      color: Dark_threme.BG_shadow,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          height: 300,
          width: 300,
          child: SingleChildScrollView(
            child: Container(
              height: 300,
              width: 200,
              child: Column(children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "รหัสพนักงาน",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
                    child: TextField(
                      controller: controller1,
                      decoration: InputDecoration(
                        labelText: '',
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      List<dynamic> GG = [];
                      if (TEXT_TYPEs.isNotEmpty) {
                        GG = cashiers.findNameById(TEXT_TYPEs);
                      } else if (controller1.text.isNotEmpty) {
                        //print("in");
                        GG = cashiers.findNameById(controller1.text);
                      }

                      if (GG[3] == "true") {
                        systems.update_cashier(GG[0]);
                        systems.update_role(GG[2]);

                        page_states.update_state(1);
                      } else {
                        controller1.text = '';

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "รหัสไม่ถูกต้อง",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 80,
                      color: Colors.greenAccent,
                      child: Center(
                          child: Text(
                        "ยืนยัน",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontStyle: FontStyle.normal,
                        ),
                      )),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),

      ////////////////////////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////////////////////////
      /*   RawKeyboardListener(
          focusNode: _focusNode,
          onKey: (RawKeyEvent event) async {
            if (event is RawKeyDownEvent) {
              controller1.text = "";
              //controller1.text = controller1.text + event.character.toString();
              if (event.logicalKey.keyLabel.toString() == "Backspace" && TEXT_TYPEs.length > 0) {
                print(event.logicalKey.keyLabel.toString());
                // controller1.text = controller1.text.substring(controller1.text.length - 1);
                //    print(TEXT_TYPEs);
                TEXT_TYPEs = TEXT_TYPEs.substring(0, TEXT_TYPEs.length - 1);
      
                setState(() {
                  TEXT_TYPEs = TEXT_TYPEs;
                });
              } else {
                //  print(TEXT_TYPEs);
      
                TEXT_TYPEs = TEXT_TYPEs + event.character.toString();
                setState(() {
                  TEXT_TYPEs = TEXT_TYPEs;
                });
      
                // print(TEXT_TYPEs);
              }
            }
          },
          child: Column(children: [
            Container(
              height: 100,
            ),
            SingleChildScrollView(
              child: Container(
                height: 300,
                width: 550,
                color: Colors.white,
                child: Column(children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "โปรดใส่รหัสผนักงาน",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      height: 100,
                      width: 200,
                      child: Stack(children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // เลื่อนแนวนอน
                          child: Container(
                            height: 50,
                            width: 200,
                            color: Color.fromARGB(0, 146, 119, 119),
                            child: Center(
                              child: Text(
                                TEXT_TYPEs,
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TEXT_LOGIN()
                      ]),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        List<dynamic> GG = cashiers.findNameById(controller1.text);
                        if (GG[1] == true) {
                          page_states.update_state(1);
                        } else {
                          controller1.text = '';
      
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "รหัสไม่ถูกต้อง",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 80,
                        color: Colors.greenAccent,
                        child: Center(
                            child: Text(
                          "ยืนยัน",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontStyle: FontStyle.normal,
                          ),
                        )),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ]),
        ),
        
        
        
        
        
        */

      ////////////////////////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////////////////////////
    );
  }

  void _SET() {
    setState(() {
      TEXT_TYPEs = "";
    });
  }
}


/*

  Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 200,
                        child: RawKeyboardListener(
                            focusNode: _focusNode,
                            onKey: (RawKeyEvent event) async {
                              if (event is RawKeyDownEvent) {
                                setState(() {
                                  _focusNode2.unfocus();
                                });
                                controller1.text = "";
                                //controller1.text = controller1.text + event.character.toString();
                                if (event.logicalKey.keyLabel.toString() == "Backspace" && TEXT_TYPEs.length > 0) {
                                  //   print(event.logicalKey.keyLabel.toString());
                                  //controller1.text = controller1.text.substring(controller1.text.length - 1);
                                  //    print(TEXT_TYPEs);
                                  TEXT_TYPEs = TEXT_TYPEs.substring(0, TEXT_TYPEs.length - 1);

                                  setState(() {
                                    TEXT_TYPEs = TEXT_TYPEs;
                                  });
                                } else {
                                  //    print(TEXT_TYPEs);

                                  TEXT_TYPEs = TEXT_TYPEs + event.character.toString();
                                  setState(() {
                                    TEXT_TYPEs = TEXT_TYPEs;
                                  });

                                  //   print(TEXT_TYPEs);
                                }
                              }
                            },
                            child: Container(
                              child: Text(
                                TEXT_TYPEs,
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            )),
                      ),
                      Container(
                        width: 200,
                        child: TextField(
                          focusNode: _focusNode2,
                          controller: controller1,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.sarabun(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          onTap: () async {
                            /* if (TEXT_TYPEs == "") {
                            } else {
                              setState(() {
                                TEXT_TYPEs = "";
                                _focusNode.unfocus();
                                _focusNode2.requestFocus();
                              });
                              await Future.delayed(Duration(milliseconds: 100));
                              _focusNode2.requestFocus();
                            }*/
                          },
                          onSubmitted: (_) {
                            /* setState(() {
                              _focusNode.requestFocus();
                              _focusNode2.unfocus();
                            });*/
                          },
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      )
                    ],
                  ),
                ),

*/