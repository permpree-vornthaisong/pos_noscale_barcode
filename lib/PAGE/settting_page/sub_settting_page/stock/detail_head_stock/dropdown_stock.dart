import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:provider/provider.dart';

class drop_down_type extends StatefulWidget {
  const drop_down_type({super.key});

  @override
  State<drop_down_type> createState() => _drop_down_typeState();
}

class _drop_down_typeState extends State<drop_down_type> {
  final TextEditingController textController = TextEditingController();
  String? selectedValue;
  String? selectedValue2;
  String? selectedValue3;

  List<String> dataTypes = [];
  List<String> dataids = [];

  List<String> units = ["ทั้งหมด", "KG", "p"];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 0), () {
      final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);

      setState(() {
        dataTypes = stocks.get_data_type();
        dataids = stocks.get_data_id();

        selectedValue = dataTypes.isNotEmpty && dataTypes.contains(stocks.get_display_type()) ? stocks.get_display_type() : "ทั้งหมด";
        selectedValue2 = dataids.isNotEmpty && dataids.contains(stocks.get_display_id()) ? stocks.get_display_id() : "ทั้งหมด";
        selectedValue3 = units.isNotEmpty && units.contains(stocks.get_display_units()) ? stocks.get_display_units() : "ทั้งหมด";
      });

      //  stocks.update_display_type("");
      // stocks.update_display_id("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<stock_provider>(builder: (context, stocks, child) {
      return Container(
        // margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 30,
              color: Colors.white,
              child: Row(children: [
                Expanded(
                  child: Container(
                    child: Text(
                      "   ชนิด",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                //Expanded(child: Container()),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue;
                        if (newValue == "ทั้งหมด") {
                          stocks.update_display_type("");
                        } else {
                          stocks.update_display_type(newValue!);
                        }
                      });
                    },
                    items: dataTypes.toSet().toList().map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          "  " + value,
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ]),
            ),
            Container(
              height: 30,
              color: Colors.white,
              child: Row(children: [
                Expanded(
                  child: Container(
                    child: Text(
                      "   รหัสสินค้า",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                // Expanded(child: Container()),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedValue2,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue2 = newValue;
                        if (newValue == "ทั้งหมด") {
                          stocks.update_display_id("");
                        } else {
                          stocks.update_display_id(newValue!);
                        }
                      });
                    },
                    items: dataids.toSet().toList().map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          "  " + value,
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ]),
            ),
            Container(
              height: 30,
              color: Colors.white,
              child: Row(children: [
                Expanded(
                  child: Container(
                    child: Text(
                      "   หน่วย",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                //Expanded(child: Container()),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedValue3,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue3 = newValue;
                        if (newValue == "ทั้งหมด") {
                          stocks.update_display_units("");
                        } else {
                          stocks.update_display_units(newValue!);
                        }
                      });
                    },
                    items: units.toSet().toList().map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          "  " + value,
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ]),
            ),
            /* Expanded(
                child: Container(
              margin: EdgeInsets.fromLTRB(40, 5, 40, 0),
              color: Colors.greenAccent,
              child: Center(
                child: Text(
                  "นำออก excell",
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ))*/
          ],
        ),
      );
    });
  }
}
