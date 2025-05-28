import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class delect_all_product extends StatefulWidget {
  const delect_all_product({super.key});

  @override
  State<delect_all_product> createState() => _delect_all_productState();
}

class _delect_all_productState extends State<delect_all_product> {
  @override
  Widget build(BuildContext context) {
    final localDatabase = LocalDatabase();
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    final type_data_provider type_datas = Provider.of<type_data_provider>(context, listen: false);
    return Container(
      width: 500,
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(child: Container()),
          Container(
            alignment: AlignmentDirectional.center,
            child: Text(
              "การลบข้อมูลทั้งหมดไม่มาสามารถกู้คืนได้ท่านจะลบหรือไม่",
              style: GoogleFonts.sarabun(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 0, 0, 0),
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await localDatabase.deleteAllData();
                      // await Future.delayed(Duration(seconds: 1));

                      await data_products.reset_data(context);
                      await data_products.clear_all_data();

                      await data_products.info(context);
                      await data_products.info_setting(context);
                      await type_datas.info(context);
                      await ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("ลบข้อมูลสำเร็จ"),
                        ),
                      );
                      await Future.delayed(Duration(seconds: 1));

                      // Navigate to a new screen
                      Navigator.pop(context);
                      // Navigate to a new screen
                    },
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.all(5),
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "ยืนยัน",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.all(5),
                      color: Colors.amber,
                      child: Center(
                        child: Text(
                          "ยกเลิก",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
