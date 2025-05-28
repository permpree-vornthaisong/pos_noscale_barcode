import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
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
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/format1.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/stock.dart';
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

class PrinterManagerClass with ChangeNotifier {
  PrinterType defaultPrinterType = PrinterType.bluetooth;
  bool isBle = false;
  bool reconnect = false;
  bool isConnected = false;
  PrinterManager? _printerManager;
  List<BluetoothPrinter> devices = [];
  BluetoothPrinter? selectedPrinter;
  List<int>? pendingTask;
  String ipAddress = '';
  String port = '9100';
  final ipController = TextEditingController();
  final portController = TextEditingController();
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  BTStatus _currentStatus = BTStatus.none;
  USBStatus _currentUsbStatus = USBStatus.none;

////////////////////////////////////////

  late Uint8List pic;
  late PdfTrueTypeFont thaiFont5;

  late PdfTrueTypeFont thaiFont6;
  late PdfTrueTypeFont thaiFont7;
  late PdfTrueTypeFont thaiFont8;
  late PdfTrueTypeFont thaiFont9;
  late PdfTrueTypeFont thaiFont10;
  late PdfTrueTypeFont BOLD;
  late PdfTrueTypeFont BOLD2;

  late Uint8List PIG_PIC;

  Future<void> set_data(context) async {
    final fontData = await loadFontData('assets/font/Sarabun-Thin.ttf');
    final BOLDs = await loadFontData('assets/font/Sarabun-ExtraBoldItalic.ttf');
    thaiFont5 = PdfTrueTypeFont(fontData, 16, style: PdfFontStyle.bold);

    thaiFont6 = PdfTrueTypeFont(fontData, 22, style: PdfFontStyle.bold);

    thaiFont7 = PdfTrueTypeFont(fontData, 26, style: PdfFontStyle.bold);
    thaiFont8 = PdfTrueTypeFont(fontData, 32, style: PdfFontStyle.bold);
    thaiFont9 = PdfTrueTypeFont(fontData, 34, style: PdfFontStyle.bold);
    thaiFont10 = PdfTrueTypeFont(fontData, 36, style: PdfFontStyle.bold);

    BOLD = PdfTrueTypeFont(BOLDs, 48, style: PdfFontStyle.bold);
    BOLD2 = PdfTrueTypeFont(BOLDs, 32, style: PdfFontStyle.bold);
  }

  List<PdfTrueTypeFont> getfont() {
    return [thaiFont6, thaiFont5, thaiFont8, thaiFont9, BOLD2];
  }

  PrinterManager_start() {
    _initialize();
  }

