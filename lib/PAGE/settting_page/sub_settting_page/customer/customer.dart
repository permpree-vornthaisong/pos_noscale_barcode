import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/customer.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/dialog_delect.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:provider/provider.dart';

class customer_detail extends StatefulWidget {
  const customer_detail({super.key});

  @override
  State<customer_detail> createState() => _customer_detailState();
}

class _customer_detailState extends State<customer_detail> {
  @override
  Widget build(BuildContext context) {
    final systems = Provider.of<system_provider>(context, listen: false);

    return Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().customer_id : eng_text().customer_id),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().customer_name : eng_text().customer_name),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().customer_type : eng_text().customer_type),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      Expanded(
        child: Consumer<customer_provider>(
          builder: (context, customers, child) {
            return ListView.builder(
                itemCount: customers.get_customer_filtter().length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: () {
                      delect_customer(context, index);
                    },
                    onTap: () {
                      print("object");
                    },
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      child: Container(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                              height: 50,
                              child: Row(children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        customers.get_customer_filtter()[index].id,
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        customers.get_customer_filtter()[index].name,
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        customers.get_customer_filtter()[index].type,
                                        style: GoogleFonts.sarabun(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]))),
                    ),
                  );
                });
          },
        ),
      ),
    ]);
  }
}
