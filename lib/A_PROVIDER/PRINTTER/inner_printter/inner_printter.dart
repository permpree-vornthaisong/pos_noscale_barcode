import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_product.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/format1.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/thail_cut.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/inner_printter/gen_print.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class inner_printter_provider with ChangeNotifier {
  static const MethodChannel _weightChannel =
      MethodChannel('com.example.pos_noscale_barcode/printer_weight');
  static const platform =
      MethodChannel('com.example.pos_noscale_barcode/printer');
  bool _isConnected = false;
  String? _currentPort;

  Future<void> initialize(context) async {
    try {
      // Use ttyS3 port directly instead of searching
      final String port = "/dev/ttyS3";
      print("Attempting to connect to $port");

      final success = await _tryConnectPrinter(port);
      if (success) {
        _currentPort = port;
        _isConnected = true;
        print("Successfully connected to $port");
        notifyListeners();
      } else {
        print("Failed to connect to $port");
      }
    } on PlatformException catch (e) {
      print("Failed to initialize printer: ${e.message}");
    }
  }

  Future<void> readAndPrintWeight() async {
    print("Attempting to read weight..."); // พิมพ์แจ้งเตือนว่ากำลังเริ่มอ่าน

    try {
      // กำหนด portPath และ baudRate ที่ถูกต้องสำหรับเครื่องชั่งของคุณ
      // <<--- สำคัญ: เปลี่ยนเป็นพอร์ตจริงของคุณ (อาจจะไม่ใช่ ttyS8 เสมอไป)
      final String weightPortPath = "/dev/ttyS8";
      // <<--- สำคัญ: เปลี่ยนเป็น baud rate จริงของคุณ
      final int weightBaudRate = 9600;

      // เรียกใช้เมธอด 'readWeight' ใน Native ผ่าน _weightChannel
      final String? rawData = await _weightChannel.invokeMethod(
        'readWeight',
        {
          'portPath': weightPortPath,
          'baudRate': weightBaudRate,
        },
      );

      if (rawData != null) {
        print(
            "Successfully read raw weight data: $rawData"); // พิมพ์ข้อมูลที่ได้
        // คุณสามารถเพิ่ม logic เพื่อแสดงข้อมูลน้ำหนักใน UI ที่นี่
      } else {
        print("No raw data received from scale."); // กรณีที่ไม่มีข้อมูลกลับมา
      }
    } on PlatformException catch (e) {
      // ดักจับข้อผิดพลาดที่ส่งมาจาก Native
      print("Error reading weight: ${e.code} - ${e.message}");
    } catch (e) {
      // ดักจับข้อผิดพลาดอื่นๆ ที่อาจเกิดขึ้น
      print("An unexpected error occurred: $e");
    }
  }

  Future<bool> _tryConnectPrinter(String port) async {
    try {
      print("Trying to connect to port: $port");
      final result = await platform.invokeMethod('openPort', {
        'portPath': port,
        'baudRate': 115200,
      });

      // Convert the result to boolean
      if (result is String) {
        final success = result == "Port opened successfully";
        print("Connection result: $success");
        return success;
      } else if (result is bool) {
        print("Connection result: $result");
        return result;
      }
      print("Unknown connection result type");
      return false;
    } on PlatformException catch (e) {
      print("Failed to connect to port $port: ${e.message}");
      return false;
    }
  }

  Future<void> _writeData(List<int> data) async {
    if (!_isConnected || _currentPort == null) {
      throw Exception("Printer not connected");
    }

    try {
      // ลบ await Future.delayed(Duration(milliseconds: 200)); ออก

      // ส่ง byte array โดยตรง
      await platform.invokeMethod('printBytes', {
        'portPath': _currentPort,
        'data': Uint8List.fromList(data), // แปลงเป็น Uint8List
      });

      // ลบ await Future.delayed(Duration(milliseconds: 200)); ออก
      // คุณยังคงมีการเรียก readAndPrintWeight() ที่ถูกคอมเมนต์ไว้ในโค้ดเดิม
      // ถ้าคุณต้องการเรียกใช้งาน ให้ uncomment บรรทัดนั้น
      // readAndPrintWeight();
    } on PlatformException catch (e) {
      print("Failed to write data: ${e.message}");
      throw Exception("Failed to write to printer");
    }
  }

  Future<void> send_data(context) async {
    await format1(context);
  }

  Future<void> drawer_manual(context) async {
    List<int> START_ignore_protocol = [
      0x02,
      0x40,
      0x00,
      0x02,
      0x58,
      0x05,
      0x01,
      0x00,
      0x01,
      0x01,
      0x00,
      0x02,
      0x40,
      0x00,
      0x02,
      0x58,
      0x05,
      0x01,
      0x00,
      0x01,
      0x00,
      0x00
    ];
    List<int> DATA2 = [
      0x02,
      0x40,
      0x00,
      0x02,
      0x58,
      0x02,
      0x03,
      0x00,
    ];

    await _writeData(START_ignore_protocol);
    await Future.delayed(Duration(milliseconds: 150)); // เพิ่มเวลารอ
    await _writeData(DATA2);
    await Future.delayed(Duration(milliseconds: 150)); // เพิ่มเวลารอ
    //  await format1(context);
  }

  Future<void> print_stock(context) async {
    final stock_displays =
        Provider.of<stock_display_provider>(context, listen: false);

    List<int> START_ignore_protocol = [
      0x02,
      0x40,
      0x00,
      0x02,
      0x58,
      0x05,
      0x01,
      0x00,
      0x01,
      0x01,
      0x00,
      0x02,
      0x40,
      0x00,
      0x02,
      0x58,
      0x05,
      0x01,
      0x00,
      0x01,
      0x00,
      0x00
    ];
    //form1(context);

    // print(await form1(context));
    List<int> _DATA3 = [];
    List<int> _cash_box = await serial_cash_box(context);
    ;
    int L = 0;

    // int L = await CUT_WORD(bill_detail.gettranscation().length.toString() + " ครั้ง");
    await _writeData(START_ignore_protocol);
    await Future.delayed(Duration(milliseconds: 100));

    L = await LENGHT_DATA_THAI("sum stock");

    _DATA3 = await data_to_list_INT(
        "sum stock", 160 - (L * 10 ~/ 2), 0, 4, "con", 0);

    _DATA3 += await [0x00, 0x04, 0x07];
    await _writeData(_DATA3);

    _DATA3 = await data_to_list_INT(
        "--------------------------------------------", 0, 0, 3, "con", 0);

    _DATA3 += await [0x00, 0x04, 0x07];
    await _writeData(_DATA3);
    for (int i = 0; i < stock_displays.get_data().length; i++) {
      _DATA3 = await data_to_list_INT(
          (i + 1).toString() + ". " + stock_displays.get_data()[i].id,
          10,
          0,
          1,
          "con",
          0);
      _DATA3 += await data_to_list_INT(
          stock_displays.get_data()[i].type, 130, 0, 1, "con", 0);
      _DATA3 += await data_to_list_INT(stock_displays.get_data()[i].name,
          520 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];

      await _writeData(_DATA3);
      await Future.delayed(Duration(milliseconds: 150));

      _DATA3 = await data_to_list_INT("SUM", 130, 0, 1, "con", 0);

      _DATA3 += await data_to_list_INT(
          stock_displays.get_data()[i].sum.toString() +
              " " +
              stock_displays.get_data()[i].units,
          480,
          0,
          1,
          "con",
          0);

      _DATA3 += await [0x00, 0x04, 0x07];

      await _writeData(_DATA3);

      _DATA3 = await data_to_list_INT(
          "--------------------------------------------", 0, 0, 3, "con", 0);
      await Future.delayed(Duration(milliseconds: 150));

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
      await Future.delayed(Duration(milliseconds: 50));
    }
    _DATA3 = await feed_print();
    await _writeData(_DATA3);
  }

  Future<void> format1(context) async {
    ////////////////////////////////////////////////////////////////////////
    final edit_bills = Provider.of<edit_bill_provider>(context, listen: false);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(now);

    final bill_provider bills =
        Provider.of<bill_provider>(context, listen: false);

    final customer_provider customers =
        Provider.of<customer_provider>(context, listen: false);
    final system_provider systems =
        Provider.of<system_provider>(context, listen: false);
    final localDatabase = LocalDatabase();
    List<data_product> DATA_bill = bills.get_all();
    final DATA = edit_bills.get_all()[0];

    int INDEX = await localDatabase.readall_index_bill();
    String INDEXString = (INDEX + 1).toString().padLeft(5, '0');

    // String T_list = DATA_bill.length.toString();
    int item_all = 0;
    double sum_money = 0.00;
    double sum_money_t = 0.00;
    double vat = 0.00;
    double sum_money_before_vat = 0.00;
    double discount = 0.00;

    double pay_back = 0.00;
    double pay_money = 0.00;
    double sum_weight = 0.00;

    if (bills.get_all().isNotEmpty) {
      for (int i = 0; i < bills.get_all().length; i++) {
        item_all = item_all + bills.get_all()[i].item;
        sum_weight = sum_weight + double.parse(bills.get_all()[i].weight);
        if (bills.get_all()[i].unit == "KG") {
          sum_money = sum_money +
              double.parse(bills.get_all()[i].price) *
                  double.parse(bills.get_all()[i].weight);
        } else {
          sum_money = sum_money +
              double.parse(bills.get_all()[i].price) * bills.get_all()[i].item;
        }

        sum_money_t = sum_money; ////****** */
      }
      if (systems.get_all()[0].discount_mode) {
        discount = (sum_money *
            customers.get_discount_form_type(customers.get_display_type()) /
            100);
      }

      sum_money_before_vat = sum_money - discount;

      if (systems.get_all()[0].vat_mode) {
        vat = (sum_money_before_vat *
            double.parse(systems.get_all()[0].vat) /
            100);
      }

      sum_money = sum_money_before_vat + vat;
      /*  print(sum_money);
      print(item_all);
      print(item_all);
      print(sum_money);*/
    }

    pay_money = double.parse(bills.Pay_money());
    pay_back = double.parse(bills.Pay_money()) - sum_money;

    if (bills.Qrcode_state()) {
      pay_back = 0.00;
      pay_money = sum_money;
    }

    if (pay_money <= 0) {
      //return false;
    }

    int Lenghtbill = DATA_bill.length;
    String _data_buff = "";
    ////////////////////////////////////////////////////////////////////////

    List<int> START_ignore_protocol = [
      0x02,
      0x40,
      0x00,
      0x02,
      0x58,
      0x05,
      0x01,
      0x00,
      0x01,
      0x01,
      0x00, ///////
      0x02,
      0x40,
      0x00,
      0x02,
      0x58,
      0x05,
      0x01,
      0x00,
      0x01,
      0x00,
      0x00
    ];
    //form1(context);

    // print(await form1(context));
    List<int> _DATA3 = [];
    List<int> _cash_box = await serial_cash_box(context);

    int L = 0;

    // int L = await CUT_WORD(bill_detail.gettranscation().length.toString() + " ครั้ง");
    await _writeData(START_ignore_protocol);
    await Future.delayed(Duration(milliseconds: 100));
    await _writeData(_DATA3);
    await Future.delayed(Duration(milliseconds: 100));

    if (DATA.name) {
      L = await LENGHT_DATA_THAI(DATA.NAMES);
      _DATA3 = await data_to_list_INT(
          DATA.NAMES, 160 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    if (DATA.address) {
      List<String> addressParts = DATA.ADDRESSS.split("//");

      if (addressParts.length > 0) {
        for (int i = 0; i < addressParts.length; i++) {
          L = await LENGHT_DATA_THAI(addressParts[i]);
          _DATA3 = await data_to_list_INT(
              addressParts[i], 160 - (L * 10 ~/ 2), 0, 1, "con", 0);

          _DATA3 += await [0x00, 0x04, 0x07];
          await _writeData(_DATA3);
        }
      } else {
        L = await LENGHT_DATA_THAI(DATA.ADDRESSS);
        _DATA3 = await data_to_list_INT(
            DATA.ADDRESSS, 160 - (L * 10 ~/ 2), 0, 1, "con", 0);

        _DATA3 += await [0x00, 0x04, 0x07];
        await _writeData(_DATA3);
      }
    }
    if (DATA.phone) {
      L = await LENGHT_DATA_THAI(DATA.PHONSE);
      _DATA3 = await data_to_list_INT(
          DATA.PHONSE, 160 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }

    if (DATA.tax) {
      L = await LENGHT_DATA_THAI("TAX# " + systems.get_all()[0].vat_num);
      _DATA3 = await data_to_list_INT("TAX# " + systems.get_all()[0].vat_num,
          160 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    if (DATA.text1) {
      L = await LENGHT_DATA_THAI(DATA.TEXT1S);
      _DATA3 = await data_to_list_INT(
          DATA.TEXT1S, 160 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }

    if (DATA.head) {
      L = await LENGHT_DATA_THAI(DATA.HEADS);
      _DATA3 = await data_to_list_INT(
          DATA.HEADS, 160 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    if (DATA.sn) {
      L = await LENGHT_DATA_THAI(systems.get_all()[0].SN + " " + formattedDate);
      _DATA3 = await data_to_list_INT(
          systems.get_all()[0].SN + " " + formattedDate,
          160 - (L * 10 ~/ 2),
          0,
          1,
          "con",
          0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    if (DATA.id_bill) {
      L = await LENGHT_DATA_THAI(" รหัสใบเสร็จที่ " + INDEXString);
      _DATA3 = await data_to_list_INT(" รหัสใบเสร็จที่ " + INDEXString,
          160 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    if (true) {
      _DATA3 = await data_to_list_INT(
          "--------------------------------------------", 0, 0, 3, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }

    for (int i = 0; i < Lenghtbill; i++) {
      //  L = await LENGHT_DATA_THAI(DATA.TAXS);

      if (DATA_bill[i].unit == "KG") {
        _DATA3 = await data_to_list_INT(
            (i + 1).toString() + "." + DATA_bill[i].name, 5, 0, 1, "con", 0);
        _DATA3 += await [0x00, 0x04, 0x07];
        // await _port?.write(Uint8List.fromList(_DATA3));

        await Future.delayed(Duration(milliseconds: 100));
        _DATA3 += await data_to_list_INT(
            "" + DATA_bill[i].weight + "*" + DATA_bill[i].price + "(kg)",
            10,
            0,
            1,
            "con",
            0);
        await Future.delayed(Duration(milliseconds: 100));
        L = await LENGHT_DATA_THAI((double.parse(DATA_bill[i].weight) *
                    double.parse(DATA_bill[i].price))
                .toStringAsFixed(2) +
            " บ.");
        _DATA3 += await data_to_list_INT(
            (double.parse(DATA_bill[i].weight) *
                        double.parse(DATA_bill[i].price))
                    .toStringAsFixed(2) +
                " บ.",
            290 - (L * 6),
            0,
            1,
            "con",
            0);
      } else if (DATA_bill[i].unit == "p") {
        _DATA3 = await data_to_list_INT(
            (i + 1).toString() + "." + DATA_bill[i].name, 5, 0, 1, "con", 0);
        _DATA3 += await [0x00, 0x04, 0x07];
        //     await _port?.write(Uint8List.fromList(_DATA3));

        await Future.delayed(Duration(milliseconds: 100));
        _DATA3 += await data_to_list_INT(
            "" +
                DATA_bill[i].item.toString() +
                "*" +
                DATA_bill[i].price +
                "(p)",
            10,
            0,
            1,
            "con",
            0);
        await Future.delayed(Duration(milliseconds: 100));
        L = await LENGHT_DATA_THAI(
            (DATA_bill[i].item * double.parse(DATA_bill[i].price))
                    .toStringAsFixed(2) +
                " บ.");
        _DATA3 += await data_to_list_INT(
            (DATA_bill[i].item * double.parse(DATA_bill[i].price))
                    .toStringAsFixed(2) +
                " บ.",
            290 - (L * 6),
            0,
            1,
            "con",
            0);
      }

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
      await Future.delayed(Duration(milliseconds: 50));
    }
    await Future.delayed(Duration(milliseconds: 50));
    if (true) {
      _DATA3 = await data_to_list_INT(
          "--------------------------------------------", 0, 0, 3, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }

    if (systems.get_all()[0].weight_mode) {
      _data_buff = "จำนวน " +
          Lenghtbill.toString() +
          " รายการ" +
          "  ${item_all} ชิ้น"; //+ " หนัก" + "(${sum_weight})";
      L = await LENGHT_DATA_THAI(_data_buff);
      _DATA3 =
          await data_to_list_INT(_data_buff, 290 - (L * 10), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    } else {
      _data_buff =
          "จำนวน " + Lenghtbill.toString() + " รายการ" + "  ${item_all} ชิ้น";
      L = await LENGHT_DATA_THAI(_data_buff);
      _DATA3 =
          await data_to_list_INT(_data_buff, 290 - (L * 10), 0, 1, "con", 0);
      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }

    if (true) {
      _DATA3 = await data_to_list_INT(
          "--------------------------------------------", 0, 0, 3, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    if (systems.get_all()[0].discount_mode || systems.get_all()[0].vat_mode) {
      L = await LENGHT_DATA_THAI("ทั้งหมด");

      _DATA3 = await data_to_list_INT("ทั้งหมด", 80 - (L * 6), 0, 1, "con", 0);
      L = await LENGHT_DATA_THAI(sum_money_t.toStringAsFixed(2) + " บ.");

      _DATA3 += await data_to_list_INT(sum_money_t.toStringAsFixed(2) + " บ.",
          290 - (L * 6), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }

    if (systems.get_all()[0].discount_mode) {
      L = await LENGHT_DATA_THAI("ส่วนลด " +
          (customers.get_discount_form_type(customers.get_display_type()))
              .toString() +
          "%");

      _DATA3 = await data_to_list_INT(
          "ส่วนลด " +
              (customers.get_discount_form_type(customers.get_display_type()) /
                      100)
                  .toString() +
              "%",
          80 - (L * 6),
          0,
          1,
          "con",
          0);
      L = await LENGHT_DATA_THAI(discount.toStringAsFixed(2) + " บ.");

      _DATA3 += await data_to_list_INT(
          discount.toStringAsFixed(2) + " บ.", 290 - (L * 6), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }

    if (systems.get_all()[0].vat_mode) {
      L = await LENGHT_DATA_THAI("ภาษี " + systems.get_all()[0].vat + "%");

      _DATA3 = await data_to_list_INT("ภาษี " + systems.get_all()[0].vat + "%",
          80 - (L * 6), 0, 1, "con", 0);
      L = await LENGHT_DATA_THAI(vat.toStringAsFixed(2) + " บ.");

      _DATA3 += await data_to_list_INT(
          vat.toStringAsFixed(2) + " บ.", 290 - (L * 6), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
//       "ส่วนลด",

//      discount.toStringAsFixed(2) + " บ.",

//      "ภาษี " + systems.get_all()[0].vat + "%",
//      vat.toStringAsFixed(2) + " บ.",

    if (true) {
      await Future.delayed(Duration(milliseconds: 100));

      L = await LENGHT_DATA_THAI("ราคาสุทธิ");

      _DATA3 =
          await data_to_list_INT("ราคาสุทธิ", 80 - (L * 6), 0, 1, "con", 0);

      L = await LENGHT_DATA_THAI(sum_money.toStringAsFixed(2) + " บ.");

      _DATA3 += await data_to_list_INT(
          sum_money.toStringAsFixed(2) + " บ.", 290 - (L * 6), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }

    if (true) {
      await Future.delayed(Duration(milliseconds: 100));

      L = await LENGHT_DATA_THAI("รับมา");

      _DATA3 = await data_to_list_INT("รับมา", 80 - (L * 6), 0, 1, "con", 0);

      L = await LENGHT_DATA_THAI(pay_money.toStringAsFixed(2) + " บ.");

      _DATA3 += await data_to_list_INT(
          pay_money.toStringAsFixed(2) + " บ.", 290 - (L * 6), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    if (true) {
      await Future.delayed(Duration(milliseconds: 100));

      L = await LENGHT_DATA_THAI("ทอน");

      _DATA3 = await data_to_list_INT("ทอน", 80 - (L * 6), 0, 1, "con", 0);

      L = await LENGHT_DATA_THAI(pay_back.toStringAsFixed(2) + " บ.");

      _DATA3 += await data_to_list_INT(
          pay_back.toStringAsFixed(2) + " บ.", 290 - (L * 6), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    if (true) {
      _DATA3 = await data_to_list_INT(
          "--------------------------------------------", 0, 0, 3, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    /* if (true) {
      L = await LENGHT_DATA_THAI("รหัสใบเสร็จ " + INDEXString + " : " + systems.get_all()[0].cashier);

      _DATA3 = await data_to_list_INT("รหัสใบเสร็จ " + INDEXString + " : " + systems.get_all()[0].cashier, 174 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _port?.write(Uint8List.fromList(_DATA3));
    }*/
    /* if (true) {
      _DATA3 = await data_to_list_INT(formattedDate, 90, 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _port?.write(Uint8List.fromList(_DATA3));
    }*/

    if (DATA.text2) {
      L = await LENGHT_DATA_THAI(DATA.TEXT2S);

      _DATA3 = await data_to_list_INT(
          DATA.TEXT2S, 174 - (L * 10 ~/ 2), 0, 1, "con", 0);

      _DATA3 += await [0x00, 0x04, 0x07];
      await _writeData(_DATA3);
    }
    _DATA3 = await feed_print();
    await _writeData(_DATA3);

    await _writeData(_cash_box);

    /*  _DATA3 += await data_to_list_INT("ทั้งหมด", 5, 0, 4, "con", 0);
    _DATA3 += await data_to_list_INT("123456789" + " รายการ", 100, 0, 4, "con", 0);
    _DATA3 += await [0x00, 0x04, 0x07];

    _cash_box = await serial_cash_box(context);*/

    /* await _port?.write(Uint8List.fromList(_DATA3));
    await Future.delayed(Duration(milliseconds: 100));
    await _port?.write(Uint8List.fromList(_cash_box));
    await Future.delayed(Duration(milliseconds: 100));*/
  }

  @override
  void dispose() {
    if (_isConnected) {
      platform.invokeMethod('closePort');
    }
    super.dispose();
  }
}
