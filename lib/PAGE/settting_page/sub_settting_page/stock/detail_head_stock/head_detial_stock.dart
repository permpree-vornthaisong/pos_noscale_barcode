import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/stock/detail_head_stock/dropdown_stock.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/stock/excell_stock.dart';
import 'package:provider/provider.dart';

class head_detial_stock extends StatefulWidget {
  const head_detial_stock({super.key});

  @override
  State<head_detial_stock> createState() => _head_detial_stockState();
}

class _head_detial_stockState extends State<head_detial_stock> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    int day = now.day;
    int month = now.month;
    int year = now.year;
    return Consumer2<time_search_stock_provider, system_provider>(builder: (context, time_search_stocks, systems, child) {
      int days = time_search_stocks.get_all()[0].D;
      int months = time_search_stocks.get_all()[0].M;
      int years = time_search_stocks.get_all()[0].Y;
      int daye = time_search_stocks.get_all()[1].D;
      int monthe = time_search_stocks.get_all()[1].M;
      int yeare = time_search_stocks.get_all()[1].Y;

      int DATA_TIME = (day + month + year) * 2;

      int DATA_TIME2 = (days + months + years) + (daye + monthe + yeare);

      return Container(
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  color: Colors.black38,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        /*Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Container(),
                            ),
                          ),
                        ),*/
                        Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Row(children: [
                            Container(
                              width: 50,
                              child: Text(
                                " ตั้งแต่ ",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: AlignmentDirectional.centerStart,
                                width: 350,
                                height: 60,
                                child: Transform.scale(
                                  scale: 0.6,
                                  child: DropdownDatePicker(
                                    inputDecoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                                    ), // optional
                                    isDropdownHideUnderline: true, // optional
                                    isFormValidator: true, // optional
                                    startYear: 1900, // optional
                                    endYear: year + 50, // optional
                                    width: 10, // optional
                                    // selectedDay: 14, // optional
                                    selectedMonth: months, // optional
                                    selectedYear: years, // optional
                                    selectedDay: days,
                                    onChangedYear: (value) {
                                      //print('onChangedYear: $value');
                                      time_search_stocks.update_Y_start(int.parse(value ?? ''));
                                    },
                                    onChangedMonth: (value) {
                                      time_search_stocks.update_M_start(int.parse(value ?? ''));

                                      // print('onChangedMonth: $value');
                                    },
                                    onChangedDay: (value) {
                                      // print('onChangedDay: $value');
                                      time_search_stocks.update_D_start(int.parse(value ?? ''));

                                      //  print("object");
                                    },

                                    boxDecoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0)), // optional
                                    // showDay: false, // optional
                                    dayFlex: 2, // optional
                                    //locale: "zh_CN", // optional
                                    //hintDay: 'Day', // optional
                                    //hintMonth: 'Month', // optional
                                    //hintYear: 'Year', // optional
                                    hintTextStyle: TextStyle(color: Colors.grey), // optional
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        /*Container(
                          height: 25,
                          // padding: EdgeInsets.all(5),
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              DATA_TIME == DATA_TIME2 ? "วันนี้" : " ถึง ",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),*/
                        Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Row(children: [
                            Container(
                              width: 50,
                              child: Text(
                                " ถึง ",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: AlignmentDirectional.centerStart,
                                // width: 350,
                                height: 60,
                                child: Transform.scale(
                                  scale: 0.6,
                                  child: DropdownDatePicker(
                                    inputDecoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                                    ), // optional
                                    isDropdownHideUnderline: true, // optional
                                    isFormValidator: true, // optional
                                    startYear: 1900, // optional
                                    endYear: year + 50, // optional
                                    width: 10, // optional
                                    // selectedDay: 14, // optional
                                    selectedMonth: monthe, // optional
                                    selectedYear: yeare, // optional
                                    selectedDay: daye,
                                    onChangedYear: (value) {
                                      //  print('onChangedYear: $value');
                                      time_search_stocks.update_Y_END(int.parse(value ?? ''));
                                    },
                                    onChangedMonth: (value) {
                                      time_search_stocks.update_M_END(int.parse(value ?? ''));

                                      // print('onChangedMonth: $value');
                                    },
                                    onChangedDay: (value) {
                                      // print('onChangedDay: $value');
                                      time_search_stocks.update_D_END(int.parse(value ?? ''));

                                      //  print("object");
                                    },

                                    boxDecoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0)), // optional
                                    // showDay: false, // optional
                                    dayFlex: 2, // optional
                                    //locale: "zh_CN", // optional
                                    //hintDay: 'Day', // optional
                                    //hintMonth: 'Month', // optional
                                    //hintYear: 'Year', // optional
                                    hintTextStyle: TextStyle(color: Colors.grey), // optional
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Container(child: drop_down_type())

                        /* 
                        Expanded(
                          flex: 3,
                          child: Row(children: [
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: () {
                                final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
                                stocks.reset_data(context);
                              },
                              child: Container(
                                // color: Colors.white,

                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.all(5),
                                  color: Colors.greenAccent,
                                  child: Center(
                                    child: Text(
                                      " ค้นหา ",
                                      style: GoogleFonts.sarabun(
                                        textStyle: Theme.of(context).textTheme.displayLarge,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: () async {
                                // stocks.reset_data(context);
                                await deletc_stock(); // add product
                              },
                              child: Container(
                                // color: Colors.white,

                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.all(5),
                                  color: systems.get_all()[0].role == "master" ? Colors.redAccent : const Color.fromARGB(255, 117, 150, 167),
                                  child: Center(
                                    child: Text(
                                      " ล้าง stock ",
                                      style: GoogleFonts.sarabun(
                                        textStyle: Theme.of(context).textTheme.displayLarge,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: systems.get_all()[0].role == "master" ? Colors.white : const Color.fromARGB(255, 72, 91, 100),
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                          ]),
                        )*/
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black38,
                  child: Container(
                      margin: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                            child: Center(
                              child: Container(
                                //  color: Colors.blueAccent,
                                //  margin: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
                                    stocks.reset_data(context);
                                  },
                                  child: Container(
                                    // color: Colors.white,

                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.all(5),
                                      color: Colors.greenAccent,
                                      child: Center(
                                        child: Text(
                                          " ค้นหา ",
                                          style: GoogleFonts.sarabun(
                                            textStyle: Theme.of(context).textTheme.displayLarge,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            child: Center(
                              child: Container(
                                //  color: Colors.blueAccent,
                                //   margin: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () async {
                                    // stocks.reset_data(context);
                                    await deletc_stock(); // add product
                                  },
                                  child: Container(
                                    // color: Colors.white,

                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.all(5),
                                      color: systems.get_all()[0].role == "master" || !systems.get_all()[0].login_mode
                                          ? Colors.redAccent
                                          : const Color.fromARGB(255, 117, 150, 167),
                                      child: Center(
                                        child: Text(
                                          " ล้าง stock ",
                                          style: GoogleFonts.sarabun(
                                            textStyle: Theme.of(context).textTheme.displayLarge,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: systems.get_all()[0].role == "master" ? Colors.white : const Color.fromARGB(255, 72, 91, 100),
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            child: Center(
                              child: Container(
                                child: GestureDetector(
                                  onTap: () {
                                    EXCEL_sum_stock(context);
                                    EXCEL_stock(context);

                                    final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
                                    stocks.reset_data(context);
                                  },
                                  child: Container(
                                    // color: Colors.white,

                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.all(5),
                                      color: Colors.greenAccent,
                                      child: Center(
                                        child: Text(
                                          " นำออก Excell ",
                                          style: GoogleFonts.sarabun(
                                            textStyle: Theme.of(context).textTheme.displayLarge,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ],
                      )),
                )),
          ],
        ),
      );
    });
  }

  Future<void> deletc_stock() async {
    final stock_display_provider stock_displays = Provider.of<stock_display_provider>(context, listen: false);

    final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    final time_search_stock_provider time_search_stocks = Provider.of<time_search_stock_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    if (systems.get_all()[0].role == "master" || !systems.get_all()[0].login_mode) {
      stocks.delect_all();
      int L = data_products.get_all_nofilter().length;
      for (int i = 0; i < L; i++) {
        if (data_products.get_all_nofilter()[i].id != "99999") {
          final localDatabase = LocalDatabase();

          await localDatabase.add_Stock(
              unix: time_search_stocks.getUnixNow(),
              date_time: time_search_stocks.getFormattedTimeNow(),
              units: data_products.get_all_nofilter()[i].unit,
              id: data_products.get_all_nofilter()[i].id,
              type: data_products.get_all_nofilter()[i].type,
              name: data_products.get_all_nofilter()[i].name,
              state: "Refresh stock",
              who: systems.get_all()[0].cashier,
              num: 0,
              other: "-");
        }
      }

      await stock_displays.reset_data();
      await stock_displays.reset_type_data();
      await stock_displays.reset_data();
      await stocks.reset_type_data();
      await stocks.reset_id_data();
      await stocks.reset_data(context);
    }
  }
}

/*
     Container(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            alignment: AlignmentDirectional.centerStart,
                            width: 350,
                            height: 60,
                            child: Transform.scale(
                              scale: 0.7,
                              child: DropdownDatePicker(
                                inputDecoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                                ), // optional
                                isDropdownHideUnderline: true, // optional
                                isFormValidator: true, // optional
                                startYear: 1900, // optional
                                endYear: year, // optional
                                width: 10, // optional
                                // selectedDay: 14, // optional
                                selectedMonth: month, // optional
                                selectedYear: year, // optional
                                onChangedYear: (value) {
                                  // print('onChangedYear: $value');
                                  time_search_hiss.update_Y_END(int.parse(value ?? ''));
                                },
                                onChangedMonth: (value) {
                                  time_search_hiss.update_M_END(int.parse(value ?? ''));

                                  // print('onChangedMonth: $value');
                                },
                                onChangedDay: (value) {
                                  // print('onChangedDay: $value');
                                  time_search_hiss.update_D_END(int.parse(value ?? ''));

                                  //  print("object");
                                },

                                boxDecoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0)), // optional
                                // showDay: false, // optional
                                dayFlex: 2, // optional
                                //locale: "zh_CN", // optional
                                //hintDay: 'Day', // optional
                                //hintMonth: 'Month', // optional
                                //hintYear: 'Year', // optional
                                hintTextStyle: TextStyle(color: Colors.grey), // optional
                              ),
                            ),
                          ),

*/