  void _initialize() {
    _printerManager = PrinterManager.instance;
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;

    portController.text = port;
    scanDevices();

    _subscriptionBtStatus = _printerManager!.stateBluetooth.listen((status) {
      log(' ----------------- status bt $status ------------------ ');
      _currentStatus = status;
      isConnected = status == BTStatus.connected;
      notifyListeners(); // Notify listeners of the state change
      if (status == BTStatus.connected && pendingTask != null) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _printerManager!.send(type: PrinterType.bluetooth, bytes: pendingTask!);
          pendingTask = null;
        });
      }
    });

    _subscriptionUsbStatus = _printerManager!.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
      _currentUsbStatus = status;
      if (status == USBStatus.connected && pendingTask != null) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _printerManager!.send(type: PrinterType.usb, bytes: pendingTask!);
          pendingTask = null;
        });
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }

  void scanDevices() {
    devices.clear();
    _subscription = _printerManager!.discovery(type: defaultPrinterType, isBle: isBle).listen((device) {
      devices.add(BluetoothPrinter(
        deviceName: device.name,
        address: device.address,
        isBle: isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      ));
      if (selectedPrinter != null) {
        if (device.address != selectedPrinter!.address) {
          _printerManager!.disconnect(type: selectedPrinter!.typePrinter);
        }
      }
      selectedPrinter = null;
      notifyListeners(); // Notify listeners of the change
    });
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    port = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: ipAddress,
      port: port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
    notifyListeners(); // Notify listeners of the change
  }

  void setIpAddress(String value) {
    ipAddress = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: ipAddress,
      port: port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
    notifyListeners(); // Notify listeners of the change
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) || (device.typePrinter == PrinterType.usb && selectedPrinter!.vendorId != device.vendorId)) {
        await _printerManager!.disconnect(type: selectedPrinter!.typePrinter);
      }
    }
    selectedPrinter = device;
    notifyListeners(); // Notify listeners of the change
  }

  Future<Uint8List> loadFontData(String fontPath) async {
    final ByteData data = await rootBundle.load(fontPath);
    return data.buffer.asUint8List();
  }

  Future<void> printTestTicket(context) async {
    // List<int> DATA = await _main_print(context);
    await _printEscPos(await form1(context), context);

    //  _printEscPos(bytes, generator);
  }

  Future<void> print_sum_stock(context) async {
    // List<int> DATA = await _main_print(context);
    await _printEscPos(await print_stock(context), context);

    //  _printEscPos(bytes, generator);
  }

  Future<void> drawer_manual(context) async {
    // List<int> DATA = await _main_print(context);
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //byte += generator.imageRaster(images, align: PosAlign.left);
    //byte += generator.cut();
    bytes += generator.drawer();

    await _printEscPos(bytes, context);

    //  _printEscPos(bytes, generator);
  }

  Future<void> _printEscPos(List<int> bytes, context) async {
    if (selectedPrinter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('no printter connected'),
        ),
      );

      return;
    }

    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        /* ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('USB'),
          ),
        );*/
        await _printerManager!.connect(
            type: selectedPrinter!.typePrinter,
            model: UsbPrinterInput(name: selectedPrinter!.deviceName, productId: selectedPrinter!.productId, vendorId: selectedPrinter!.vendorId));
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        /* ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BLUETOOTH_in'),
          ),
        );*/
        try {
          await _printerManager!.connect(
            type: selectedPrinter!.typePrinter,
            model: BluetoothPrinterInput(
              name: selectedPrinter!.deviceName,
              address: selectedPrinter!.address!,
              isBle: selectedPrinter!.isBle!,
              autoConnect: false,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('BLUETOOTH_try'),
            ),
          );
          await Future.delayed(const Duration(milliseconds: 500), () {});

          await _printerManager!.send(type: PrinterType.bluetooth, bytes: bytes);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BLUETOOTH_end'),
          ),
        );
        // pendingTask = null;
        pendingTask = bytes;
        break;
      case PrinterType.network:
        await _printerManager!.connect(type: selectedPrinter!.typePrinter, model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        break;
      default:
    }
    if (selectedPrinter!.typePrinter == PrinterType.bluetooth) {
      /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('print_BLUETOOTH'),
        ),
      );
      if (_currentStatus == BTStatus.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('print_BLUETOOTH2'),
          ),
        );

        _printerManager!.send(type: selectedPrinter!.typePrinter, bytes: bytes);
        pendingTask = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('print_BLUETOOTH2'),
          ),
        );
      }*/
    } else {
      _printerManager!.send(type: selectedPrinter!.typePrinter, bytes: bytes);
      pendingTask = null;
      /*  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('print_'),
        ),
      );*/
      // _printerManager!.send(type: selectedPrinter!.typePrinter, bytes: bytes);
    }
  }

  Future<void> connectDevice(context) async {
    isConnected = false;
    if (selectedPrinter == null) return;

    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await _printerManager!.connect(
            type: selectedPrinter!.typePrinter,
            model: UsbPrinterInput(name: selectedPrinter!.deviceName, productId: selectedPrinter!.productId, vendorId: selectedPrinter!.vendorId));
        isConnected = true;
        break;
      case PrinterType.bluetooth:
        if (selectedPrinter!.isBle == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('BLUETOOTH_in_BLE'),
            ),
          );
          await _printerManager!.connect(
              type: selectedPrinter!.typePrinter,
              model: BluetoothPrinterInput(
                  name: selectedPrinter!.deviceName,
                  address: selectedPrinter!.address!,
                  isBle: true, //selectedPrinter!.isBle ?? false
                  autoConnect: false));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('BLUETOOTH_in_commond'),
            ),
          );
          await _printerManager!.connect(
              type: selectedPrinter!.typePrinter,
              model: BluetoothPrinterInput(name: selectedPrinter!.deviceName, address: selectedPrinter!.address!, isBle: false, autoConnect: false));
        }

        break;
      case PrinterType.network:
        await _printerManager!.connect(type: selectedPrinter!.typePrinter, model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        isConnected = true;
        break;
      default:
    }
    notifyListeners(); // Notify listeners of the change
  }

  Future<void> disconnectDevice() async {
    if (selectedPrinter != null) {
      await _printerManager!.disconnect(type: selectedPrinter!.typePrinter);
      isConnected = false;
      notifyListeners(); // Notify listeners of the change
    }
  }

  void reset() {
    isConnected = false;
    selectedPrinter = null;
    pendingTask = null;
    notifyListeners(); // Notify listeners of the change
  }
