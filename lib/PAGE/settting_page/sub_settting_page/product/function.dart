import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/showdialog_component/add_product.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/showdialog_component/add_type.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/showdialog_component/delect_all_product.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/system/function.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class file_picker_excell with ChangeNotifier {
  String PATH = "";

  Future<void> pickExcelFile(context) async {
    await requestStoragePermission();

    readExcel(context);
  }

  Future<void> readExcel(context) async {
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    final type_data_provider type_datas = Provider.of<type_data_provider>(context, listen: false);

    final localDatabase = LocalDatabase();

    var file;

    try {
      Directory directory2 = Directory('/storage/');
      List<FileSystemEntity> contents = directory2.listSync();

      if (contents.isNotEmpty) {
        Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/input');

        String imagePath = path.join(directory.path, 'product.xlsx');

        file = Excel.decodeBytes(File(imagePath).readAsBytesSync());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ไม่พบไฟล์ในไดเรกทอรี'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
        ),
      );
    }

    for (var table in file.tables.keys) {
      var rows = file.tables[table]!.rows;

      // Start the loop from index 1 to skip the first row
      for (var i = 1; i < rows.length; i++) {
        await Future.delayed(Duration(milliseconds: 20), () {});

        var row = rows[i];
        bool state = false;
        // Access the cells in the row using an index
        /*  print(row[0]!.value);
        print(row[3]!.value);*/

        // String ID = (row[0]!.value.toString()).substring(2, 6);
        String ID = (row[0]!.value.toString());

        for (int j = 0; j < data_products.get_all_nofilter().length; j++) {
          //   if (row[0]!.value.toString().isNotEmpty) {
          // ID = (row[0]!.value.toString()).substring(2, 6);
          ID = (row[0]!.value.toString());
          print("ID PRODUCT");
          print(ID);

          if (ID == data_products.get_all_nofilter()[j].id) {
            state = true;

            break;
          }
          //  }
        }

        if (state) {
          try {
            Directory directory2 = Directory('/storage/');
            List<FileSystemEntity> contents = directory2.listSync();

            if (contents.isNotEmpty) {
              Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/input/Img');

              String imagePath = path.join(directory.path, '${row[1]!.value.toString()}.jpg');
              List<int> imageBytes = await File(imagePath).readAsBytes();
              String base64Image = base64Encode(imageBytes);

              await localDatabase.updatedata_all_product(
                  id: ID,
                  name: row[1]!.value.toString() ?? '',
                  price: double.parse(row[2]!.value.toString()).toStringAsFixed(2) ?? '0.00',
                  picture: base64Image,
                  units: row[3]!.value.toString() ?? 'p',
                  type: row[4]!.value.toString() ?? 'Default Value',
                  other: row[5]!.value.toString() ?? '',
                  state: "",
                  weight: "0");

              await data_products.reset_data(context);
              await data_products.info(context);
              await data_products.info_setting(context);
              await type_datas.info(context);
              /*  Future.delayed(Duration(milliseconds: 500), () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            });*/
              /* ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('มี id เจอภาพ'),
                ),
              );*/
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ไม่พบไฟล์ในไดเรกทอรี'),
                ),
              );
            }
          } catch (e) {
            print(e);
            await localDatabase.updatedata_all_product(
                id: ID,
                name: row[1]!.value.toString() ?? '',
                price: double.parse(row[2]!.value.toString()).toStringAsFixed(2) ?? '0.00',
                picture: "-",
                units: row[3]!.value.toString() ?? 'p',
                type: row[4]!.value.toString() ?? 'Default Value',
                other: row[5]!.value.toString() ?? '',
                state: "",
                weight: "0");
            await data_products.reset_data(context);
            await data_products.info(context);
            await data_products.info_setting(context);
            await type_datas.info(context);
            /* Future.delayed(Duration(milliseconds: 500), () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            });*/
            /*  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('มี id ไม่เจอภาพ'),
              ),
            );*/
          }
        } else {
          try {
            Directory directory2 = Directory('/storage/');
            List<FileSystemEntity> contents = directory2.listSync();

            if (contents.isNotEmpty) {
              Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/input/Img');

              String imagePath = path.join(directory.path, '${row[1]!.value.toString()}.jpg');

              /*  
            
            Directory directory = Directory('/storage/emulated/0/Download/POS_APP/input/Img');
            String imagePath = path.join(directory.path, '${row[1]!.value.toString()}.jpg');*/
              List<int> imageBytes = await File(imagePath).readAsBytes();
              String base64Image = base64Encode(imageBytes);

              await localDatabase.adddata_all_product(
                  id: ID,
                  name: row[1]!.value.toString() ?? '',
                  price: double.parse(row[2]!.value.toString()).toStringAsFixed(2) ?? '0.00',
                  picture: base64Image,
                  units: row[3]!.value.toString() ?? 'p',
                  type: row[4]!.value.toString() ?? 'Default Value',
                  other: row[5]!.value.toString() ?? '',
                  state: "",
                  weight: "0",
                  context: context);
              await data_products.reset_data(context);
              await data_products.info(context);
              await data_products.info_setting(context);
              await type_datas.info(context);
              /* Future.delayed(Duration(milliseconds: 500), () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            });*/
              /* ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ไม่มี id เจอภาพ'),
              ),
            );*/
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ไม่พบไฟล์ในไดเรกทอรี'),
                ),
              );
            }
          } catch (e) {
            await localDatabase.adddata_all_product(
                id: ID,
                name: row[1]!.value.toString() ?? '',
                price: double.parse(row[2]!.value.toString()).toStringAsFixed(2) ?? '0.00',
                picture: "-",
                units: row[3]!.value.toString() ?? 'p',
                type: row[4]!.value.toString() ?? 'Default Value',
                other: row[5]!.value.toString() ?? '',
                state: "",
                weight: "0",
                context: context);
            await data_products.reset_data(context);
            await data_products.info(context);
            await data_products.info_setting(context);
            await type_datas.info(context);
            /*Future.delayed(Duration(milliseconds: 500), () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            });*/
            /*  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ไม่มี id ไม่เจอภาพ'),
              ),
            );*/
          }
        }
      }
      // ล่าช้าเป็นเวลา 3 วินาที
      //  await Future.delayed(Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("นำเข้าสำเร็จ"),
        ),
      );
    }
  }

  Future<void> requestStoragePermission() async {
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        // ได้รับอนุญาต
        print('Storage permission granted.');
      } else {
        // ไม่ได้รับอนุญาต
        print('Storage permission denied.');
      }
    } catch (e) {
      print('Error requesting storage permission: $e');
    }
  }
}

