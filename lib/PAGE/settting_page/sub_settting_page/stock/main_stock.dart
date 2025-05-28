import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/stock/detail_head_stock/detail_head_stock.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/stock/detail_head_stock/head_detial_stock.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/stock/sum_head_stock/head_stock.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/stock/sum_head_stock/stock.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class main_stock extends StatefulWidget {
  const main_stock({super.key});

  @override
  State<main_stock> createState() => _main_stockState();
}

class _main_stockState extends State<main_stock> {
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();

      // ใช้ Future.delayed เพื่อหน่วงเวลาในการทำงานบางอย่าง
      Future.delayed(Duration(milliseconds: 0), () async {
        // งานที่ต้องการทำหลังจากที่ widget ถูกสร้างขึ้น
        // _performDelayedTask();
        final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
        final stock_display_provider stock_displays = Provider.of<stock_display_provider>(context, listen: false);

        await stock_displays.reset_data();
        await stock_displays.reset_type_data();

        await stock_displays.reset_data();
        await stocks.reset_type_data();
        await stocks.reset_id_data();

        await stocks.reset_data(context);
      });
    }

    return Column(
      children: [
        Expanded(
            child: Container(
          color: Colors.black,
        )),
        Expanded(
            flex: 20,
            child: Container(
                child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(2),
                                //   color: Colors.black,
                                child: HeadSubStock(),
                              )),
                          Expanded(
                              flex: 5,
                              child: Container(
                                color: const Color.fromARGB(115, 82, 67, 67),
                                child: sub_stock(),
                              ))
                        ],
                      ),
                    )),
                Container(
                  width: 5,
                  color: Colors.black,
                ),
                Expanded(
                    flex: 8,
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                              flex: 40,
                              child: Container(
                                color: Dark_threme.BG_shadow,
                                child: Transform.scale(scale: 1, child: head_detial_stock()),
                              )),
                          Expanded(
                              flex: 78,
                              child: Container(
                                color: Colors.black,
                                child: detail_head_stock(),
                              ))
                        ],
                      ),
                    ))
              ],
            ))),
        Container(
            height: 60,
            child: Container(
              color: Dark_threme.BG_shadow,
              child: Row(
                children: [
                  Container(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          final page_states = Provider.of<page_state_provider>(context, listen: false);

                          page_states.update_state(2);
                        },
                        child: Container(
                          height: 50,
                          width: 160,
                          color: Colors.black,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container())
                ],
              ),
            )),
      ],
    );
  }
}
