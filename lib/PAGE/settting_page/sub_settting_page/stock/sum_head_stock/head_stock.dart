import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/printter_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/inner_printter/inner_printter.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:provider/provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';

class HeadSubStock extends StatefulWidget {
  const HeadSubStock({super.key});

  @override
  State<HeadSubStock> createState() => _HeadState();
}

class _HeadState extends State<HeadSubStock> {
  final TextEditingController textController = TextEditingController();
  String? selectedValue;
  List<String> dataTypes = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 0), () {
      final stock_display_provider stock_displays = Provider.of<stock_display_provider>(context, listen: false);
      final stock_display_provider displayStocks = Provider.of<stock_display_provider>(context, listen: false);

      setState(() {
        dataTypes = stock_displays.get_data_type();
        selectedValue = dataTypes.isNotEmpty && dataTypes.contains(stock_displays.get_display_type()) ? stock_displays.get_display_type() : null;
        selectedValue = "ทั้งหมด";
        textController.text = "";
      });

      //   setState(() {
      //  selectedValue = "ทั้งหมด";
      displayStocks.update_display_type("ทั้งหมด");
      // textController.text = "";
      displayStocks.update_num_data("");
      //  });

      stock_displays.update_display_type("");
      stock_displays.update_num_data("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Consumer<stock_display_provider>(
        builder: (context, displayStocks, child) {
          selectedValue ??= dataTypes.isNotEmpty ? dataTypes[0] : null;
          return Container(
            padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // TextField สำหรับให้ผู้ใช้กรอกข้อมูล
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              labelText: 'รหัสสินค้า',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              displayStocks.update_num_data(value);
                            },
                          ),
                        ),
                      ),

                      // DropdownButton สำหรับให้ผู้ใช้เลือกค่า
                      Expanded(
                        child: Container(
                          child: DropdownButton<String>(
                            value: selectedValue,
                            isExpanded: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedValue = newValue;
                                displayStocks.update_display_type(newValue!);
                              });
                            },
                            items: dataTypes.toSet().toList().map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  "  " + value,
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedValue = "ทั้งหมด";
                            displayStocks.update_display_type("ทั้งหมด");
                            textController.text = "";
                            displayStocks.update_num_data("");
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Colors.black38,
                          child: Center(
                            child: Icon(Icons.refresh),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /* Expanded(
                  child: Container(
                    child: Center(
                      child: Container(
                        height: 90,
                        width: 90,
                        color: Colors.greenAccent,
                        child: Center(
                          child: Column(children: [
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              "นำออก",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              "excell",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),*/
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    final systems = Provider.of<system_provider>(context, listen: false);

                    final PrinterManagers = Provider.of<PrinterManagerClass>(context, listen: false);
                    final inner_printters = Provider.of<inner_printter_provider>(context, listen: false);
                    if (systems.get_all()[0].printter == "internal") {
                      await inner_printters.print_stock(context);
                    } else if (systems.get_all()[0].printter == "external") {
                      await PrinterManagers.print_sum_stock(context);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(4),
                    color: Colors.greenAccent,
                    child: Center(
                      child: Icon(
                        Icons.print,
                        size: 35,
                      ),
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
