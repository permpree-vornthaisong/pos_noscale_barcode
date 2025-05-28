import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/active.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/printter_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/inner_printter/inner_printter.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Scale_provider/main_scale_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/his_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/PAGE/activate/function.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/function/functiom_display.dart';
import 'package:provider/provider.dart';

class start_page extends StatefulWidget {
  const start_page({super.key});

  @override
  State<start_page> createState() => _start_pageState();
}

class _start_pageState extends State<start_page> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final page_state_provider page_states = Provider.of<page_state_provider>(context, listen: false);
      final system_provider systems = Provider.of<system_provider>(context, listen: false);
      final activate_provider activates = Provider.of<activate_provider>(context, listen: false);

      // await prepare_data();
      await Future.delayed(Duration(milliseconds: 1000), () async {});
      await prepare_data();

      if (!activates.get_data().active) {
        await page_states.update_state(10);
      } else {
        if (systems.get_all()[0].login_mode) {
          await page_states.update_state(9); // 9
        } else {
          await page_states.update_state(1);
        }
      }

      // Your code to be executed after the delay
    });
  }

  Future<void> prepare_data() async {
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    await systems.prepare_data(context);

    final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
    final cashier_provider cashiers = Provider.of<cashier_provider>(context, listen: false);
    final printerManager = Provider.of<PrinterManagerClass>(context, listen: false);

    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    final edit_bill_provider edit_bills = Provider.of<edit_bill_provider>(context, listen: false);
    final time_search_his_provider time_search_hiss = Provider.of<time_search_his_provider>(context, listen: false);
    final time_search_stock_provider time_search_stocks = Provider.of<time_search_stock_provider>(context, listen: false);

    final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false);

    final ScaleProvider Scales = Provider.of<ScaleProvider>(context, listen: false);
    final inner_printter_provider inner_printters = Provider.of<inner_printter_provider>(context, listen: false);
    final lock_page_provider lock_pages = Provider.of<lock_page_provider>(context, listen: false);
    final stock_display_provider stock_displays = Provider.of<stock_display_provider>(context, listen: false);
    final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
    final activate_provider activates = Provider.of<activate_provider>(context, listen: false);

    await activates.prepare_data();

    await lock_pages.reset_data();

    await data_products.reset_data(context);
    await customers.resset_customer(context);
    await customers.resset_discount_customer(context);
    await edit_bills.prepare_data(context);
    await cashiers.reset_data(context);
    await printerManager.set_data(context);
    await time_search_hiss.NOW_TIME();
    await time_search_stocks.NOW_TIME();
    await Scales.initialize(context);
    await inner_printters.initialize(context);
    await his_bills.getdata(context);
    // await senddata_display("page0");

    await stock_displays.reset_data();
    await stock_displays.reset_type_data();

    await stock_displays.reset_data();
    await stocks.reset_type_data();
    await stocks.reset_id_data();

    await stocks.reset_data(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/LOGO.png',
        width: 500,
      ),
    );
  }
}
