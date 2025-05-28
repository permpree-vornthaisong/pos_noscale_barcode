import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/printter_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/inner_printter/inner_printter.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/his_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/function/function_print_db.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/money_pay.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/tabbar_type/prompt_pay.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class bill extends StatefulWidget {
  const bill({super.key});

  @override
  State<bill> createState() => _billState();
}

class _billState extends State<bill> {
  late ScrollController _scrollController;
  bool printting = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time_search_stock_provider time_search_stock = Provider.of<time_search_stock_provider>(context, listen: false);

    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    final bill_provider bills = Provider.of<bill_provider>(context, listen: false); //data_scanner_provider
    final customer_provider customers = Provider.of<customer_provider>(context, listen: false); //data_scanner_provider
    final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false); //data_scanner_provider
    final PrinterManagerClass PrinterManager = Provider.of<PrinterManagerClass>(context, listen: false); //data_scanner_provider
    final inner_printter_provider inner_printters = Provider.of<inner_printter_provider>(context, listen: false); //data_scanner_provider

    int T_item_all = 0;
    double T_sum_money = 0.00;
    double T_pay_back = 0.00;
    double T_pay_money = 0.00;
    return Column(children: [
      Expanded(
        child: Consumer<bill_provider>(builder: (context, bills, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
          return Container(
              alignment: AlignmentDirectional.center,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: bills.get_all().length,
                itemBuilder: (context, index) {
                  //  int GG = bills.get_all().length - 1;

                  double total_bill = double.parse(bills.get_all()[index].price) * bills.get_all()[index].item;

                  if (bills.get_all()[index].unit == "KG") {
                    total_bill = double.parse(bills.get_all()[index].price) * double.parse(bills.get_all()[index].weight);
                  } else {
                    total_bill = double.parse(bills.get_all()[index].price) * bills.get_all()[index].item;
                  }
                  return GestureDetector(
                    onDoubleTap: () {
                      bills.removeDataAtIndex(index);
                    },
                    onTap: () {
                      showdialog_change_price(context, index);
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0.5, 0, 0.5),
                      height: 45,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: Text(
                              (index + 1).toString() + ".",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 15,
                            child: Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: Text(
                                    bills.get_all()[index].name,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 22,
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
                            flex: 18,
                            child: Container(
                              // alignment: AlignmentDirectional.center,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: Text(
                                    bills.get_all()[index].unit == "KG"
                                        ? "  " + bills.get_all()[index].price + "*" + bills.get_all()[index].weight + " kg "
                                        : "  " + bills.get_all()[index].price + "*" + bills.get_all()[index].item.toString() + " p ",
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 22,
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
                            flex: 20,
                            child: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Text(
                                total_bill.toStringAsFixed(2) + "  บาท  ",
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // You can add more details or customize the ListTile as needed
                    ),
                  );
                },
              ));
        }),
      ),
      Container(child: Consumer3<bill_provider, customer_provider, system_provider>(builder: (context, bills, customers, systems, child) {
        int item_all = 0;
        double sum_money = 0.00;
        double sum_money_t = 0.00;
        double vat = 0.00;
        double sum_money_before_vat = 0.00;
        double discount = 0.00;

        double pay_back = 0.00;
        double pay_money = 0.00;

        // KGp

        if (bills.get_all().isNotEmpty) {
          for (int i = 0; i < bills.get_all().length; i++) {
            item_all = item_all + bills.get_all()[i].item;
            if (bills.get_all()[i].unit == "KG") {
              sum_money = sum_money + double.parse(bills.get_all()[i].price) * double.parse(bills.get_all()[i].weight);
            } else {
              sum_money = sum_money + double.parse(bills.get_all()[i].price) * bills.get_all()[i].item;
            }

            sum_money_t = sum_money; ////****** */

            //  print(sum_money);
            // print(item_all);
          }
          if (systems.get_all()[0].discount_mode) {
            discount = (sum_money * customers.get_discount_form_type(customers.get_display_type()) / 100);
          }

          sum_money_before_vat = sum_money - discount;

          if (systems.get_all()[0].vat_mode) {
            vat = (sum_money_before_vat * double.parse(systems.get_all()[0].vat) / 100);
          }

          sum_money = sum_money_before_vat + vat;
        }
        pay_money = double.parse(bills.Pay_money());
        pay_back = double.parse(bills.Pay_money()) - sum_money;

        if (bills.Qrcode_state()) {
          pay_back = 0.00;
          pay_money = sum_money;
        }

        T_item_all = item_all;
        T_sum_money = sum_money;
        T_pay_back = pay_back;
        T_pay_money = pay_money;

        return Container(
            height: systems.get_all()[0].vat_mode ? 176 : 132,
            color: Colors.white,
            alignment: AlignmentDirectional.center,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.black,
                            height: 42,
                            width: double.infinity,
                            child: GestureDetector(
                              onDoubleTap: () {
                                bills.removeDataAll();
                              },
                              child: Container(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  systems.get_all()[0].language == "thai" ? thai_text().bill_all : eng_text().bill_all,
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: systems.get_all()[0].vat_mode,
                              child: Container(
                                margin: EdgeInsets.all(1),
                                color: Colors.black,
                                height: 42,
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  systems.get_all()[0].language == "thai"
                                      ? thai_text().bill_vat
                                      : eng_text().bill_vat + systems.get_all()[0].vat + "%",
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              )),
                          Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.black,
                            height: 42,
                            width: double.infinity,
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                bills.get_all().length.toString() +
                                    (systems.get_all()[0].language == "thai" ? thai_text().bill_list : eng_text().bill_list),
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300,
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.black,
                            height: 42,
                            width: double.infinity,
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                item_all.toStringAsFixed(0) +
                                    (systems.get_all()[0].language == "thai" ? thai_text().bill_item : eng_text().bill_item),
                                style: GoogleFonts.sarabun(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300,
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.black,
                            height: 42,
                            width: double.infinity,
                            child: Row(children: [
                              Container(
                                child: Text(
                                  "",
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    sum_money_t.toStringAsFixed(2) +
                                        "  >>  " +
                                        sum_money_before_vat.toStringAsFixed(2) +
                                        " " +
                                        (systems.get_all()[0].language == "thai" ? thai_text().tab_unit_monney : eng_text().tab_unit_monney),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Visibility(
                              visible: systems.get_all()[0].vat_mode,
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.all(1),
                                color: Colors.black,
                                height: 42,
                                width: double.infinity,
                                child: Text(
                                  vat.toStringAsFixed(2) +
                                      "  >>  " +
                                      sum_money.toStringAsFixed(2) +
                                      " " +
                                      (systems.get_all()[0].language == "thai" ? thai_text().tab_unit_monney : eng_text().tab_unit_monney),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.black,
                            height: 42,
                            width: double.infinity,
                            child: Row(children: [
                              Container(
                                child: Text(
                                  " " + (systems.get_all()[0].language == "thai" ? thai_text().bill_received : eng_text().bill_received),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    pay_money.toStringAsFixed(2) +
                                        " " +
                                        (systems.get_all()[0].language == "thai" ? thai_text().tab_unit_monney : eng_text().tab_unit_monney),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.black,
                            height: 42,
                            width: double.infinity,
                            child: Row(children: [
                              Container(
                                child: Text(
                                  " " + (systems.get_all()[0].language == "thai" ? thai_text().bill_Change : eng_text().bill_Change),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    pay_back.toStringAsFixed(2) +
                                        " " +
                                        (systems.get_all()[0].language == "thai" ? thai_text().tab_unit_monney : eng_text().tab_unit_monney),
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ))
                ],
              ),
            ));
      })),
      /* Container(
        color: Colors.black,
        height: 60,
        child: money_pay(),
      ),*/
      Container(
        height: 100,
        child: Container(
          color: Dark_threme.BG,
          child: Row(children: [
            Expanded(
                child: Container(
                    color: Dark_threme.BG_shadow,
                    margin: EdgeInsets.all(5),
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final bill_provider bills = Provider.of<bill_provider>(context, listen: false);

                                bills.update_Qrcode_state(false);
                                bills.update_Money_state(true);
                                bills.update_pay_money("0.00");
                                await pay_money(context);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                color: Colors.black,
                                child: Icon(
                                  Icons.attach_money_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                prompt_pay(context, T_sum_money);
                                final bill_provider bills = Provider.of<bill_provider>(context, listen: false);
                                bills.update_Qrcode_state(true);
                                bills.update_Money_state(false);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                color: Colors.black,
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))),
            Expanded(
              child: Container(
                color: Dark_threme.BG_shadow,
                margin: EdgeInsets.all(2),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
                      final stock_display_provider stock_displays = Provider.of<stock_display_provider>(context, listen: false);
                      bool STATE_PRINT = true;
                      //await printter(context);

                      if (!printting) {
                        setState(() {
                          printting = true;
                        });
                        if (systems.get_all()[0].printter == "external") {
                          await PrinterManager.printTestTicket(context);
                        } else if (systems.get_all()[0].printter == "internal") {
                          await inner_printters.send_data(context);
                        }

                        //print();
                        if (STATE_PRINT) {
                          final localDatabase = LocalDatabase();

                          int INDEX = await localDatabase.readall_index_bill();

                          await localDatabase.updatedata_index_bill(INDEXS: INDEX + 1);
                          await his_bills.save_bills(context);

                          for (int i = 0; i < bills.get_all().length; i++) {
                            double DATA_stock =
                                bills.get_all()[i].unit == "KG" ? double.parse(bills.get_all()[i].weight) : bills.get_all()[i].item.toDouble();
                            await localDatabase.add_Stock(
                                unix: time_search_stock.getUnixNow(),
                                date_time: time_search_stock.getFormattedTimeNow(),
                                units: bills.get_all()[i].unit,
                                id: bills.get_all()[i].id,
                                type: bills.get_all()[i].type,
                                name: bills.get_all()[i].name,
                                state: "confirm/bill ${INDEX + 1}",
                                who: systems.get_all()[0].cashier,
                                num: -DATA_stock,
                                other: "-");
                          }

                          await stock_displays.reset_data();
                          await stock_displays.reset_type_data();

                          await stock_displays.reset_data();
                          await stocks.reset_type_data();
                          await stocks.reset_id_data();

                          await stocks.reset_data(context);

                          ///  await his_bills.read_his_bill();
                          await bills.update_Money_state(false);
                          await bills.update_Qrcode_state(false);

                          ////////////////////////////////////
                          await bills.removeDataAll();

                          //await customers.update_display_type(customers.get_discount_customer()[0].type);

                          await customers.update_display_name("----");
                          await customers.update_display_id("----");
                          await customers.update_display_type("----");
                          await bills.update_pay_money("0.00");

                          await Future.delayed(Duration(seconds: 1));
                          // print("sdfsdfsdfsdf9");

                          setState(() {
                            printting = false;
                          });
                        }
                      }
                    },
                    child: Container(
                        height: 100,
                        color: printting ? Colors.green : Colors.black,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Center(
                          child: Text(
                            printting
                                ? (systems.get_all()[0].language == "thai" ? "กำลังพิมพ์.." : "printing..")
                                : (systems.get_all()[0].language == "thai" ? thai_text().bill_save_print : eng_text().bill_save_print),
                            style: GoogleFonts.sarabun(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ]),
        ),
      )
    ]);
  }

  void showdialog_change_price(BuildContext context, int index) {
    // Create a TextEditingController
    TextEditingController textController = TextEditingController();

    final bills = Provider.of<bill_provider>(context, listen: false);

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
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "เปลี่ยน ราคา",
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
                  margin: EdgeInsets.fromLTRB(40, 10, 10, 10),
                  child: Row(children: [
                    Text(
                      "ราคาเดิม   " + bills.get_all()[index].price + " บ.",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Expanded(child: Container())
                  ]),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 20, 20, 40),
                  child: Row(children: [
                    Text(
                      "ราคาใหม่  ",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: textController,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '',
                        ),
                        keyboardType: TextInputType.number, // Numeric keyboard
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Center(
                      child: GestureDetector(
                    onTap: () {
                      if (textController.text.isNotEmpty) {
                        bills.update_bill_price(index, textController.text);
                        Navigator.pop(context); // Just close the dialog
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
}
