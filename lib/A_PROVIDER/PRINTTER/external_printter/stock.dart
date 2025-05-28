import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/printter_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/thail_cut.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Stock_provider.dart';
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

Future<List<int>> print_stock(context) async {
  final PrinterManagers = Provider.of<PrinterManagerClass>(context, listen: false);
  final stock_displays = Provider.of<stock_display_provider>(context, listen: false);

  List<PdfTrueTypeFont> FONT = PrinterManagers.getfont();
  List<int> byte = [];
  int LL = stock_displays.get_data().length;
  final PdfDocument pdf = PdfDocument();
  double pageWidth = 600; // Convert mm to points (1 mm = 2.83465 points)
  double pageHeight = 200 + (LL * 80); // Adjust height as needed
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

  L = await LENGHT_DATA_THAI("sum stock");

  page.graphics.drawString(
    "sum stock",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 150, 30),
    format: PdfStringFormat(),
  );
  y += 30;

  page.graphics.drawString(
    "-------------------------------------------------------------",
    FONT[0],
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(10, y, 400, 30),
    format: PdfStringFormat(),
  );
  y += 30;

  for (int i = 0; i < stock_displays.get_data().length; i++) {
    page.graphics.drawString(
      (i + 1).toString() + ". " + stock_displays.get_data()[i].id,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, y, 400, 30),
      format: PdfStringFormat(),
    );
    page.graphics.drawString(
      stock_displays.get_data()[i].type,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(140, y, 400, 30),
      format: PdfStringFormat(),
    );
    page.graphics.drawString(
      stock_displays.get_data()[i].name,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(240, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;
    page.graphics.drawString(
      "SUM",
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(140, y, 400, 30),
      format: PdfStringFormat(),
    );
    page.graphics.drawString(
      stock_displays.get_data()[i].sum.toString() + " " + stock_displays.get_data()[i].units,
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(240, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;

    page.graphics.drawString(
      "-------------------------------------------------------------",
      FONT[0],
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;
  }
  final pdfDoc = await pdf_render.PdfDocument.openData(Uint8List.fromList(pdf.saveSync())); // แปลงเป็น Uint8List ก่อนใช้งาน

  final pdfPage = await pdfDoc.getPage(1);
  final pageImage = await pdfPage.render();

  var images = img.Image.fromBytes(
    pageImage.width,
    pageImage.height,
    pageImage.pixels,
  );
  /*
  resize image
  x = width
 y =  50 + (LL * 32); */

  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  byte += generator.imageRaster(img.copyCrop(images, 0, 0, pageWidth.toInt(), 200 + (LL * 80)), align: PosAlign.left);
  byte += generator.cut();

  return byte;
}
