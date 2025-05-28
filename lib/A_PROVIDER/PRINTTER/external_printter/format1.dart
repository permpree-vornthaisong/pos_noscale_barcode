import 'dart:convert';
import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/printter_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/thail_cut.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
//import 'package:pdf_render/pdf_render.dart' as pdf_render;
//import 'package:qr_flutter/qr_flutter.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart' as pdf_render;

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:pos_noscale_barcode/A_MODEL/data_product.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/customer_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

//import 'package:pdf_render/pdf_render.dart' as pdf_render;
//import 'package:qr_flutter/qr_flutter.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart' as pdf_render;
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<List<int>> form1(context) async {
  final edit_bills = Provider.of<edit_bill_provider>(context, listen: false);
  final PrinterManagers = Provider.of<PrinterManagerClass>(context, listen: false);
  final bill_provider bills = Provider.of<bill_provider>(context, listen: false);
  final system_provider systems = Provider.of<system_provider>(context, listen: false);
  List<data_product> DATA_bill = bills.get_all();
  int Lenghtbill = DATA_bill.length;

  List<PdfTrueTypeFont> FONT = PrinterManagers.getfont();
  List<int> byte = [];

  final DATA = edit_bills.get_all()[0];
  final PdfDocument pdf = PdfDocument();

  int LLL = 0;
  double pageHeight = 0;

  if (DATA.pic) {
// 200

    pageHeight = 430;
  }

  if (DATA.head) {
    LLL++;
  }
  if (DATA.name) {
    LLL++;
  }
  if (DATA.address) {
    List<String> addressParts = DATA.ADDRESSS.split("//");

    if (addressParts.length > 0) {
      for (int i = 0; i < addressParts.length; i++) {
        LLL++;
      }
    } else {
      LLL++;
    }
  }
  if (DATA.phone) {
    LLL++;
  }

  if (DATA.text1) {
    LLL++;
  }
  if (DATA.text2) {
    LLL++;
  }

  if (DATA.tax) {
    LLL++;
  }
  if (DATA.sn) {
    LLL++;
  }

  for (int i = 0; i < bills.get_all().length; i++) {
    LLL += 2;
  }
  if (systems.get_all()[0].discount_mode) {
    LLL += 2;
  }
  if (systems.get_all()[0].vat_mode) {
    LLL += 3;
  }

  double pageWidth = 600; // Convert mm to points (1 mm = 2.83465 points)
  pageHeight = pageHeight + ((LLL + (Lenghtbill * 2)) * 15) + 200; // Adjust height as needed
  if (pageHeight < 600) {
    pageHeight = 600;
  }
  pdf.pageSettings.size = Size(pageWidth, pageHeight);
  const double marginLeft = 5.0;
  const double marginRight = 5.0;
  const double marginTop = 0.0;
  const double marginBottom = 5.0;

  pdf.pageSettings.margins.all = 0.0;
  pdf.pageSettings.margins.left = marginLeft;
  pdf.pageSettings.margins.right = marginRight;
  pdf.pageSettings.margins.top = marginTop;
  pdf.pageSettings.margins.bottom = marginBottom;

  PdfPage page = pdf.pages.add();
  double y = 0;
  int L = 0;
  ////////////////////////////////////////////////////////////////////////

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(now);

  final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
  final localDatabase = LocalDatabase();

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
        sum_money = sum_money + double.parse(bills.get_all()[i].price) * double.parse(bills.get_all()[i].weight);
      } else {
        sum_money = sum_money + double.parse(bills.get_all()[i].price) * bills.get_all()[i].item;
      }

      sum_money_t = sum_money; ////****** */
    }
    if (systems.get_all()[0].discount_mode) {
      discount = (sum_money * customers.get_discount_form_type(customers.get_display_type()) / 100);
    }

    sum_money_before_vat = sum_money - discount;

    if (systems.get_all()[0].vat_mode) {
      vat = (sum_money * double.parse(systems.get_all()[0].vat) / 100);
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

  String _data_buff = "";
  ////////////////////////////////////////////////////////////////////////

  if (DATA.pic) {
    String base64String = Provider.of<edit_bill_provider>(context, listen: false).get_all()[0].PICTURE;
    Uint8List imageBytes = base64Decode(base64String);
    PdfBitmap image = PdfBitmap(imageBytes);

    page.graphics.drawImage(image, Rect.fromLTWH(100, 0, 200, 200));

    y = y + 200;
  }

  if (DATA.name) {
    L = await LENGHT_DATA_THAI(DATA.NAMES);

    page.graphics.drawString(
      DATA.NAMES,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  if (DATA.address) {
    List<String> addressParts = DATA.ADDRESSS.split("//");

    if (addressParts.length > 0) {
      for (int i = 0; i < addressParts.length; i++) {
        L = await LENGHT_DATA_THAI(addressParts[i]);

        page.graphics.drawString(
          addressParts[i],
          FONT[0],
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 400, 30),
          format: PdfStringFormat(),
        );

        y += 30;
      }
    } else {
      L = await LENGHT_DATA_THAI(DATA.ADDRESSS);

      page.graphics.drawString(
        DATA.NAMES,
        FONT[0],
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 400, 30),
        format: PdfStringFormat(),
      );

      y += 30;
    }
  }

  if (DATA.phone) {
    // จาก tax เป็น sn
    L = await LENGHT_DATA_THAI(DATA.PHONSE); //systems.get_all()[0].PHONSE

    page.graphics.drawString(
      DATA.PHONSE,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 300, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  if (DATA.tax) {
    // จาก tax เป็น sn
    L = await LENGHT_DATA_THAI("TAX# " + systems.get_all()[0].vat_num); //systems.get_all()[0].PHONSE

    page.graphics.drawString(
      "TAX# " + systems.get_all()[0].vat_num,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 300, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  if (DATA.text1) {
    // จาก tax เป็น sn
    L = await LENGHT_DATA_THAI(DATA.TEXT1S); //systems.get_all()[0].PHONSE

    page.graphics.drawString(
      DATA.TEXT1S,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 300, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  if (DATA.head) {
    // จาก tax เป็น sn
    L = await LENGHT_DATA_THAI(DATA.HEADS); //systems.get_all()[0].PHONSE

    page.graphics.drawString(
      DATA.HEADS,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 300, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  if (DATA.sn) {
    // จาก tax เป็น sn
    L = await LENGHT_DATA_THAI(systems.get_all()[0].SN + "  " + formattedDate); //systems.get_all()[0].PHONSE

    page.graphics.drawString(
      systems.get_all()[0].SN + "  " + formattedDate,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 600, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  if (DATA.id_bill) {
    // จาก tax เป็น sn
    L = await LENGHT_DATA_THAI(" รหัสใบเสร็จที่ " + INDEXString); //systems.get_all()[0].PHONSE

    page.graphics.drawString(
      " รหัสใบเสร็จที่ " + INDEXString,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 600, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  page.graphics.drawString(
    "-------------------------------------------------------------",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(10, y, 400, 30),
    format: PdfStringFormat(),
  );
  y += 30;

  for (int i = 0; i < Lenghtbill; i++) {
    page.graphics.drawString(
      (i + 1).toString() + ". " + DATA_bill[i].name,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(0, y, 400, 30),
      format: PdfStringFormat(),
    );

    y += 30;

    if (DATA_bill[i].unit == "KG") {
      _data_buff = "@" + DATA_bill[i].weight + "*" + double.parse(DATA_bill[i].price).toStringAsFixed(2) + " (kg)";
    } else {
      _data_buff = "@" + DATA_bill[i].item.toString() + "*" + double.parse(DATA_bill[i].price).toStringAsFixed(2) + " (p)";
    }
    L = await LENGHT_DATA_THAI(_data_buff);

    page.graphics.drawString(
      _data_buff,
      FONT[1],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, y, 200, 30), //390 - (L * 12)
      format: PdfStringFormat(),
    );

    if (DATA_bill[i].unit == "KG") {
      _data_buff = (double.parse(DATA_bill[i].weight) * double.parse(DATA_bill[i].price)).toStringAsFixed(2) + "บ.";
    } else {
      _data_buff = (DATA_bill[i].item * double.parse(DATA_bill[i].price)).toStringAsFixed(2) + "บ.";
    }
    L = await LENGHT_DATA_THAI(_data_buff);

    page.graphics.drawString(
      _data_buff,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(390 - (L * 12), y, 150, 30),
      format: PdfStringFormat(),
    );

    y += 30;
  }
  page.graphics.drawString(
    "-------------------------------------------------------------",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(0, y, 400, 30),
    format: PdfStringFormat(),
  );
  y += 30;
  if (systems.get_all()[0].weight_mode) {
    _data_buff = "จำนวน " + Lenghtbill.toString() + " รายการ " + "${item_all} ชิ้น "; //+ "หนัก " + "(${sum_weight})"
  } else {
    _data_buff = "จำนวน " + Lenghtbill.toString() + " รายการ " + "${item_all} ชิ้น ";
  }

  //L = await LENGHT_DATA_THAI("จำนวน " + Lenghtbill.toString() + " รายการ " + "(${item_all}) ")
  L = await LENGHT_DATA_THAI(_data_buff);
  page.graphics.drawString(
    _data_buff,
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(400 - (L * 12), y, 400, 30),
    format: PdfStringFormat(),
  );
  y += 30;

  page.graphics.drawString(
    "-------------------------------------------------------------",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(0, y, 400, 30),
    format: PdfStringFormat(),
  );
  y += 30;

  page.graphics.drawString(
    "ทั้งหมด",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(50, y, 100, 30),
    format: PdfStringFormat(),
  );
  page.graphics.drawString(
    sum_money_t.toStringAsFixed(2) + " บ.",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(390 - (sum_money_t.toStringAsFixed(2) + " บ.").length * 12, y, 400, 30),
    format: PdfStringFormat(),
  );
  y += 30;

  if (systems.get_all()[0].discount_mode) {
    page.graphics.drawString(
      "ส่วนลด " + (customers.get_discount_form_type(customers.get_display_type())).toString() + "%",
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(50, y, 400, 30),
      format: PdfStringFormat(),
    );

    page.graphics.drawString(
      discount.toStringAsFixed(2) + " บ.",
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(390 - (discount.toStringAsFixed(2) + " บ.").length * 12, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  /* page.graphics.drawString(
    sum_money_before_vat.toString() + "เหลือ",
    thaiFont7,
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(0, y, 400, 50),
    format: PdfStringFormat(),
  );
  y += 50;*/
  if (systems.get_all()[0].vat_mode) {
    page.graphics.drawString(
      "ภาษี " + systems.get_all()[0].vat + "%",
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(50, y, 150, 30),
      format: PdfStringFormat(),
    );

    page.graphics.drawString(
      vat.toStringAsFixed(2) + " บ.",
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(390 - (vat.toStringAsFixed(2) + " บ.").length * 12, y, 150, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }
  if (systems.get_all()[0].vat_mode || systems.get_all()[0].discount_mode) {
    page.graphics.drawString(
      "รวมเป็น",
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(50, y, 150, 30),
      format: PdfStringFormat(),
    );

    page.graphics.drawString(
      sum_money.toStringAsFixed(2) + " บ.",
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(390 - (sum_money.toStringAsFixed(2) + " บ.").length * 12, y, 150, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }

  page.graphics.drawString(
    "รับมา",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(50, y, 150, 30),
    format: PdfStringFormat(),
  );

  page.graphics.drawString(
    pay_money.toStringAsFixed(2) + " บ.",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(390 - (pay_money.toStringAsFixed(2) + " บ.").length * 12, y, 150, 30),
    format: PdfStringFormat(),
  );
  y += 30;

  page.graphics.drawString(
    "ทอน",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(50, y, 150, 30),
    format: PdfStringFormat(),
  );

  page.graphics.drawString(
    pay_back.toStringAsFixed(2) + " บ.",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(390 - (pay_back.toStringAsFixed(2) + " บ.").length * 12, y, 150, 30),
    format: PdfStringFormat(),
  );
  /* y += 30;
  //if (DATA.text1) {
  L = await LENGHT_DATA_THAI("รหัสใบเสร็จ " + INDEXString + " " + systems.get_all()[0].cashier);

  page.graphics.drawString(
    "รหัสใบเสร็จ" + INDEXString + " " + systems.get_all()[0].cashier,
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 400, 30),
    format: PdfStringFormat(),
  );
  y += 30;
  L = await LENGHT_DATA_THAI(formattedDate);

  page.graphics.drawString(
    formattedDate,
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 400, 30),
    format: PdfStringFormat(),
  );*/
  y += 30;
  if (DATA.text2) {
    L = await LENGHT_DATA_THAI(DATA.TEXT2S);

    page.graphics.drawString(
      DATA.TEXT2S,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 300, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }
  //}
  // ทั้งหมด
  // ลด
  // vat
  //  net
  //  รับมา
  //  ทอน

  final pdfDoc = await pdf_render.PdfDocument.openData(Uint8List.fromList(pdf.saveSync())); // แปลงเป็น Uint8List ก่อนใช้งาน

  final pdfPage = await pdfDoc.getPage(1);
  final pageImage = await pdfPage.render();

  var images = img.Image.fromBytes(
    pageImage.width,
    pageImage.height,
    pageImage.pixels,
  );

  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  byte += generator.imageRaster(images, align: PosAlign.left);
  byte += generator.cut();
  byte += generator.drawer();

  return byte;
}