/*
  Future<List<int>> _main_print(context) async {
    final edit_bills = Provider.of<edit_bill_provider>(context, listen: false);
    List<int> byte = [];

    final DATA = edit_bills.get_all()[0];
    final PdfDocument pdf = PdfDocument();
    double pageWidth = 600; // Convert mm to points (1 mm = 2.83465 points)
    double pageHeight = 600; // Adjust height as needed

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

    final bill_provider bills = Provider.of<bill_provider>(context, listen: false);

    final customer_provider customers = Provider.of<customer_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    final localDatabase = LocalDatabase();
    List<data_product> DATA_bill = bills.get_all();

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

    int Lenghtbill = DATA_bill.length;
    String _data_buff = "";
    ////////////////////////////////////////////////////////////////////////
    if (DATA.head) {
      L = await LENGHT_DATA_THAI(DATA.HEADS);

      page.graphics.drawString(
        DATA.HEADS,
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 400, 30),
        format: PdfStringFormat(),
      );
      y += 30;
    }

    if (DATA.name) {
      L = await LENGHT_DATA_THAI(DATA.NAMES);

      page.graphics.drawString(
        DATA.NAMES,
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 300, 30),
        format: PdfStringFormat(),
      );

      y += 30;
    }

    if (DATA.tax) {
      L = await LENGHT_DATA_THAI(DATA.TAXS);

      page.graphics.drawString(
        DATA.TAXS,
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 300, 30),
        format: PdfStringFormat(),
      );
      y += 30;
    }

    page.graphics.drawString(
      "-------------------------------------------------------------",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(10, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;

    for (int i = 0; i < Lenghtbill; i++) {
      page.graphics.drawString(
        DATA_bill[i].name,
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, y, 150, 30),
        format: PdfStringFormat(),
      );

      if (DATA_bill[i].unit == "KG") {
        _data_buff = "@" + DATA_bill[i].weight + "*" + DATA_bill[i].price;
      } else {
        _data_buff = "@" + DATA_bill[i].item.toString() + "*" + DATA_bill[i].price;
      }

      page.graphics.drawString(
        _data_buff,
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(150, y, 150, 30),
        format: PdfStringFormat(),
      );

      if (DATA_bill[i].unit == "KG") {
        _data_buff = (DATA_bill[i].item * double.parse(DATA_bill[i].price)).toStringAsFixed(2) + "บ.";
      } else {
        _data_buff = (double.parse(DATA_bill[i].weight) * double.parse(DATA_bill[i].price)).toStringAsFixed(2) + "บ.";
      }
      L = await LENGHT_DATA_THAI(_data_buff);

      page.graphics.drawString(
        _data_buff,
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(390 - (L * 12), y, 150, 30),
        format: PdfStringFormat(),
      );

      y += 30;
    }
    page.graphics.drawString(
      "-------------------------------------------------------------",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(0, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;
    if (systems.get_all()[0].weight_mode) {
      _data_buff = "จำนวน " + Lenghtbill.toString() + " รายการ " + "(${item_all})" + "หนัก " + "(${sum_weight})";
    } else {
      _data_buff = "จำนวน " + Lenghtbill.toString() + " รายการ " + "(${item_all}) ";
    }

    //L = await LENGHT_DATA_THAI("จำนวน " + Lenghtbill.toString() + " รายการ " + "(${item_all}) ")
    L = await LENGHT_DATA_THAI(_data_buff);
    page.graphics.drawString(
      _data_buff,
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(400 - (L * 12), y, 250, 30),
      format: PdfStringFormat(),
    );
    y += 30;

    page.graphics.drawString(
      "-------------------------------------------------------------",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(0, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;

    page.graphics.drawString(
      "ทั้งหมด",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(50, y, 100, 30),
      format: PdfStringFormat(),
    );
    page.graphics.drawString(
      sum_money_t.toStringAsFixed(2) + " บ.",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(400 - (sum_money_t.toStringAsFixed(2) + " บ.").length * 12, y, 100, 30),
      format: PdfStringFormat(),
    );
    y += 30;

    if (systems.get_all()[0].discount_mode) {
      page.graphics.drawString(
        "ส่วนลด",
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(50, y, 100, 30),
        format: PdfStringFormat(),
      );

      page.graphics.drawString(
        discount.toStringAsFixed(2) + " บ.",
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(400 - (discount.toStringAsFixed(2) + " บ.").length * 12, y, 400, 30),
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
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(50, y, 150, 30),
        format: PdfStringFormat(),
      );

      page.graphics.drawString(
        vat.toStringAsFixed(2) + " บ.",
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(400 - (vat.toStringAsFixed(2) + " บ.").length * 12, y, 150, 30),
        format: PdfStringFormat(),
      );
      y += 30;
    }
    if (systems.get_all()[0].vat_mode || systems.get_all()[0].discount_mode) {
      page.graphics.drawString(
        "รวมเป็น",
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(50, y, 150, 30),
        format: PdfStringFormat(),
      );

      page.graphics.drawString(
        sum_money.toStringAsFixed(2) + " บ.",
        thaiFont6,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(400 - (sum_money.toStringAsFixed(2) + " บ.").length * 12, y, 150, 30),
        format: PdfStringFormat(),
      );
      y += 30;
    }

    page.graphics.drawString(
      "รับมา",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(50, y, 150, 30),
      format: PdfStringFormat(),
    );

    page.graphics.drawString(
      pay_money.toStringAsFixed(2) + " บ.",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(400 - (pay_money.toStringAsFixed(2) + " บ.").length * 12, y, 150, 30),
      format: PdfStringFormat(),
    );
    y += 30;

    page.graphics.drawString(
      "ทอน",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(50, y, 150, 30),
      format: PdfStringFormat(),
    );

    page.graphics.drawString(
      pay_back.toStringAsFixed(2) + " บ.",
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(400 - (pay_back.toStringAsFixed(2) + " บ.").length * 12, y, 150, 30),
      format: PdfStringFormat(),
    );
    y += 30;
    //if (DATA.text1) {
    L = await LENGHT_DATA_THAI("รหัสใบเสร็จ " + INDEXString + " " + systems.get_all()[0].cashier);

    page.graphics.drawString(
      "รหัสใบเสร็จ" + INDEXString + " " + systems.get_all()[0].cashier,
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;
    L = await LENGHT_DATA_THAI(formattedDate);

    page.graphics.drawString(
      formattedDate,
      thaiFont6,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(210 - (L * 12) / 2, y, 400, 30),
      format: PdfStringFormat(),
    );
    y += 30;
    if (DATA.text1) {
      L = await LENGHT_DATA_THAI(DATA.TEXT1S);

      page.graphics.drawString(
        DATA.TEXT1S,
        thaiFont6,
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
  }*/
}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter({
    this.deviceName,
    this.address,
    this.port,
    this.state,
    this.vendorId,
    this.productId,
    this.typePrinter = PrinterType.bluetooth,
    this.isBle = false,
  });
}
