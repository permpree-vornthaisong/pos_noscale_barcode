import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/PAGE/activate/activate.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/cashier_login/cashier_login.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/main_page.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/setting_page.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/main_customer.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/his_bill/his_bills.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/lock_page/main_lock_page.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/printer/main_printer.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/main_product.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/stock/main_stock.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/system/main_system.dart';
import 'package:pos_noscale_barcode/start_page.dart';
import 'package:provider/provider.dart';

class page_manage extends StatefulWidget {
  const page_manage({super.key});

  @override
  State<page_manage> createState() => _page_manageState();
}

class _page_manageState extends State<page_manage> {
  @override
  void initState() {
    super.initState();
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);

    // Perform one-time initialization here
    Future.delayed(Duration(milliseconds: 100), () async {
      data_products.info(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> page = [
      start_page(),
      main_page(), SettingPage(),
      /////////
      main_system(), //3
      main_stock(),
      main_product()
      /////////
      ,
      MyDraggableWidget(),
      main_customer(),
      history_bill(),
      cashier_login(),
      main_active_page(),
      //10,
      MainLockPage() //11

      ,
      main_stock() // 12
    ]; //main_page
    return Container(
      child: Consumer<page_state_provider>(builder: (context, page_states, child) {
        return Container(
          alignment: AlignmentDirectional.center,
          child: Container(
            child: Consumer<page_state_provider>(
              builder: (context, pageStates, child) {
                int selectedTabIndex = page_states.get_all()[0].state;

                return page[selectedTabIndex];
              },
            ),
          ),
        );
      }),
    );
  }
}
