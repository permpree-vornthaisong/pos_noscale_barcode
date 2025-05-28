import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:provider/provider.dart';

Future<void> EXCEL_product(context) async {
  final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);

  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  // เพิ่มหัวข้อแถวและ[คอลัมน์

  sheet.appendRow(["รหัสสินค้า", "ชื่อสินค้า", "ราคาต่อหน่วย", "หน่วย", "ชนิดสินค้า", "อื่นๆ"]);

  for (int i = 0; i < data_products.get_all_nofilter().length; i++) {
    if (data_products.get_all_nofilter()[i].id != "99999") {
      sheet.appendRow([
        //  "20" + data_products.get_all_nofilter()[i].id,
        data_products.get_all_nofilter()[i].id,
        data_products.get_all_nofilter()[i].name,
        data_products.get_all_nofilter()[i].price,
        data_products.get_all_nofilter()[i].unit,
        data_products.get_all_nofilter()[i].type,
        data_products.get_all_nofilter()[i].other,
      ]);
    }
  }
  await Future.delayed(Duration(milliseconds: 100));

  try {
    final excelFileName = "product.xlsx";

    Directory directory2 = Directory('/storage/');
    List<FileSystemEntity> contents = directory2.listSync();

    if (contents.isNotEmpty) {
      Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/output/');

      //  String imagePath = path.join(directory.path, '${row[1]!.value.toString()}.jpg');

      final excelFile = File(directory.path + excelFileName); // Adjust the path as needed
      if (excelFile.existsSync()) {
        // ถ้าไฟล์มีอยู่แล้วในเส้นทางที่กำหนด
        excelFile.deleteSync(); // ลบไฟล์ที่มีอยู่
      }
      excelFile.writeAsBytesSync(excel.encode()!); // Convert nullable List<int>? to non-nullable List<int>

      // Display a message or perform further actions as needed
      /// print("Excel file saved: ${excelFile.path}");
      //stopwatch.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Excel file saved: ${excelFile.path}"),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่พบไฟล์ในไดเรกทอรี'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("error saved: ${e}"),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    ));
  }
}

Future<void> outpicture_product(context) async {
  final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);

  try {
    Directory directory2 = Directory('/storage/');
    List<FileSystemEntity> contents = directory2.listSync();

    if (contents.isNotEmpty) {
      ///  print("adasdasdasd1");

      Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/output/Img/');

      /// print("adasdasdasd2");

      for (int i = 0; i < data_products.get_all_nofilter().length; i++) {
        if (data_products.get_all_nofilter()[i].id != "99999") {
          ///    print("adasdasdasd3");
          Uint8List decodedImage = base64.decode(data_products.get_all_nofilter()[i].picture);
          if (decodedImage.lengthInBytes > 0) {
            File PIC = File(directory.path + data_products.get_all_nofilter()[i].name + ".jpg"); // Adjust the path as needed
            if (PIC.existsSync()) {
              // ถ้าไฟล์มีอยู่แล้วในเส้นทางที่กำหนด
              PIC.deleteSync(); // ลบไฟล์ที่มีอยู่rth
            }
            await PIC.writeAsBytes(decodedImage);
          } else {}
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่พบไฟล์ในไดเรกทอรี'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("error saved: ${e}"),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    ));
  }
}
