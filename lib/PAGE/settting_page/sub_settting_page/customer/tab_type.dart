import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/customer.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class tab_type_customer extends StatefulWidget {
  const tab_type_customer({super.key});

  @override
  State<tab_type_customer> createState() => _type_dataState();
}

class _type_dataState extends State<tab_type_customer> {
  @override
  Widget build(BuildContext context) {
    final systems = Provider.of<system_provider>(context, listen: false);

    return Consumer<customer_provider>(builder: (context, customers, child) {
      return SingleChildScrollView(
        child: Container(
            alignment: AlignmentDirectional.center,
            child: Column(children: [
              Container(
                height: 110,
              ),
              GestureDetector(
                onTap: () {
                  // final data_products = Provider.of<data_product_provider>(context, listen: false);
                  customers.update_filter_data("");
                  //  type_datas.update_filter_setting("");
                  // data_products.info_setting(context);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: customers.get_data_filter() == "" ? Colors.amber : const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Container(
                    child: Center(
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().customer_all : eng_text().customer_all),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 25,
                          fontWeight: customers.get_data_filter() == "" ? FontWeight.w500 : FontWeight.w300,
                          color: customers.get_data_filter() == "" ? Colors.black : Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  // color: Colors.black,
                  height: 480,
                  child: ListView.builder(
                    itemCount: customers.get_discount_customer().length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          final customers = Provider.of<customer_provider>(context, listen: false);

                          customers.update_filter_data(customers.get_discount_customer()[index].type);
                          // type_datas.update_filter_setting(type_datas.get_all()[index].type);
                          // data_products.info_setting(context);
                          /*ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('กดได้ทำไมไม่รี'),
                            ),
                          );*/
                        },
                        child: Container(
                            margin: EdgeInsets.all(5),
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: customers.get_data_filter() == customers.get_discount_customer()[index].type
                                  ? Colors.amber
                                  : const Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Center(
                              child: Container(
                                child: Text(
                                  customers.get_discount_customer()[index].type,
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: customers.get_data_filter() == customers.get_discount_customer()[index].type
                                        ? FontWeight.w500
                                        : FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            )),
                      );
                    },
                  )),
            ])),
      );
    });
  }
}
