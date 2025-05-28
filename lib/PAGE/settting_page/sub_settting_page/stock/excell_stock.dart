import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:provider/provider.dart';

void EXCEL_stock(context) {
  final stock_provider stocks = Provider.of<stock_provider>(context, listen: false);
  final time_search_stock_provider time_search_stocks = Provider.of<time_search_stock_provider>(context, listen: false);

  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  // เพิ่มหัวข้อแถวและ[คอลัมน์

  sheet.appendRow(["วันที่", time_search_stocks.get_start_time_formatted(), "ถึง", time_search_stocks.get_end_time_formatted()]);
  sheet.appendRow([""]);

  sheet.appendRow(["วันที่เวลา", "รหัสสินค้า", "ชื่อสินค้า", "ประเภทสินค้า", "หน่วย", "จำนวน", "สถานะ", "พนักงาน"]);
  sheet.appendRow([""]);

  for (int i = 0; i < stocks.get_data().length; i++) {
    sheet.appendRow([
      stocks.get_data()[i].data_time,
      stocks.get_data()[i].id,
      stocks.get_data()[i].name,
      stocks.get_data()[i].type,
      stocks.get_data()[i].units,
      stocks.get_data()[i].num,
      stocks.get_data()[i].state,
      stocks.get_data()[i].who,
    ]);
  }
  try {
    final excelFileName = "stock_by_time.xlsx";

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
      //print("Excel file saved: ${excelFile.path}");
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

Future<void> EXCEL_sum_stock(context) async {
  final stock_display_provider stock_displays = Provider.of<stock_display_provider>(context, listen: false);
  final time_search_stock_provider time_search_stocks = Provider.of<time_search_stock_provider>(context, listen: false);

  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  sheet.appendRow(["วันที่", time_search_stocks.getFormattedTimeNow()]);
  sheet.appendRow([""]);

  sheet.appendRow(["รหัส", "ชื่อ", "ชนิด", "จำนวนรวม", "หน่วย"]);
  sheet.appendRow([""]);

  for (int i = 0; i < stock_displays.get_data().length; i++) {
    sheet.appendRow([
      stock_displays.get_data()[i].id,
      stock_displays.get_data()[i].name,
      stock_displays.get_data()[i].type,
      stock_displays.get_data()[i].sum,
      stock_displays.get_data()[i].units,
    ]);
  }
  await Future.delayed(Duration(milliseconds: 100));

  try {
    final excelFileName = "stocks_sum.xlsx";

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
      ///print("Excel file saved: ${excelFile.path}");
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
