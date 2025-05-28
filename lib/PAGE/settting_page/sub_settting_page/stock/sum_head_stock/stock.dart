import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/stock/sum_head_stock/dialog_head_stock.dart';
import 'package:provider/provider.dart';

class sub_stock extends StatefulWidget {
  const sub_stock({super.key});

  @override
  State<sub_stock> createState() => _sub_stockState();
}

class _sub_stockState extends State<sub_stock> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Colors.black,
        child: Container(
          margin: EdgeInsets.all(2),
          height: 50,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Center(
                      child: Text(
                        "id",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 18,
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
                    child: Center(
                      child: Text(
                        "name",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  child: Container(
                child: Center(
                  child: Text(
                    "type",
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                child: Center(
                  child: Text(
                    "total",
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                child: Center(
                  child: Text(
                    "units",
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      Expanded(
        child: Consumer<stock_display_provider>(builder: (context, display_stocks, child) {
          return ListView.builder(
            itemCount: display_stocks.get_data().length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  dialog_head_stock(context, index);
                },
                child: Container(
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                  color: Colors.black,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.white,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: Text(
                                    display_stocks.get_data()[index].id,
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
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.white,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: Text(
                                    display_stocks.get_data()[index].name,
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
                            ),
                          )),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.all(1),
                        color: Colors.white,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Text(
                                display_stocks.get_data()[index].type,
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
                        ),
                      )),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.all(1),
                        color: Colors.white,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Text(
                                display_stocks.get_data()[index].sum.toString(),
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
                        ),
                      )),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.all(1),
                        color: Colors.white,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Text(
                                display_stocks.get_data()[index].units,
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
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    ]);
  }
}
