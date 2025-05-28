import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class tabbar extends StatefulWidget {
  const tabbar({super.key});

  @override
  State<tabbar> createState() => _tabbarState();
}

class _tabbarState extends State<tabbar> {
  @override
  void initState() {
    super.initState();
    final type_data_provider type_datas = Provider.of<type_data_provider>(context, listen: false);
    // Perform one-time initialization here
    Future.delayed(Duration(milliseconds: 100), () async {
      //   print("STATR");
      type_datas.info(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    bool all = true;
    return Consumer<type_data_provider>(builder: (context, type_datas, child) {
      return Container(
          height: 50,
          color: Colors.black26,
          child: Container(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    data_products.update_state_color(0);

                    type_datas.update_filter("");
                    data_products.info(context);
                  },
                  child: Container(
                    width: 120,
                    height: 40,
                    color: data_products.get_state_color() == 0 ? Colors.amberAccent : Dark_threme.BG,
                    margin: EdgeInsets.all(2),
                    child: Center(
                      child: Text(
                        systems.get_all()[0].language == "thai" ? thai_text().tab_all_product : eng_text().tab_all_product,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: data_products.get_state_color() == 0 ? Colors.black : Colors.white,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: AlignmentDirectional.center,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: type_datas.get_all().length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              data_products.update_state_color(index + 1);

                              type_datas.update_filter(type_datas.get_all()[index].type);
                              data_products.info(context);
                            },
                            child: Container(
                              height: 40,
                              color: data_products.get_state_color() == index + 1 ? Colors.amberAccent : Dark_threme.BG,
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Center(
                                child: Text(
                                  type_datas.get_all()[index].type,
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    color: data_products.get_state_color() == 1 ? Colors.black : Colors.white,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                )
              ],
            ),
          ));
    });
  }
}