void delact_product(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: delect_all_product(),
      );
    },
  );
}

void add_product(context) {
  showDialog(
    context: context, barrierDismissible: false, // User cannot dismiss by tapping outside

    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ADD(),
      );
    },
  );
}

void add_typef(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: add_type(),
      );
    },
  );
}

Future<void> add_type_sqlite(context, String type) async {
  final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
  final type_data_provider type_datas = Provider.of<type_data_provider>(context, listen: false);
  final localDatabase = LocalDatabase();

  await requestStoragePermission();
  await localDatabase.adddata_all_product(
      id: "99999", name: "-", price: "-", picture: "-", units: "-", type: type, other: "-", state: "", weight: "0", context: context);
  await data_products.reset_data(context);
  await data_products.info(context);
  await data_products.info_setting(context);
  await type_datas.info(context);
  Navigator.pop(context); // Close the dialog
}

Future<void> add_product_sqlite(context, String id, String name, String price, String other, String type, bool KG, bool p) async {
  final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
  final type_data_provider type_datas = Provider.of<type_data_provider>(context, listen: false);

  final time_search_his_provider time_search_hiss = Provider.of<time_search_his_provider>(context, listen: false);
  final system_provider systems = Provider.of<system_provider>(context, listen: false);

  bool state = false;
  final localDatabase = LocalDatabase();

  await requestStoragePermission();

  try {
    // Check if id, name, type, and other are not null or empty
    if (id == null || id.isEmpty || name == null || name.isEmpty || type == null || type.isEmpty) {
      throw Exception('Invalid input. Please provide values for id, name, type, and other.');
    }

    // Check if price is a valid numeric value
    double parsedPrice = double.parse(price ?? '');
    if (parsedPrice == null) {
      throw Exception('Invalid price. Please provide a valid numeric value.');
    }

    Directory directory2 = Directory('/storage/');
    List<FileSystemEntity> contents = directory2.listSync();

    if (contents[0].toString() != "emulated") {
      Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/input/Img');

      String imagePath = path.join(directory.path, '${name}.jpg');

      /*

    Directory directory = Directory('/storage/emulated/0/Download/POS_APP/input/Img');
    String imagePath = path.join(directory.path, '${name}.jpg');*/
      // Read image bytes
      List<int> imageBytes = await File(imagePath).readAsBytes();
      String base64Image = base64Encode(imageBytes);

      String UNITS = "p";

      if (KG) {
        UNITS = "KG";
      } else if (p) {
        UNITS = "p";
      }

      // print(UNITS);
      await localDatabase.adddata_all_product(
          id: id,
          name: name,
          price: price,
          picture: base64Image,
          units: UNITS,
          type: type,
          other: other ?? '-',
          state: "",
          weight: "0",
          context: context);
      await localDatabase.add_Stock(
          unix: time_search_hiss.getUnixNow(),
          date_time: time_search_hiss.getFormattedTimeNow(),
          units: UNITS,
          id: id,
          type: type,
          name: name,
          state: "add product",
          who: systems.get_all()[0].cashier,
          num: 0,
          other: other);

      await data_products.reset_data(context);
      await data_products.info(context);
      await data_products.info_setting(context);
      await type_datas.info(context);
      state = true;
      await Future.delayed(Duration(seconds: 1));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่พบไฟล์ในไดเรกทอรี'),
        ),
      );
    }

    // Navigate to a new screen
    //  Navigator.pop(context);
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ไม่พบรูป ใน flash drive '),
      ),
    );
  }
  try {
    if (state == false) {
      //   Directory directory = Directory(path.join('/storage/emulated/0/Download', 'img'));

      Directory directory = Directory('/storage/emulated/0/Download'); //Img

      String imagePath = path.join(directory.path, '${name}.jpg');

      List<int> imageBytes = await File(imagePath).readAsBytes();
      String base64Image = base64Encode(imageBytes);

      String UNITS = "p";

      if (KG) {
        UNITS = "KG";
      } else if (p) {
        UNITS = "p";
      }

      // print(UNITS);
      await localDatabase.adddata_all_product(
          id: id,
          name: name,
          price: price,
          picture: base64Image,
          units: UNITS,
          type: type,
          other: other ?? '-',
          state: "",
          weight: "0",
          context: context);
      await localDatabase.add_Stock(
          unix: time_search_hiss.getUnixNow(),
          date_time: time_search_hiss.getFormattedTimeNow(),
          units: UNITS,
          id: id,
          type: type,
          name: name,
          state: "add product",
          who: systems.get_all()[0].cashier,
          num: 0,
          other: other);

      await data_products.reset_data(context);
      await data_products.info(context);
      await data_products.info_setting(context);
      await type_datas.info(context);
      state = true;
      await Future.delayed(Duration(seconds: 1));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ไม่พบรูป ใน download/Img'),
      ),
    );
  }

  if (state == false) {
    String UNITS = "p";

    if (KG) {
      UNITS = "KG";
    } else if (p) {
      UNITS = "p";
    }

    // print(UNITS);
    await localDatabase.adddata_all_product(
        id: id, name: name, price: price, picture: "-", units: UNITS, type: type, other: other ?? '-', state: "", weight: "0", context: context);
    await localDatabase.add_Stock(
        unix: time_search_hiss.getUnixNow(),
        date_time: time_search_hiss.getFormattedTimeNow(),
        units: UNITS,
        id: id,
        type: type,
        name: name,
        state: "add product",
        who: systems.get_all()[0].cashier,
        num: 0,
        other: other);
    await data_products.reset_data(context);
    await data_products.info(context);
    await data_products.info_setting(context);
    await type_datas.info(context);

    final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
    final stock_display_provider stock_displays = Provider.of<stock_display_provider>(context, listen: false);

    await stock_displays.reset_data();
    await stock_displays.reset_type_data();

    await stock_displays.reset_data();
    await stocks.reset_type_data();
    await stocks.reset_id_data();

    await stocks.reset_data(context);

    // await Future.delayed(Duration(seconds: 1));
  }
}
