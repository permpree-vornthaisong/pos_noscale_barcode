import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_MODEL/system.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/%E0%B8%B4buttum.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/detail_product.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/excell_out.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/function.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/type_data.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class main_product extends StatefulWidget {
  const main_product({super.key});

  @override
  State<main_product> createState() => _main_productState();
}

class _main_productState extends State<main_product> {
  @override
  void initState() {
    super.initState();
    // Perform one-time initialization tasks here
    Future.delayed(Duration(seconds: 0), () async {
      final data_products = Provider.of<data_product_provider>(context, listen: false);
      final type_datas = Provider.of<type_data_provider>(context, listen: false);

      await data_products.reset_data(context);

      await type_datas.update_filter_setting("");
      await type_datas.update_filter("");
      await data_products.info_setting(context);
      await data_products.info(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final page_states = Provider.of<page_state_provider>(context, listen: false);
    final systems = Provider.of<system_provider>(context, listen: false);

    final localDatabase = LocalDatabase();

    return Row(
      children: [
        Expanded(
            flex: 16,
            child: Container(
              color: Dark_threme.BG_shadow,
              child: Column(
                children: [
                  Expanded(child: type_data()),
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
            child: Container(
              color: Dark_threme.BG,
              child: Column(
                children: [
                  Container(
                    height: 20,
                  ),
                  Expanded(
                      flex: 12,
                      child: Container(
                        color: Dark_threme.BG,
                        child: Row(children: [
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              final type_datas = Provider.of<type_data_provider>(context, listen: false);

                              if (type_datas.get_all().isNotEmpty) {
                                add_product(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('กรุณาเพิ่มชนิดสินค้า'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().product_add_one : eng_text().product_add_one),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //////////////////////////////////
                              // await localDatabase.deleteAllData();
                              delact_product(context);
                              //////////////////////////////////
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().product_clear : eng_text().product_clear),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final file_pickers = Provider.of<file_picker_excell>(context, listen: false);

                              file_pickers.pickExcelFile(context);
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().product_add_all : eng_text().product_add_all),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await EXCEL_product(context);
                              await outpicture_product(context);
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                    child: Text(
                                  (systems.get_all()[0].language == "thai" ? thai_text().product_output : eng_text().product_output),
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          //  buttom(),
                        ]),
                      )),
                  Expanded(flex: 80, child: detail_product()),
                ],
              ),
            )),
      ],
    );
  }
}
