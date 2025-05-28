import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final systems = Provider.of<system_provider>(context, listen: false);

    return Stack(children: [
      Container(
        color: Dark_threme.BG_shadow,
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            Container(
              height: 440,
              child: Container(
                color: Dark_threme.BG,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Dark_threme.BG_shadow,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        color: Dark_threme.BG,
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  page_change_role_verify(3, context);
                                  //   page_states.update_state(3);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  height: 200,
                                  child: Column(children: [
                                    Expanded(child: Container()),
                                    Container(
                                        alignment: AlignmentDirectional.bottomCenter,
                                        child: Icon(
                                          Icons.settings,
                                          size: 80,
                                        )),
                                    Container(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Text(
                                        (systems.get_all()[0].language == "thai" ? thai_text().page_setting_system : eng_text().page_setting_system),
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ]),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  page_change_role_verify(4, context);
                                  //page_states.update_state(12);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                                  height: 200,
                                  child: Column(children: [
                                    Expanded(child: Container()),
                                    Container(
                                        alignment: AlignmentDirectional.bottomCenter,
                                        child: Icon(
                                          Icons.storage_rounded,
                                          size: 80,
                                        )),
                                    Container(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Text(
                                        (systems.get_all()[0].language == "thai"
                                            ? thai_text().page_setting_data_center
                                            : eng_text().page_setting_data_center),
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ]),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  // page_states.update_state(5);
                                  page_change_role_verify(5, context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  height: 200,
                                  child: Column(children: [
                                    Expanded(child: Container()),
                                    Container(
                                        alignment: AlignmentDirectional.bottomCenter,
                                        child: Icon(
                                          Icons.production_quantity_limits,
                                          size: 80,
                                        )),
                                    Container(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Text(
                                        (systems.get_all()[0].language == "thai"
                                            ? thai_text().page_setting_product
                                            : eng_text().page_setting_product),
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ]),
                                ),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  //  page_states.update_state(6);
                                  page_change_role_verify(6, context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  height: 200,
                                  child: Column(children: [
                                    Expanded(child: Container()),
                                    Container(
                                        alignment: AlignmentDirectional.bottomCenter,
                                        child: Icon(
                                          Icons.print_rounded,
                                          size: 80,
                                        )),
                                    Container(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Text(
                                        (systems.get_all()[0].language == "thai"
                                            ? thai_text().page_setting_printer
                                            : eng_text().page_setting_printer),
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ]),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  //  page_states.update_state(7);
                                  page_change_role_verify(7, context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  height: 200,
                                  child: Column(children: [
                                    //7
                                    Expanded(child: Container()),
                                    Container(
                                        alignment: AlignmentDirectional.bottomCenter,
                                        child: Icon(
                                          Icons.people_alt_outlined,
                                          size: 80,
                                        )),
                                    Container(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Text(
                                        (systems.get_all()[0].language == "thai"
                                            ? thai_text().page_setting_customer
                                            : eng_text().page_setting_customer),
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ]),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  //page_states.update_state(8);
                                  page_change_role_verify(8, context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  height: 200,
                                  child: Column(children: [
                                    Expanded(child: Container()),
                                    Container(
                                        alignment: AlignmentDirectional.bottomCenter,
                                        child: Icon(
                                          Icons.history_toggle_off,
                                          size: 80,
                                        )),
                                    Container(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Text(
                                        (systems.get_all()[0].language == "thai"
                                            ? thai_text().page_setting_history
                                            : eng_text().page_setting_history),
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ]),
                                ),
                              )),
                            ],
                          ),
                        ]),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Dark_threme.BG_shadow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // page_change_role_verify(1, context);
                        final page_states = Provider.of<page_state_provider>(context, listen: false);

                        page_states.update_state(1);
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 120,
        right: 20,
        child: Container(
          height: 60,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: systems.get_all()[0].login_mode ? Colors.white : Colors.grey[400],
          ),
          child: Center(
            child: Text(
              systems.get_all()[0].cashier,
              style: GoogleFonts.sarabun(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 0, 0, 0),
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ),
      ),
      Positioned(
          bottom: 20,
          right: 120,
          child: GestureDetector(
            onTap: () {
              if (systems.get_all()[0].login_mode) {
                showdialog_change_cashier(context);
              }
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: systems.get_all()[0].login_mode ? Colors.white : Colors.grey[400],
              ),
              child: Center(
                child: Icon(
                  Icons.people_alt,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          )),
      Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              if (systems.get_all()[0].login_mode) {
                page_change_role_verify_master_page(11, context);
              }
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: systems.get_all()[0].login_mode ? Colors.white : Colors.grey[400],
              ),
              child: Center(
                child: Icon(
                  Icons.lock_clock_rounded,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ))
    ]);
  }
}

void page_change_role_verify(int page, context) {
  final page_states = Provider.of<page_state_provider>(context, listen: false);
  final systems = Provider.of<system_provider>(context, listen: false);
  final lock_pages = Provider.of<lock_page_provider>(context, listen: false);

  if (!systems.get_all()[0].login_mode) {
    page_states.update_state(page);
    return;
  }

  if (systems.get_all()[0].role == "master") {
    page_states.update_state(page);

    return;
  }

  if (systems.get_all()[0].role == "admin") {
    /*
    start_page(),
      main_page(), SettingPage(),
      /////////
      main_system(), //3
      main_product(),
      main_product()
      /////////
      ,
      MyDraggableWidget(),
      main_customer(),
      history_bill(),
      cashier_login(),
      activate(),
      //10,
      MainLockPage() //11
    
    
    */
    if (page == 3) {
      if (lock_pages.get_data().p1) {
        page_states.update_state(page);
      }
    }
    if (page == 4) {
      if (lock_pages.get_data().p2) {
        page_states.update_state(page);
      }
    }
    if (page == 5) {
      if (lock_pages.get_data().p3) {
        page_states.update_state(page);
      }
    }
    if (page == 6) {
      if (lock_pages.get_data().p4) {
        page_states.update_state(page);
      }
    }
    if (page == 7) {
      if (lock_pages.get_data().p5) {
        page_states.update_state(page);
      }
    }
    if (page == 8) {
      if (lock_pages.get_data().p6) {
        page_states.update_state(page);
      }
    }

    return;
  }

  if (systems.get_all()[0].role == "staff") {
    return;
  }
}

void page_change_role_verify_master_page(int page, context) {
  final page_states = Provider.of<page_state_provider>(context, listen: false);
  final systems = Provider.of<system_provider>(context, listen: false);
  if (systems.get_all()[0].role == "master") {
    page_states.update_state(page);

    return;
  }
}

void showdialog_change_cashier(BuildContext context) {
  // Create a TextEditingController
  TextEditingController textController = TextEditingController();
  final systems = Provider.of<system_provider>(context, listen: false);
  final cashiers = Provider.of<cashier_provider>(context, listen: false);
  final page_states = Provider.of<page_state_provider>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
            child: Container(
          height: 300,
          width: 200,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "เปลี่ยน พนักงาน",
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
              Container(
                margin: EdgeInsets.fromLTRB(40, 20, 20, 40),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'รหัส',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Center(
                    child: GestureDetector(
                  onTap: () {
                    List<String> GG = cashiers.findNameById(textController.text);

                    if (GG[3] == "true") {
                      systems.update_cashier(GG[0]);
                      systems.update_role(GG[2]);

                      page_states.update_state(1);
                      Navigator.of(context).pop(); // Close the dialog
                    } else {
                      textController.text = "";
                    }
                  },
                  child: Container(
                      height: 60,
                      width: 120,
                      color: Dark_threme.BG_shadow,
                      child: Center(
                          child: Text(
                        "ยืนยัน",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                        ),
                      ))),
                )),
              )
            ],
          ),
        )),
      );
    },
  );
}


/*
Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Header'),
            SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Input Text',
              ),
            ),
          ],
        ),



/*

 actions: [
          ElevatedButton(
            onPressed: () {
              // Handle confirm button press
              print('Input text: ${textController.text}');
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Confirm'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],


*/

*/