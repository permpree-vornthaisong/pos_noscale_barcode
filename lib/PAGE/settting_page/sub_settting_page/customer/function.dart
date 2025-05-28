import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/showdialog_component/add_product.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/showdialog_component/delect_all_product.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class file_picker_excell_customer with ChangeNotifier {
  String PATH = "";

  Future<void> pickExcelFile(context) async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //  type: FileType.custom,
    //allowedExtensions: ['jpg'],
    await requestStoragePermission();
    //  allowedExtensions: ['xlsx', 'xls'],
    // );

    // if (result != null) {
    //  PATH = result.files.single.path!;
    //   print(PATH);
    _readExcel1(context);
    _readExcel2(context);
    //  }
  }

  Future<void> _readExcel1(context) async {
    final customer_provider customers = Provider.of<customer_provider>(context, listen: false);

    final localDatabase = LocalDatabase();

    var file;
    // String imgDirectoryPath = path.join(path.dirname(filePath), 'Img');

    try {
      Directory directory2 = Directory('/storage/');
      List<FileSystemEntity> contents = directory2.listSync();

      if (contents.isNotEmpty) {
        Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/input');

        String imagePath = path.join(directory.path, 'customer.xlsx');

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
        var row = rows[i];
        bool state = false;
        // Access the cells in the row using an index
        print(row[0]!.value);

        for (int j = 0; j < customers.get_customer().length; j++) {
          if (row[0]!.value.toString() == customers.get_customer()[j].id) {
            state = true;
            /* ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('เจอละ'),
              ),
            );*/
            break;
          }
        }
        if (state) {
          try {
            // Get the directory where the Excel file is located

            await localDatabase.updatedata_customer(
                id: row[0]!.value.toString() ?? '', name: row[1]!.value.toString() ?? '', type: row[2]!.value.toString() ?? '');
            ///////////
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('UPDATE'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ADD'),
            ),
          );
          print("object");
          try {
            await localDatabase.adddata_customer(
                id: row[0]!.value.toString() ?? '', name: row[1]!.value.toString() ?? '', type: row[2]!.value.toString() ?? '');
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('เกิดข้อผิดพลาด: $e'),
              ),
            );
          }
        }
      }

      await customers.resset_customer(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("นำเข้าสำเร็จ"),
        ),
      );
    }
  }

  Future<void> _readExcel2(context) async {
    final customer_provider customers = Provider.of<customer_provider>(context, listen: false);

    final localDatabase = LocalDatabase();

    var file;
    // String imgDirectoryPath = path.join(path.dirname(filePath), 'Img');

    try {
      Directory directory2 = Directory('/storage/');
      List<FileSystemEntity> contents = directory2.listSync();

      if (contents[0].toString() != "emulated") {
        Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/input');

        String imagePath = path.join(directory.path, 'discount_customer.xlsx');

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
        var row = rows[i];
        bool state = false;
        // Access the cells in the row using an index
        print(row[0]!.value);

        for (int j = 0; j < customers.get_discount_customer().length; j++) {
          if (row[0]!.value.toString() == customers.get_discount_customer()[j].type) {
            state = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('เจอละ'),
              ),
            );
            break;
          }
        }
        if (state) {
          try {
            // Get the directory where the Excel file is located

            await localDatabase.updatedata_discount_customer(
                type: row[0]!.value.toString() ?? '', discount: double.parse(row[1]!.value.toString()) ?? 0.00);

            ///////////
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('UPDATE'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ADD'),
            ),
          );
          print("object");
          try {
            await localDatabase.adddata_discount_customer(
                type: row[0]!.value.toString() ?? '', discount: double.parse(row[1]!.value.toString()) ?? 0.00);
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('เกิดข้อผิดพลาด: $e'),
              ),
            );
          }
        }
      }

      await customers.resset_discount_customer(context);

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
