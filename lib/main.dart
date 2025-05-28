import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_noscale_barcode/A_MODEL/active.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/inner_printter/inner_printter.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Scale_provider/main_scale_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_display_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_scanner_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/filter_numname_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/his_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/printter_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/tab_timer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/threme_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/PAGE/activate/function.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/customer/customer_type.dart';
import 'package:pos_noscale_barcode/PAGE/page_management.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/customer/function.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/drop_down_type.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/function.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => threme_state_provider()), //page_state_provider
        ChangeNotifierProvider(create: (_) => page_state_provider()), //data_product_provider
        ChangeNotifierProvider(create: (_) => data_product_provider()), //data_scanner_provider
        ChangeNotifierProvider(create: (_) => data_scanner_provider()), //data_display_provider
        ChangeNotifierProvider(create: (_) => data_display_provider()), //scanner_state_provider
        ChangeNotifierProvider(create: (_) => scanner_state_provider()), //type_data_provider
        ChangeNotifierProvider(create: (_) => type_data_provider()),
        ChangeNotifierProvider(create: (_) => bill_provider()),
        ChangeNotifierProvider(create: (_) => filter_num_name_provider()), //TabTimerProvider
        ChangeNotifierProvider(create: (_) => TabTimerProvider()), // bill_provider //file_picker_excell
        ChangeNotifierProvider(create: (_) => file_picker_excell()), //MyDataProvider  file_picker_excell_customer
        ChangeNotifierProvider(create: (_) => file_picker_excell_customer()),
        ChangeNotifierProvider(create: (_) => edit_bill_provider()), //customer_provider
        ChangeNotifierProvider(create: (_) => customer_provider()),
        ChangeNotifierProvider(create: (_) => cashier_provider()), // //DropdownProvider
        ChangeNotifierProvider(create: (_) => system_provider()), //his_bill_provider
        ChangeNotifierProvider(create: (_) => his_bill_provider()), //time_search_his_provider
        ChangeNotifierProvider(create: (_) => time_search_his_provider()),

        ChangeNotifierProvider(create: (_) => PrinterManagerClass()),

        ///activate_provider
        ChangeNotifierProvider(create: (_) => activate_provider()),

        ChangeNotifierProvider(create: (_) => ScaleProvider()),
        ChangeNotifierProvider(create: (_) => inner_printter_provider()),

        ChangeNotifierProvider(create: (_) => lock_page_provider()),
        ChangeNotifierProvider(create: (_) => stock_provider()),
        ChangeNotifierProvider(create: (_) => stock_display_provider()),
        ChangeNotifierProvider(create: (_) => time_search_stock_provider()),
        ChangeNotifierProvider(create: (_) => activate_provider()),

        //////////////////////////////////////////////////////////////
      ],
      child: MaterialApp(
        title: '',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            _onWillPop(context);
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Consumer2<threme_state_provider, system_provider>(
                  builder: (context, threme_states, systems, child) {
                    return Container(
                      alignment: AlignmentDirectional.center,
                      child: Container(
                        child: page_manage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // Implement your logic here
    // For example, show a dialog and return false to prevent exiting
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you really want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
        ],
      ),
    );

    // Return false to prevent exiting immediately
    return false;
  }
}
