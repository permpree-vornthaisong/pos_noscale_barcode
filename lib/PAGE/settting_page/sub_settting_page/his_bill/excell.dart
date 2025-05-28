import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/datatime_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/his_bill_provider.dart';
import 'package:provider/provider.dart';
/*  his_bill(
        sn: sn,
        id_bill: id_bill,
        cahier: cahier,
        date_time: data_time,
        tax: tax,
        sum_money: sum_money,
        pay_money: pay_money,
        money_back: money_back,
        method_pay: method_pay,
        sum_list: sum_list,
        sum_detial_list: sum_detial_list,
        state: state,
        detial: detial)
         'id': 
        'name': bills.get_all()[i].name,
        'item': bills.get_all()[i].item, //int
        'price': bills.get_all()[i].price,
        'price_all': 
        
        */

Future<void> EXCEL_bill(context) async {
  final his_bill_provider his_bills = Provider.of<his_bill_provider>(context, listen: false);
  final time_search_his_provider time_search_hiss = Provider.of<time_search_his_provider>(context, listen: false);

  String START = time_search_hiss.get_all()[0].D.toString() +
      "-" +
      time_search_hiss.get_all()[0].M.toString() +
      "-" +
      time_search_hiss.get_all()[0].Y.toString();

  String END = time_search_hiss.get_all()[1].D.toString() +
      "-" +
      time_search_hiss.get_all()[1].M.toString() +
      "-" +
      time_search_hiss.get_all()[1].Y.toString();
  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  // เพิ่มหัวข้อแถวและ[คอลัมน์

  sheet.appendRow([
    "รหัสเครื่อง",
    "รหัสใบเสร็จ",
    "พนักงานที่ขาย",
    "วันที่-เวลา",
    "เลขภาษี",
    "เงินรวม",
    "จำนวนรายการ",
    "จำนวนสินค้า",
    "สถานะใบเสร็จ",
    "วิธีจ่ายเงิน",
    "เงินก่อนลด",
    "ส่วนลด",
    "เงินก่อน vat",
    "vat",
    "รับมา",
    "ทอน",
    "รหัสลูกค้า",
    "กลุ่มลูกค้า",

    /////////////////////////////
    "",
    "รหัสสินค้า",
    "ชื่อสินค้า",
    "จำนวน",
    "ราคาต่อหน่วย",
    "ราคารวม"
  ]);

  for (int i = 0; i < his_bills.get_all().length; i++) {
    sheet.appendRow([
      his_bills.get_all()[i].sn ?? '', // "รหัสเครื่อง",
      his_bills.get_all()[i].id_bill ?? '', //   "รหัสใบเสร็จ",
      his_bills.get_all()[i].cahier ?? '', //   "พนักงานที่ขาย",
      his_bills.get_all()[i].date_time ?? '', //        "วันที่-เวลา",
      his_bills.get_all()[i].tax_id ?? '', //     "เลขภาษี",
      his_bills.get_all()[i].sum_money ?? '', //        "เงินรวม",
      his_bills.get_all()[i].sum_list ?? '', //      "จำนวนรายการ",
      his_bills.get_all()[i].sum_detial_list ?? '', //    "จำนวนสินค้า",
      his_bills.get_all()[i].state ?? '', //     "สถานะใบเสร็จ",
      his_bills.get_all()[i].method_pay ?? '', //        "วิธีจ่ายเงิน",
      his_bills.get_all()[i].sum_money_t ?? '', //         "เงินก่อนลด",
      his_bills.get_all()[i].discount_customer ?? '', // "ส่วนลด",
      his_bills.get_all()[i].sum_money_before_tax ?? '', //    "เงินก่อน vat",
      his_bills.get_all()[i].tax_money ?? '', //     "vat",
      his_bills.get_all()[i].pay_money ?? '', //   "รับมา",
      his_bills.get_all()[i].money_back ?? '', //    "ทอน",
      his_bills.get_all()[i].customer ?? '', //   "รหัสลูกค้า",
      his_bills.get_all()[i].type_customer ?? '', //    "กลุ่มลูกค้า",
    ]);
    for (int j = 0; j < his_bills.get_all()[i].detial.length; j++) {
      sheet.appendRow([
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        his_bills.get_all()[i].detial[j]['id'] ?? '',
        his_bills.get_all()[i].detial[j]['name'] ?? '',
        his_bills.get_all()[i].detial[j]['item'] ?? '',
        his_bills.get_all()[i].detial[j]['price'] ?? '',
        his_bills.get_all()[i].detial[j]['price_all'] ?? '',
      ]);
    }
  }
  await Future.delayed(Duration(milliseconds: 100));

  try {
    final excelFileName = "hisbill${START + "to" + END}.xlsx";

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
      print("Excel file saved: ${excelFile.path}");
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
