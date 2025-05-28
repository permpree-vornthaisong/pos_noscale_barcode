import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_display.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_display_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class data_product_page extends StatefulWidget {
  const data_product_page({super.key});

  @override
  State<data_product_page> createState() => _data_productState();
}

class _data_productState extends State<data_product_page> {
  @override
  Widget build(BuildContext context) {
    return Consumer<data_product_provider>(builder: (context, data_products, child) {
      return Container(
          color: Dark_threme.Data_BG_shadow,
          alignment: AlignmentDirectional.center,
          child: Container(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // Number of columns
                crossAxisSpacing: 2.0, // Space between columns
                mainAxisSpacing: 2.0, // Space between rows
              ),
              itemCount: data_products.get_all().length,
              itemBuilder: (context, index) {
                return GridTile(
                  child: GestureDetector(
                    //data_display_provider
                    onTap: () {
                      final data_display_provider data_displays = Provider.of<data_display_provider>(context, listen: false);
                      final bill_provider bills = Provider.of<bill_provider>(context, listen: false);

                      // print(data_products.get_all()[index].unit);
                      if (data_products.get_all()[index].unit == "p") {
                        data_displays.update(data_display(
                            index: "index",
                            id: "id",
                            name: data_products.get_all()[index].name,
                            price: data_products.get_all()[index].price,
                            type: "type",
                            item: 1,
                            unit: "unit"));
                      } else if (data_products.get_all()[index].unit == "KG") {
                        data_displays.update(data_display(index: "index", id: "id", name: " ", price: "0.00", type: "type", item: 1, unit: "unit"));
                      } ///////
                      bills.add_data_pick_up(data_products.get_all()[index].id, context);
                    },
                    child: Container(
                      color: Colors.black38,
                      child: Stack(children: [
                        data_products.get_all()[index].picture == "-"
                            ? Container(
                                child: Center(
                                    child: Icon(
                                Icons.add_shopping_cart_sharp,
                                size: 40,
                                color: Colors.white,
                              )))
                            : Center(
                                child: Image.memory(
                                  base64Decode(data_products.get_all()[index].picture),
                                  width: 160, //  130
                                  height: 160, //  110
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Positioned(
                          bottom: 2,
                          child: Container(
                            color: Colors.black,
                            height: 30,
                            width: 165,
                            child: Row(
                              children: [
                                Expanded(
                                    child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    child: Text(
                                      " " + data_products.get_all()[index].name,
                                      style: GoogleFonts.sarabun(
                                        textStyle: Theme.of(context).textTheme.displayLarge,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                )),
                                Container(
                                  child: Text(
                                    "  " + data_products.get_all()[index].price + " ฿ ",
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                )
                              ],

                              /*
                           
                           Text(
                                  data_products.get_all()[index].price,
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                           
                           */
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ));
    });
  }
}
