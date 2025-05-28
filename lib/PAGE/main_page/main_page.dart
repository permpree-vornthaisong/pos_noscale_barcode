import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/system.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/printter_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/inner_printter/inner_printter.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Scale_provider/main_scale_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/TEST_printer.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/bar/scanner/manage_key_scan.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/bill.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/customer/customer_search.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/data_product.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/display_data/manage_display_data.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/scale/sacle_main.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/setting_bt.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/tabbar_type/tabbar.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class main_page extends StatefulWidget {
  const main_page({super.key});

  @override
  State<main_page> createState() => _main_pageState();
}

class _main_pageState extends State<main_page> {
  double x = 0;
  double y = 0;
  double x2 = 0;
  double y2 = 0;
  bool state_print = false;
  bool state_drawer_manual = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // The code inside this callback will be executed after the frame is built
      final data_product_provider dataProducts = Provider.of<data_product_provider>(context, listen: false);
      final cashier_provider cashiers = Provider.of<cashier_provider>(context, listen: false);

      // Perform asynchronous operation with Future.delayed
      Future.delayed(Duration.zero, () {
        dataProducts.info(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width * 0.65;

    return Stack(children: [
      Container(
          color: Colors.black,
          child: Row(
            children: [
              Expanded(
                  flex: 30,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    color: Colors.black,
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                        ),
                        scale_main(),
                        Expanded(child: data_product_page()),
                        tabbar(),
                        Container(
                          height: 50,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          child: Row(
                            children: [
                              Container(
                                  width: 90,
                                  height: 50,
                                  color: Dark_threme.BG_shadow,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                    child: setting_bt(),
                                  )),
                              Container(
                                width: 90,
                                height: 50,
                                color: Dark_threme.BG_shadow,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                  child: key_scanner(),
                                ),
                                /* Expanded(child: Container()),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: setting_bt(),
                                )*/
                              ),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  children: [
                                    Expanded(
                                        //flex: 12,
                                        child: Container(
                                      margin: EdgeInsets.all(1),
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      child: manage_display_data(),
                                    )),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                        systems.get_all()[0].discount_mode ? customer_search() : Container()
                      ],
                    ),
                  )),
              Expanded(flex: 16, child: Container(margin: EdgeInsets.all(2), color: Dark_threme.Data_BG_shadow, child: bill()))
            ],
          )),
      Consumer2<PrinterManagerClass, system_provider>(builder: (context, PRINTTER, Systems, child) {
        return Stack(children: [
          Visibility(
            visible: Systems.get_all()[0].printter == "external",
            child: Positioned(
              left: screenWidth - 50 + x,
              top: y + 20,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    x += details.delta.dx;
                    y += details.delta.dy;
                  });
                  //   print('DeltaX: $x, DeltaY: $y');

                  // You can use deltaX and deltaY here as needed
                },
                child: Container(
                    color: Colors.white,
                    height: !state_print ? 50 : 500,
                    width: !state_print ? 50 : 500,
                    child: Column(
                      children: [
                        Visibility(
                            visible: !state_print,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  state_print = true;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                color: PRINTTER.isConnected ? Colors.greenAccent : Colors.red,
                                child: Center(
                                  child: Icon(
                                    PRINTTER.isConnected ? Icons.print : Icons.print_disabled,
                                    size: 40,
                                  ),
                                ),
                              ),
                            )),
                        Visibility(
                            visible: state_print,
                            child: Expanded(
                                child: Container(
                                    child: Stack(children: [
                              TEST_PRINTER(),
                              Positioned(
                                  child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    state_print = false;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: PRINTTER.isConnected ? Colors.greenAccent : Colors.red,
                                  child: Center(
                                    child: Icon(
                                      PRINTTER.isConnected ? Icons.print : Icons.print_disabled,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ))
                            ])))),
                      ],
                    )),
              ),
            ),
          ),
        ]);
      }),
      Consumer2<PrinterManagerClass, system_provider>(builder: (context, PRINTTER, Systems, child) {
        return Stack(children: [
          Visibility(
              visible: Systems.get_all()[0].drawer_manual,
              child: Positioned(
                  left: screenWidth - 50 + x2,
                  top: y2 + 70,
                  child: GestureDetector(
                    onTap: () async {
                      if (Systems.get_all()[0].printter == "external") {
                        await PRINTTER.drawer_manual(context);
                      } else if (Systems.get_all()[0].printter == "internal") {
                        final inner_printter_provider inner_printters = Provider.of<inner_printter_provider>(context, listen: false);

                        inner_printters.drawer_manual(context);
                      }
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        x2 += details.delta.dx;
                        y2 += details.delta.dy;
                      });
                      //   print('DeltaX: $x, DeltaY: $y');

                      // You can use deltaX and deltaY here as needed
                    },
                    child: Container(
                      color: Colors.yellowAccent,
                      height: 50,
                      width: 50,
                      child: Center(
                          child: Icon(
                        Icons.point_of_sale,
                        size: 40,
                      )),
                    ),
                  ))),
        ]);
      })
    ]);
  }
}
