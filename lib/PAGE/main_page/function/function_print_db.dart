import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/function/thai_print_db.dart';
import 'package:provider/provider.dart';
import 'package:usb_serial/usb_serial.dart';

Future<bool> printter(context) async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(now);
  // print('Current date and time: $formattedDate');

  final bill_provider bills = Provider.of<bill_provider>(context, listen: false);

  List<UsbDevice> devices = await UsbSerial.listDevices();
  late UsbDevice device;
  final edit_bill_provider edit_bills = Provider.of<edit_bill_provider>(context, listen: false);
  final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
  final system_provider systems = Provider.of<system_provider>(context, listen: false);
  final localDatabase = LocalDatabase();
  List<Map<String, dynamic>> dataList = [];


  int INDEX = await localDatabase.readall_index_bill();
  String INDEXString = (INDEX + 1).toString().padLeft(5, '0');

 
  String T_list = bills.get_all().length.toString();
  int item_all = 0;
  double sum_money = 0.00;
  double sum_money_t = 0.00;
  double vat = 0.00;
  double sum_money_before_vat = 0.00;
  double discount = 0.00;

  double pay_back = 0.00;
  double pay_money = 0.00;

  if (bills.get_all().isNotEmpty) {
    if (bills.get_all().isNotEmpty) {
      for (int i = 0; i < bills.get_all().length; i++) {
        item_all = item_all + bills.get_all()[i].item;
        sum_money = sum_money + double.parse(bills.get_all()[i].price) * bills.get_all()[i].item;
        sum_money_t = sum_money; ////****** */
      }
      if (systems.get_all()[0].discount_mode) {
        discount = (sum_money * customers.get_discount_form_type(customers.get_display_type()) / 100);
      }

      sum_money_before_vat = sum_money - discount;

      if (systems.get_all()[0].vat_mode) {
        vat = (sum_money * 7 / 100);
      }

      sum_money = sum_money_before_vat + vat;
      /*  print(sum_money);
      print(item_all);
      print(item_all);
      print(sum_money);*/
    }
  }
  pay_money = double.parse(bills.Pay_money());
  pay_back = double.parse(bills.Pay_money()) - sum_money;

  if (bills.Qrcode_state()) {
    pay_back = 0.00;
    pay_money = sum_money;
  }

  if (pay_money <= 0) {
    return false;
  }

  try {
    if (devices.isNotEmpty) {
      for (int i = 0; i < devices.length; i++) {
        if (devices[i].productName == "KCEC-USB") {
          //USB2.0-Ser!
          //"micro printer
          // USB2.0-Serial
          //"USB2.0-Serial"
          //"USB2.0-Serial"  CP2102 USB to UART Bridge Controller"
          device = devices[i];
        }
      }

      UsbPort? port = await device.create(); // Use UsbPort? instead of UsbPort UsbSerial.CH34x

      if (port != null) {
        await port.open();

        await port.setDTR(true);
        await port.setRTS(true);
        await port.setPortParameters(9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE); //9600  115200
        // await port?.write(Uint8List.fromList([27, 55, 2]));
/*
      await PRINT_FULL_CENTER(port, "หมู่ ไก่ กู๊ กุ้ง", "อร่อยๆ แหละมังคุ๊ต");
      await PRINT_FULL_CENTER(port, "หมู่ ไก่ กู๊ กุ้ง", "อร่อยๆ แหละมังคุ๊ต");
      await PRINT_FULL_CENTER(port, "หมู่ ไก่ กู๊ กุ้ง", "อร่อยๆ แหละมังคุ๊ต");*/

        if (pay_back >= 0 && (bills.Qrcode_state() || bills.Money_state())) {
          edit_bills.get_all()[0].head ? await THAI_PRINT(port, "center", edit_bills.get_all()[0].HEADS, 1, true) : null;

          edit_bills.get_all()[0].name ? await THAI_PRINT(port, "center", edit_bills.get_all()[0].NAMES, 1, false) : null;
          edit_bills.get_all()[0].tax ? await THAI_PRINT(port, "center", "Tax#" + edit_bills.get_all()[0].TAXS, 1, false) : null;
          for (int i = 0; i < bills.get_all().length; i++) {
            //+ bills.get_all()[i].item.toString()

            if (bills.get_all()[i].item == 1) {
              int LENGHT = LIMIT_RANGE(bills.get_all()[i].name, 20);

              String DATA = bills.get_all()[i].name.substring(0, LENGHT);

              if (edit_bills.get_all()[0].form == "1") {
                await PRINT_THAI_FULL_CENTER(port, DATA, (double.parse(bills.get_all()[i].price)).toStringAsFixed(2) + " บ.");
              } else if (edit_bills.get_all()[0].form == "2") {
                await PRINT_THAI_FULL_CENTER(port, DATA, (double.parse(bills.get_all()[i].price)).toStringAsFixed(2) + " B.");
              }
            } else {
              int LENGHT = LIMIT_RANGE(bills.get_all()[i].name, 12);

              String DATA = bills.get_all()[i].name.substring(0, LENGHT);

              if (edit_bills.get_all()[0].form == "1") {
                await PRINT_THAI_FULL_CENTER(
                    port,
                    DATA,
                    "@" +
                        (double.parse(bills.get_all()[i].price)).toStringAsFixed(2) +
                        "*" +
                        bills.get_all()[i].item.toString() +
                        " " +
                        (double.parse(bills.get_all()[i].price) * bills.get_all()[i].item).toStringAsFixed(2) +
                        " บ.");
              } else if (edit_bills.get_all()[0].form == "2") {
                await PRINT_THAI_FULL_CENTER(
                    port,
                    DATA,
                    "@" +
                        (double.parse(bills.get_all()[i].price)).toStringAsFixed(2) +
                        "*" +
                        bills.get_all()[i].item.toString() +
                        " " +
                        (double.parse(bills.get_all()[i].price) * bills.get_all()[i].item).toStringAsFixed(2) +
                        " B.");
              }
            }
          }

          await LINE_PRINT(port);
          if (edit_bills.get_all()[0].form == "1") {
            await THAI_PRINT(port, "right", "จำนวนสินค้า " + T_list + "รายการ" + "(${item_all.toString()}ชิ้น)", 1, false);
          } else if (edit_bills.get_all()[0].form == "2") {
            await LINE_FEED(port);
            await ENGPRINT(port, "right", " Total " + T_list + " item" + "(${item_all.toString()} EA)", 1, false);
          }
          await LINE_PRINT(port);

          if (systems.get_all()[0].discount_mode && (customers.get_discount_form_type(customers.get_display_type()) > 0)) {
            if (edit_bills.get_all()[0].form == "1") {
              await THAI_PRINT(
                  port,
                  "right",
                  "ส่วนลด " +
                      customers.get_discount_form_type(customers.get_display_type()).toStringAsFixed(2) +
                      "%" +
                      " ลดจาก " +
                      sum_money_t.toStringAsFixed(2) +
                      " บ.",
                  1,
                  false);
              await THAI_PRINT(port, "right", "เหลือ " + sum_money_before_vat.toStringAsFixed(2) + " บ.", 1, false);
            } else if (edit_bills.get_all()[0].form == "2") {
              await LINE_FEED(port);

              await ENGPRINT(
                  port,
                  "right",
                  "Discount " +
                      customers.get_discount_form_type(customers.get_display_type()).toStringAsFixed(2) +
                      "%" +
                      " left " +
                      sum_money_t.toStringAsFixed(2) +
                      " B.",
                  1,
                  false);
              await LINE_FEED(port);

              await ENGPRINT(port, "right", "Money left " + sum_money_before_vat.toStringAsFixed(2) + " B.", 1, false);
            }
          }

          if (systems.get_all()[0].vat_mode) {
            if (edit_bills.get_all()[0].form == "1") {
              await THAI_PRINT(port, "right", "Vat ${systems.get_all()[0].vat}% " + vat.toStringAsFixed(2) + " บ.", 1, false);
            } else if (edit_bills.get_all()[0].form == "2") {
              await LINE_FEED(port);

              await ENGPRINT(port, "right", "Vat ${systems.get_all()[0].vat}% " + vat.toStringAsFixed(2) + " B.", 1, false);
            }
          }
          if (edit_bills.get_all()[0].form == "1") {
            await PRINT_THAI_FULL_CENTER(port, "   ราคาสุทธิ", sum_money.toStringAsFixed(2) + " บ.");
            await PRINT_THAI_FULL_CENTER(port, "   รับมา", pay_money.toStringAsFixed(2) + " บ.");
            await PRINT_THAI_FULL_CENTER(port, "   ทอน", pay_back.toStringAsFixed(2) + " บ.");
          } else if (edit_bills.get_all()[0].form == "2") {
            await LINE_FEED(port);

            await PRINT_ENG_FULL_CENTER(port, "   Net", sum_money.toStringAsFixed(2) + " B.");
            await LINE_FEED(port);

            await PRINT_ENG_FULL_CENTER(port, "   Received", pay_money.toStringAsFixed(2) + " B.");
            await LINE_FEED(port);

            await PRINT_ENG_FULL_CENTER(port, "   Change", pay_back.toStringAsFixed(2) + " B.");
          }

          await LINE_PRINT(port);

          await THAI_PRINT(port, "center", "BillID:" + INDEXString.toString() + ":" + "cahier:" + systems.get_all()[0].cashier, 1, false); /////

          await THAI_PRINT(port, "center", formattedDate, 1, false); /////sdfsdfs
          edit_bills.get_all()[0].text1 ? await THAI_PRINT(port, "center", edit_bills.get_all()[0].TEXT1S, 1, false) : null;
          await LINE_FEED(port);
          await LINE_FEED(port);
          await Future.delayed(Duration(milliseconds: 10));

          await port?.write(Uint8List.fromList([0x1B, 0x70]));
          await Future.delayed(Duration(milliseconds: 10));

          // await THAI_PRINT(port, "right", "ราคาสุทธิ " + T_price + " บาท", 1, false);
          // await THAI_PRINT(port, "right", "ราคาสุทธิ " + T_price + " บาท", 1, false);
          /*  await LINE_PRINT(port);
        if (bills.Money_state()) {
          await PRINT_FULL_CENTER(port, "ขำระโดย", "เงินสด");
        }*/

          /*if (bills.Qrcode_state()) {
          await PRINT_FULL_CENTER(port, "ขำระโดย", "Qrcode");
        }*/
/*
        await LINE_PRINT(port);

        edit_bills.get_all()[0].customer ? await THAI_PRINT(port, "center", "ข้อมูลลูกค้า", 1, false) : null;
        edit_bills.get_all()[0].customer
            ? await THAI_PRINT(
                port, "center", customers.get_display_id() + " " + customers.get_display_name() + " " + customers.get_display_type(), 1, false)
            : null;

        await LINE_PRINT(port);
        edit_bills.get_all()[0].text1 ? await THAI_PRINT(port, "center", edit_bills.get_all()[0].TEXT1S, 1, false) : null;
        await port?.write(Uint8List.fromList([0x0d, 0x0a, 0x0d, 0x0a, 0x0d, 0x0a])); //0x1B, 0x33, 0x00
*/
          //27, 55

          /* await THAI_PRINT(port, "", "01234567890123456789012345678901234567890123", 2, true);

      await THAI_PRINT(port, "", "0123456789012345678901234567890123456789", 1, true);*/

          await Future.delayed(Duration(seconds: 1));
        }
        ////// await Future.delayed(Duration(seconds: 1));

        await port.close();

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(e.toString()),
        );
      },
    );
    return false;
  }
}
