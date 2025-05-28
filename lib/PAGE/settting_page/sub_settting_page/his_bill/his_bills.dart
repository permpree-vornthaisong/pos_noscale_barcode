import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/his_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/threme_state_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/his_bill/dialog_hisbill.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/his_bill/excell.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/his_bill/function.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/his_bill/sunhisbill.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class history_bill extends StatefulWidget {
  const history_bill({super.key});

  @override
  State<history_bill> createState() => _his_billsState();
}

class _his_billsState extends State<history_bill> {
  final localDatabase = LocalDatabase();

  List<Map<String, dynamic>> _bill_list = [];

  void initState() {
    super.initState();

    // หน่วงเวลา 2 วินาที ก่อนที่จะทำงานต่อ
    data();
  }

  Future<void> data() async {
    final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false);

    Future.delayed(Duration(seconds: 0), () async {
      await his_bills.getdata(context);
      /*  _bill_list = await localDatabase.readall_bill_time(

          /// info
          DateTime(
            time_search_hiss.get_all()[0].Y,
            time_search_hiss.get_all()[0].M,
            time_search_hiss.get_all()[0].D,
            time_search_hiss.get_all()[0].h,
            time_search_hiss.get_all()[0].m,
            time_search_hiss.get_all()[0].s,
            // 2024,
            // 1,
            // 1,
          ),
          DateTime(
            time_search_hiss.get_all()[1].Y,
            time_search_hiss.get_all()[1].M,
            time_search_hiss.get_all()[1].D,
            time_search_hiss.get_all()[1].h,
            time_search_hiss.get_all()[1].m,
            time_search_hiss.get_all()[1].s,
          ));

      print(_bill_list.length);

      //_bill_list = await localDatabase.readall_head_bill();
      await time_searchs.read_his_bill(_bill_list, context);*/
    });
  }

  @override
  Widget build(BuildContext context) {
    final page_states = Provider.of<page_state_provider>(context, listen: false);
    final time_search_his_provider time_search_hiss = Provider.of<time_search_his_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false);

    DateTime now = DateTime.now();

    int day = now.day;
    int month = now.month;
    int year = now.year;

    return Container(
        color: Dark_threme.BG,
        child: Row(children: [
          Expanded(
              flex: 16,
              child: Container(
                color: Dark_threme.BG_shadow,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      child: Column(children: [
                        Container(
                          height: 75,
                        ),
                        sumhisbill(),
                        Expanded(child: Container()), // his_bills.sortDescending
                        GestureDetector(
                          onTap: () {
                            his_bills.sortDescending();
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            color: Colors.greenAccent,
                            height: 50,
                            child: Center(
                              child: Text(
                                "M to m",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 0, 0, 0), // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            his_bills.sortAscending();
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            color: Colors.greenAccent,
                            height: 50,
                            child: Center(
                              child: Text(
                                "m to M",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 0, 0, 0), // Text color
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Expanded(child: Container()),

                        Visibility(
                          visible: systems.get_all()[0].role == "master" || !systems.get_all()[0].login_mode,
                          child: GestureDetector(
                            onTap: () {
                              his_reset_index_bill(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              color: Colors.orangeAccent,
                              child: Center(
                                child: Text(
                                  "reset bill",
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(255, 0, 0, 0), // Text color
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: systems.get_all()[0].role == "master" || !systems.get_all()[0].login_mode,
                          child: GestureDetector(
                            onTap: () {
                              his_delect_bill(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              color: Colors.redAccent,
                              child: Center(
                                child: Text(
                                  "erase bill",
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(255, 0, 0, 0), // Text color
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                    )),
                    Container(
                      child: InkWell(
                        onTap: () {
                          page_states.update_state(2);
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
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 100,
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                        color: Colors.white,
                        child: Row(children: [
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
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(2))), // optional
                                isDropdownHideUnderline: true, // optional
                                isFormValidator: true, // optional
                                startYear: 1900, // optional
                                endYear: year + 100, // optional
                                width: 10, // optional
                                // selectedDay: 14, // optional
                                selectedMonth: month, // optional
                                selectedYear: year, // optional
                                onChangedDay: (value) {
                                  //  print('onChangedDay: $value');
                                  //  print("object");
                                  time_search_hiss.update_D_start(int.parse(value ?? ''));
                                },

                                onChangedMonth: (value) {
                                  // print('onChangedMonth: $value');
                                  time_search_hiss.update_M_start(int.parse(value ?? ''));
                                },
                                onChangedYear: (value) {
                                  // print('onChangedYear: $value');
                                  time_search_hiss.update_Y_start(int.parse(value ?? ''));
                                  // print(time_search_hiss.get_all()[0].Y);
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
                          Container(
                            color: Colors.white,
                            child: Text(
                              (systems.get_all()[0].language == "thai" ? thai_text().history_time_end : eng_text().history_time_end),
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 0, 0, 0), // Text color
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
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
                                endYear: year + 100, // optional
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
                          InkWell(
                            onTap: () async {
                              await data();
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 127, 202, 129),
                              ),
                              width: 100,
                              height: 50,
                              child: Center(
                                child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().history_confirm : eng_text().history_confirm),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromARGB(255, 0, 0, 0), // Text color
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              //await data();
                              EXCEL_bill(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 127, 202, 129),
                              ),
                              width: 150,
                              height: 50,
                              child: Center(
                                child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().history_save_output : eng_text().history_save_output),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromARGB(255, 0, 0, 0), // Text color
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )),
                  Expanded(
                      flex: 8,
                      child: Column(children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                                //margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                color: Colors.white,
                                child: Row(children: [
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                        child: Consumer<time_search_his_provider>(builder: (context, time_his_provider2, child) {
                                          return Container(
                                            alignment: AlignmentDirectional.center,
                                            child: Container(
                                              alignment: AlignmentDirectional.centerEnd,
                                              child: Text(
                                                time_his_provider2.get_all()[0].Y +
                                                                time_his_provider2.get_all()[0].M +
                                                                time_his_provider2.get_all()[0].D ==
                                                            time_his_provider2.get_all()[1].Y +
                                                                time_his_provider2.get_all()[1].M +
                                                                time_his_provider2.get_all()[1].D &&
                                                        day + month + year ==
                                                            time_his_provider2.get_all()[1].Y +
                                                                time_his_provider2.get_all()[1].M +
                                                                time_his_provider2.get_all()[1].D
                                                    ? (systems.get_all()[0].language == "thai"
                                                            ? thai_text().history_time_now
                                                            : eng_text().history_time_now) +
                                                        "                                             "
                                                    : "                                             " +
                                                        (systems.get_all()[0].language == "thai"
                                                            ? thai_text().history_time_start
                                                            : eng_text().history_time_start) +
                                                        " " +
                                                        time_his_provider2.get_all()[0].D.toString() +
                                                        "/" +
                                                        time_his_provider2.get_all()[0].M.toString() +
                                                        "/" +
                                                        time_his_provider2.get_all()[0].Y.toString() +
                                                        " " +
                                                        " " +
                                                        (systems.get_all()[0].language == "thai"
                                                            ? thai_text().history_time_end
                                                            : eng_text().history_time_end) +
                                                        " " +
                                                        time_his_provider2.get_all()[1].D.toString() +
                                                        "/" +
                                                        time_his_provider2.get_all()[1].M.toString() +
                                                        "/" +
                                                        time_his_provider2.get_all()[1].Y.toString(),
                                                style: GoogleFonts.sarabun(
                                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color.fromARGB(255, 0, 0, 0), // Text color
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      )),
                                  Expanded(flex: 2, child: Container())
                                ]))),
                        Expanded(
                          flex: 50,

                          child: Consumer<his_bill_provider>(
                            builder: (context, his_bills, child) {
                              return Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                          width: 4000,
                                          child: Container(
                                            color: Colors.black12,
                                            child: Column(children: [
                                              Container(
                                                height: 100,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_id
                                                                : eng_text().history_id),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_cashier
                                                                : eng_text().history_cashier),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_date
                                                                : eng_text().history_date),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_tax
                                                                : eng_text().history_tax),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_net
                                                                : eng_text().history_net),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_list
                                                                : eng_text().history_list),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " + "น้ำหนักรวม",
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_item
                                                                : eng_text().history_item),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_status
                                                                : eng_text().history_status),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_pay_m
                                                                : eng_text().history_pay_m), //method_pay
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_money_before_discount
                                                                : eng_text().history_money_before_discount),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_discount
                                                                : eng_text().history_discount),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_money_before_vat
                                                                : eng_text().history_money_before_vat),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_vat
                                                                : eng_text().history_vat),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_net
                                                                : eng_text().history_net),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_received
                                                                : eng_text().history_received),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_change
                                                                : eng_text().history_change),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_id_cus
                                                                : eng_text().history_id_cus),
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      width: 4,
                                                      color: Colors.black,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      alignment: AlignmentDirectional.center,
                                                      height: 50,
                                                      color: Colors.white,
                                                      margin: EdgeInsets.fromLTRB(3, 5, 3, 5),
                                                      child: Text(
                                                        " " +
                                                            (systems.get_all()[0].language == "thai"
                                                                ? thai_text().history_type_cus
                                                                : eng_text().history_type_cus), //type_customer
                                                        style: GoogleFonts.sarabun(
                                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w600,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: Container(
                                                  height: 500,
                                                  // color: const Color.fromARGB(255, 231, 105, 105),
                                                  child: ListView.builder(
                                                    itemCount: his_bills.get_all().length, // จำนวนรายการที่มีใน ListView
                                                    itemBuilder: (BuildContext context, int index) {
                                                      // สร้างแต่ละรายการใน ListView โดยใช้ index เพื่ออ้างอิงถึงข้อมูลใน List
                                                      String DATA = his_bills.get_all()[index].state;
                                                      List<String> parts = DATA.split('/');

                                                      return GestureDetector(
                                                        onDoubleTap: () async {
                                                          await showRedDialog(context, index);
                                                        },
                                                        onTap: () async {
                                                          await _detail_show(context, index);
                                                        },
                                                        child: Container(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].id_bill,
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].cahier,
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].date_time,
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].tax_id,
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.centerEnd,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].sum_money + " บาท    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].sum_list + " รายการ    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].sum_weight + " กก.",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].sum_detial_list + " ชิ้น    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].state,
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].method_pay,
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.centerEnd,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].sum_money_t + " บาท    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.centerEnd,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].discount + " บาท    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.centerEnd,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].sum_money_before_tax + " บาท    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.centerEnd,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].tax_money + " บาท    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.centerEnd,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].sum_money + " บาท    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.centerEnd,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].pay_money + " บาท    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.centerEnd,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].money_back + " บาท    ",
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].customer,
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                              Container(
                                                                width: 4,
                                                                height: 60,
                                                                color: Colors.black,
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                height: 50,
                                                                color: parts[1] == "yes" ? Colors.white : Color.fromARGB(255, 248, 253, 176),
                                                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                child: Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  child: Text(
                                                                    his_bills.get_all()[index].type_customer,
                                                                    style: GoogleFonts.sarabun(
                                                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          )),
                                    ),
                                  ));
                            },
                          ),

                          //  head_bill(),
                        ),
                      ])),
                ],
              ))
        ]));
  }

  Future<void> showRedDialog(BuildContext context, int INDEX) async {
    final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    final time_search_stock_provider time_search_stocks = Provider.of<time_search_stock_provider>(context, listen: false);

    String DATA = his_bills.get_all()[INDEX].state;
    List<String> parts = DATA.split('/');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 100,
            height: 200,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(5),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: parts[1] == "yes"
                      ? Center(
                          child: Text(
                          "ยกเลิก ใบเสร็จ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ))
                      : Center(
                          child: Text(
                          "ยืนยัน ใบเสร็จ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        )),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    // print(INDEX);
                    await his_bills.state_no(INDEX, context);

                    for (int i = 0; i < his_bills.get_all()[INDEX].detial.length; i++) {
                      //  print("sdfsdfsdfsdf");
                      /*  print(his_bills.get_all()[INDEX].detial[i]["units"]);
                      print(his_bills.get_all()[INDEX].detial[i]["weight"]);
                      print(his_bills.get_all()[INDEX].detial[i]["item"]);
                      print(his_bills.get_all()[INDEX].detial[i]["units"]);
                      print(his_bills.get_all()[INDEX].detial[i]["type"]);
                      print(his_bills.get_all()[INDEX].detial[i]["name"]);*/

                      double DATA_stock = his_bills.get_all()[INDEX].detial[i]["units"] == "KG"
                          ? double.parse(his_bills.get_all()[INDEX].detial[i]["weight"])
                          : his_bills.get_all()[INDEX].detial[i]["item"].toDouble();
                      await localDatabase.add_Stock(
                          unix: time_search_stocks.getUnixNow(),
                          date_time: time_search_stocks.getFormattedTimeNow(),
                          units: his_bills.get_all()[INDEX].detial[i]["units"],
                          id: his_bills.get_all()[INDEX].detial[i]["id"],
                          type: his_bills.get_all()[INDEX].detial[i]["type"],
                          name: his_bills.get_all()[INDEX].detial[i]["name"],
                          state: parts[1] == "yes" ? "cancel/bill ${INDEX + 1}" : "confirm/bill ${INDEX + 1}",
                          who: systems.get_all()[0].cashier,
                          num: parts[1] == "yes" ? DATA_stock : -DATA_stock,
                          other: "-");
                    }

                    final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
                    final stock_display_provider stock_displays = Provider.of<stock_display_provider>(context, listen: false);

                    await stock_displays.reset_data();
                    await stock_displays.reset_type_data();

                    await stock_displays.reset_data();
                    await stocks.reset_type_data();
                    await stocks.reset_id_data();

                    await stocks.reset_data(context);

                    await data();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    color: Colors.amber,
                    child: Center(
                        child: Text(
                      " กดยืนยัน ",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                  ),
                ))
              ],
            ),
          ),
        );
      },
    ); ////                 Navigator.of(context).pop();
  }

  Future<void> _detail_show(BuildContext context, int INDEX) async {
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: 400,
            width: 800,
            child: Column(children: [
              Container(
                color: Dark_threme.BG_shadow,
                height: 70,
                width: 800,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: 50,
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          " รหัสสินค้า ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    )),
                    Container(
                      width: 4,
                      height: 60,
                      color: Colors.black,
                    ),
                    Expanded(
                        child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: 50,
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          " ชื่อ ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    )),
                    Container(
                      width: 4,
                      height: 60,
                      color: Colors.black,
                    ),
                    Expanded(
                        child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: 50,
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          " จำนวน ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    )),
                    Container(
                      width: 4,
                      height: 60,
                      color: Colors.black,
                    ),
                    Expanded(
                        child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: 50,
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          " ราคาต่อหน่วย ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    )),
                    Container(
                      width: 4,
                      height: 60,
                      color: Colors.black,
                    ),
                    Expanded(
                        child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: 50,
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          " ราคาทั้งหมด ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    )),
                    Container(
                      width: 4,
                      height: 60,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Container(
                height: 320,
                width: 800,
                color: Colors.white,
                child: Consumer<his_bill_provider>(
                  builder: (context, his_bills, child) {
                    return Container(
                      alignment: AlignmentDirectional.center,
                      child: Container(
                          child: ListView.builder(
                        itemCount: his_bills.get_all()[INDEX].detial.length + 1, // จำนวนรายการที่มีใน ListView
                        itemBuilder: (BuildContext context, int index) {
                          // สร้าง Widget สำหรับแสดงข้อมูลแต่ละรายการใน ListView
                          return index < his_bills.get_all()[INDEX].detial.length
                              ? Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        alignment: AlignmentDirectional.centerStart,
                                        height: 50,
                                        color: Colors.white,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Container(
                                          alignment: AlignmentDirectional.center,
                                          child: Text(
                                            his_bills.get_all()[INDEX].detial[index]["id"],
                                            style: GoogleFonts.sarabun(
                                              textStyle: Theme.of(context).textTheme.displayLarge,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      )),
                                      Container(
                                        width: 4,
                                        height: 60,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                          child: Container(
                                        alignment: AlignmentDirectional.centerStart,
                                        height: 50,
                                        color: Colors.white,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Container(
                                          alignment: AlignmentDirectional.center,
                                          child: Text(
                                            his_bills.get_all()[INDEX].detial[index]["name"],
                                            style: GoogleFonts.sarabun(
                                              textStyle: Theme.of(context).textTheme.displayLarge,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      )),
                                      Container(
                                        width: 4,
                                        height: 60,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                          child: Container(
                                        alignment: AlignmentDirectional.centerStart,
                                        height: 50,
                                        color: Colors.white,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Container(
                                          alignment: AlignmentDirectional.center,
                                          child: Text(
                                            his_bills.get_all()[INDEX].detial[index]["units"] == "KG"
                                                ? his_bills.get_all()[INDEX].detial[index]["weight"].toString() + " กก. "
                                                : his_bills.get_all()[INDEX].detial[index]["item"].toString() + " ชิ้น ",
                                            style: GoogleFonts.sarabun(
                                              textStyle: Theme.of(context).textTheme.displayLarge,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      )),
                                      Container(
                                        width: 4,
                                        height: 60,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                          child: Container(
                                        alignment: AlignmentDirectional.centerStart,
                                        height: 50,
                                        color: Colors.white,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Container(
                                          alignment: AlignmentDirectional.center,
                                          child: Text(
                                            his_bills.get_all()[INDEX].detial[index]["price"] + " บาท ",
                                            style: GoogleFonts.sarabun(
                                              textStyle: Theme.of(context).textTheme.displayLarge,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      )),
                                      Container(
                                        width: 4,
                                        height: 60,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                          child: Container(
                                        alignment: AlignmentDirectional.centerStart,
                                        height: 50,
                                        color: Colors.white,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Container(
                                          alignment: AlignmentDirectional.center,
                                          child: Text(
                                            his_bills.get_all()[INDEX].detial[index]["price_all"] + " บาท ",
                                            style: GoogleFonts.sarabun(
                                              textStyle: Theme.of(context).textTheme.displayLarge,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      )),
                                      Container(
                                        width: 4,
                                        height: 60,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  // ใช้ข้อมูลจาก List ที่ index ได้แสดงผลใน ListTile
                                )
                              : Container(
                                  height: 10,
                                  color: Dark_threme.BG_shadow,
                                );
                        },
                      )),
                    );
                  },
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
