import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:provider/provider.dart';

class detail_head_stock extends StatefulWidget {
  const detail_head_stock({super.key});

  @override
  State<detail_head_stock> createState() => _detail_head_stockState();
}

class _detail_head_stockState extends State<detail_head_stock> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      /*
        unix INTEGER NOT NULL,
    date_time TEXT NOT NULL,
    units TEXT NOT NULL,
    type TEXT NOT NULL,
    id TEXT NOT NULL,
    name TEXT NOT NULL,
    state TEXT NOT NULL,
    who TEXT NOT NULL,
    num REAL NOT NULL,
    other TEXT NOT NULL
      
      
      */
      Container(
        color: Color.fromARGB(255, 0, 0, 0),
        child: Container(
          margin: EdgeInsets.all(2),
          height: 40,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Center(
                      child: Text(
                        "date_time",
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
                  flex: 2,
                  child: Container(
                    child: Center(
                      child: Text(
                        "id",
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
              Expanded(
                  child: Container(
                child: Center(
                  child: Text(
                    "num",
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
                  flex: 2,
                  child: Container(
                    child: Center(
                      child: Text(
                        "state",
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
                  flex: 2,
                  child: Container(
                    child: Center(
                      child: Text(
                        "who",
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
              /* Expanded(
                  child: Container(
                child: Center(
                  child: Text(
                    "other",
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),*/
            ],
          ),
        ),
      ),
      Expanded(
        child: Consumer<stock_provider>(builder: (context, stocks, child) {
          return ListView.builder(
              itemCount: stocks.get_data().length,
              itemBuilder: (context, index) {
                return Container(
                  height: 40,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: Row(
                    children: [
                      /* Expanded(
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
            )),*/
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(1),
                            color: Colors.white,
                            child: Center(
                              child: Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    stocks.get_data()[index].data_time,
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
                              child: Container(
                                child: SingleChildScrollView(
                                  child: Text(
                                    stocks.get_data()[index].id,
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
                          child: Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                stocks.get_data()[index].name,
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
                          child: Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                stocks.get_data()[index].type,
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
                          child: Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                stocks.get_data()[index].units,
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
                          child: Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                stocks.get_data()[index].num.toString(),
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
                              child: Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    stocks.get_data()[index].state,
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
                              child: Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    stocks.get_data()[index].who,
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
                      /* Expanded(
                child: Container(
              child: Center(
                child: Text(
                  "other",
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            )),*/
                    ],
                  ),
                );
              });
        }),
      ),
    ]);
  }
}
