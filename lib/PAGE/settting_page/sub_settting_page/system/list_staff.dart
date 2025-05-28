import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:provider/provider.dart';

class list_staff extends StatefulWidget {
  const list_staff({super.key});

  @override
  State<list_staff> createState() => _list_staffState();
}

class _list_staffState extends State<list_staff> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(50),
      height: 400,
      color: Colors.grey[300],
      child: Column(children: [
        Container(
          height: 60,
          color: Colors.black87,
          child: Row(
            children: [
              Container(
                width: 80,
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    "ลำดับ",
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                child: Center(
                  child: Text(
                    "ยศ",
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                      child: Container(
                child: Center(
                  child: Text(
                    "ชื่อ",
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ))),
            ],
          ),
        ),
        Expanded(
          child: Consumer<cashier_provider>(builder: (context, cashiers, child) {
            return ListView.builder(
                itemCount: cashiers.get_data().length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 60,
                    width: 80,
                    color: index % 2 == 0 ? Colors.black54 : Colors.black45,
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          margin: EdgeInsets.all(5),
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: Center(
                            child: Text(
                              cashiers.get_data()[index].role,
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Container(
                                child: Container(
                          child: Center(
                            child: Text(
                              cashiers.get_data()[index].name,
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ))),
                      ],
                    ),
                  );
                });
          }),
        ),
      ]),
    );
  }
}
