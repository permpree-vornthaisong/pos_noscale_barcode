import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:provider/provider.dart';

void EXCEL_customer(context) {
  final customer_provider customers = Provider.of<customer_provider>(context, listen: false);

  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  // เพิ่มหัวข้อแถวและ[คอลัมน์

  sheet.appendRow(["รหัสลูกค้า", "ชื่อลูกค้า", "กลุ่มลูกค้า"]);

  for (int i = 0; i < customers.get_customer().length; i++) {
    sheet.appendRow([
      customers.get_customer()[i].id,
      customers.get_customer()[i].name,
      customers.get_customer()[i].type,
    ]);
  }
  try {
    final excelFileName = "customer.xlsx";

    Directory directory2 = Directory('/storage/');
    List<FileSystemEntity> contents = directory2.listSync();

    if (contents[0].toString() != "emulated") {
      Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/output/');

      //  String imagePath = path.join(directory.path, '${row[1]!.value.toString()}.jpg');
      final excelFile = File(directory.path + excelFileName); // Adjust the path as needed
      if (excelFile.existsSync()) {
        // ถ้าไฟล์มีอยู่แล้วในเส้นทางที่กำหนด
        excelFile.deleteSync(); // ลบไฟล์ที่มีอยู่
      }
      excelFile.writeAsBytesSync(excel.encode()!); // Convert nullable List<int>? to non-nullable List<int>
      // Convert nullable List<int>? to non-nullable List<int>

      // Display a message or perform further actions as needed
      //  print("Excel file saved: ${excelFile.path}");
      //stopwatch.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Excel file saved: ${excelFile.path}"),
          duration: Duration(seconds: 2), // Adjust the duration as needed
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

Future<void> EXCEL_discount(context) async {
  final customer_provider customers = Provider.of<customer_provider>(context, listen: false);

  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  sheet.appendRow(["กลุ่มลูกค้า", "ลดราคา %"]);

  for (int i = 0; i < customers.get_customer().length; i++) {
    sheet.appendRow([
      customers.get_discount_customer()[i].type,
      customers.get_discount_customer()[i].discount,
    ]);
  }
  await Future.delayed(Duration(milliseconds: 100));

  try {
    final excelFileName = "discount_customer.xlsx";

    Directory directory2 = Directory('/storage/');
    List<FileSystemEntity> contents = directory2.listSync();

    if (contents[0].toString() != "emulated") {
      Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/output/');

      //  String imagePath = path.join(directory.path, '${row[1]!.value.toString()}.jpg');

      final excelFile = File(directory.path + excelFileName); // Adjust the path as needed
      if (excelFile.existsSync()) {
        // ถ้าไฟล์มีอยู่แล้วในเส้นทางที่กำหนด
        excelFile.deleteSync(); // ลบไฟล์ที่มีอยู่
      }
      excelFile.writeAsBytesSync(excel.encode()!); // Convert nullable List<int>? to non-nullable List<int>

      // Display a message or perform further actions as needed
      // print("Excel file saved: ${excelFile.path}");
      //stopwatch.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Excel file saved: ${excelFile.path}"),
          duration: Duration(seconds: 2), // Adjust the duration as needed
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
