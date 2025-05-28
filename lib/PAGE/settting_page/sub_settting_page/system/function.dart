import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

Future<void> pick_cashier(context) async {
  // FilePickerResult? result = await FilePicker.platform.pickFiles(
  //  type: FileType.custom,
  //allowedExtensions: ['jpg'],
  await requestStoragePermission();
  //  allowedExtensions: ['xlsx', 'xls'],
  // );

  // if (result != null) {
  //  PATH = result.files.single.path!;
  //   print(PATH);
  readExcel(context);
  //  }
}

Future<void> readExcel(context) async {
  final system_provider data_products = Provider.of<system_provider>(context, listen: false);
  final cashier_provider cashiers = Provider.of<cashier_provider>(context, listen: false);

  final localDatabase = LocalDatabase();

  var file;
  // String imgDirectoryPath = path.join(path.dirname(filePath), 'Img');

  try {
    Directory directory2 = Directory('/storage/');
    List<FileSystemEntity> contents = directory2.listSync();

    if (contents[0].toString() != "emulated") {
      Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/input');

      String imagePath = path.join(directory.path, 'cashier.xlsx');

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
    await localDatabase.delete_cashier();

    // Start the loop from index 1 to skip the first row
    for (var i = 1; i < rows.length; i++) {
      await Future.delayed(Duration(milliseconds: 20), () {});

      var row = rows[i];
      // Access the cells in the row using an index
      /* print(row[0]!.value);
      print(row[1]!.value);*/

      await localDatabase.adddata_cashier(id: row[0]!.value.toString(), name: row[1]!.value.toString(), role: row[2]!.value.toString());
      await cashiers.reset_data(context);
    }
    // ล่าช้าเป็นเวลา 3 วินาที
    //  await Future.delayed(Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("นำเข้าพนักงานสำเร็จ"),
      ),
    );
  }
}

Future<void> requestStoragePermission() async {
  try {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // ได้รับอนุญาต
      // print('Storage permission granted.');
    } else {
      // ไม่ได้รับอนุญาต
      // print('Storage permission denied.');
    }
  } catch (e) {
    // print('Error requesting storage permission: $e');
  }
}
