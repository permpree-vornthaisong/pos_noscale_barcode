import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/function.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class type_data extends StatefulWidget {
  const type_data({super.key});

  @override
  State<type_data> createState() => _type_dataState();
}

class _type_dataState extends State<type_data> {
  @override
  Widget build(BuildContext context) {
    final systems = Provider.of<system_provider>(context, listen: false);

    return Consumer2<type_data_provider, data_product_provider>(builder: (context, type_datas, DD, child) {
      return SingleChildScrollView(
        child: Container(
            alignment: AlignmentDirectional.center,
            child: Column(children: [
              Container(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  add_typef(context);
                },
                child: Container(
                  height: 50,
                  // width: 20,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 50,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  final data_products = Provider.of<data_product_provider>(context, listen: false);

                  type_datas.update_filter_setting("");
                  data_products.info_setting(context);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: type_datas.DATA_INDEX_setting() == "" ? Colors.amber : Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Container(
                    child: Center(
                      child: Text(
                        (systems.get_all()[0].language == "thai" ? thai_text().product_all : eng_text().product_all),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),
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
                    itemCount: type_datas.get_all().length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () {
                          _delect_type(context, type_datas.get_all()[index].type);
                        },
                        onTap: () {
                          final data_products = Provider.of<data_product_provider>(context, listen: false);

                          type_datas.update_filter_setting(type_datas.get_all()[index].type);
                          data_products.info_setting(context);
                        },
                        child: Container(
                            margin: EdgeInsets.all(5),
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: type_datas.DATA_INDEX_setting() == type_datas.get_all()[index].type
                                  ? Colors.amber
                                  : Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Center(
                              child: Container(
                                child: Text(
                                  type_datas.get_all()[index].type,
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
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

  void _delect_type(context, String data) {
    final data_products = Provider.of<data_product_provider>(context, listen: false);
    final type_datas = Provider.of<type_data_provider>(context, listen: false);

    final systems = Provider.of<system_provider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 300,
            height: 200,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  child: Center(
                    child: Text(
                      (systems.get_all()[0].language == "thai" ? thai_text().product_clear_type : eng_text().product_clear_type),
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          //print(data);
                          await data_products.delect_type(context, data);
                          await data_products.reset_data(context);
                          await data_products.info(context);
                          await data_products.info_setting(context);
                          await type_datas.info(context);
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Container(
                                color: Colors.amber,
                                width: 200,
                                height: 80,
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().product_clear_submit : eng_text().product_clear_submit),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )))))),
              ],
            ),
          ),
        );
      },
    );
  }
}
