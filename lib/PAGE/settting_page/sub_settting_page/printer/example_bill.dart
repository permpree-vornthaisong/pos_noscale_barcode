import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:provider/provider.dart';

class example_bill extends StatefulWidget {
  const example_bill({super.key});

  @override
  State<example_bill> createState() => _example_billState();
}

class _example_billState extends State<example_bill> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1500,
      child: Consumer<edit_bill_provider>(
        builder: (context, edit_bills, child) {
          return Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.fromLTRB(55, 10, 55, 10),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 50,
                ),
                Visibility(
                  visible: edit_bills.get_all()[0].head,
                  child: Container(
                    margin: EdgeInsets.all(3),

                    height: 40,
                    // color: Colors.black12,
                    child: Center(
                      child: Text(
                        edit_bills.get_all()[0].HEADS,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: edit_bills.get_all()[0].name,
                  child: Container(
                    margin: EdgeInsets.all(3),

                    height: 40,
                    //  color: Colors.black12,
                    child: Center(
                      child: Text(
                        edit_bills.get_all()[0].NAMES,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: edit_bills.get_all()[0].tax,
                  child: Container(
                    margin: EdgeInsets.all(3),

                    height: 40,
                    //  color: Colors.black12,
                    child: Center(
                      child: Text(
                        "Tax#" + edit_bills.get_all()[0].TAXS,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                /* Container(
                  height: 20,
                  child: Text("-------------------------------------------------------------------------------------------------"),
                ),*/
                Container(
                  margin: EdgeInsets.all(3),
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "     มาม่า คัพ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        child: Text(
                          edit_bills.get_all()[0].form == "1"
                              ? "   @ 10.00*2.00        20.00 บ.     "
                              : edit_bills.get_all()[0].form == "2"
                                  ? "@ 10.00*2.00      20.00 B.     "
                                  : " ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "     สบู่",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        child: Text(
                          edit_bills.get_all()[0].form == "1"
                              ? "      40.00 บ.    "
                              : edit_bills.get_all()[0].form == "2"
                                  ? "      40.00 B.    "
                                  : " ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  height: 20,
                  child: Text("-------------------------------------------------------------------------------------------------"),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        height: 30,
                        child: Text(
                          edit_bills.get_all()[0].form == "1"
                              ? " จำนวนสินค้า 1 รายการ ( 3 ชิ้น)    "
                              : edit_bills.get_all()[0].form == "2"
                                  ? " 2 items of products ( 3 item)    "
                                  : " ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  height: 20,
                  child: Text("-------------------------------------------------------------------------------------------------"),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        height: 30,
                        child: Text(
                          edit_bills.get_all()[0].form == "1"
                              ? " ราคาสุทธิ                                                  30.00 บ.   "
                              : edit_bills.get_all()[0].form == "2"
                                  ? " Net                                                    30.00 B.   "
                                  : " ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        height: 30,
                        child: Text(
                          edit_bills.get_all()[0].form == "1"
                              ? " รับมา                                                  30.00 บ.   "
                              : edit_bills.get_all()[0].form == "2"
                                  ? " Received                                                    30.00 B.   "
                                  : " ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        height: 30,
                        child: Text(
                          edit_bills.get_all()[0].form == "1"
                              ? " ทอน                                                  30.00 บ.   "
                              : edit_bills.get_all()[0].form == "2"
                                  ? " Change                                                    30.00 B.   "
                                  : " ",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                /*  Container(
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        height: 30,
                        child: Text(
                          " billID :0000000000",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),*/
                /* Container(
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        height: 30,
                        child: Text(
                          " Cashier : hilo kun",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),*/
                Container(
                  margin: EdgeInsets.all(3),
                  height: 20,
                  child: Text("-------------------------------------------------------------------------------------------------"),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  height: 40,
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      " BillID:123456 : cahier: นายA",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  height: 40,
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      " 28/03/67 08:52:39",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                /* Visibility(
                    visible: edit_bills.get_all()[0].customer,
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              "ข้อมูลลูกค้า",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              "00000-ลูกค้า กอไก่",
                              style: GoogleFonts.sarabun(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),*/

                Visibility(
                    visible: edit_bills.get_all()[0].text1,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          edit_bills.get_all()[0].TEXT1S,
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    )),
                Expanded(child: Container())
              ],
            ),
          );
        },
      ),
    );
  }
}
