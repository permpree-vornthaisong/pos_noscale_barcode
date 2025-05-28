import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

Future<void> senddata_display(String DATA) async {
  List<UsbDevice> devices = await UsbSerial.listDevices();
  late UsbDevice device;

  if (devices.isNotEmpty) {
    for (int i = 0; i < devices.length; i++) {
      if (devices[i].productName == "USB2.0-Serial") {
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
      await port.setPortParameters(115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE); //9600  115200

      String message = "page page1";
      List<int> asciiBytes = message.codeUnits; // แปลงข้อความเป็นรหัส ASCII
      if (DATA == "page1") {
        Uint8List data =
            Uint8List.fromList([0x70, 0x61, 0x67, 0x65, 0x20, 0x70, 0x61, 0x67, 0x65, 0x31, 0xFF, 0xFF, 0xFF]); // เชื่อมรหัส ASCII กับข้อมูลสุดท้าย
        await port?.write(data); // ส่งข้อมูลทั้งหมดไปยังพอร์ต
        await Future.delayed(Duration(milliseconds: 50));
      } else if (DATA == "page0") {
        Uint8List data =
            Uint8List.fromList([0x70, 0x61, 0x67, 0x65, 0x20, 0x70, 0x61, 0x67, 0x65, 0x30, 0xFF, 0xFF, 0xFF]); // เชื่อมรหัส ASCII กับข้อมูลสุดท้าย
        await port?.write(data); // ส่งข้อมูลทั้งหมดไปยังพอร์ต
        await Future.delayed(Duration(milliseconds: 50));
      } else {
        Uint8List data =
            Uint8List.fromList([0x70, 0x61, 0x67, 0x65, 0x20, 0x70, 0x61, 0x67, 0x65, 0x30, 0xFF, 0xFF, 0xFF]); // เชื่อมรหัส ASCII กับข้อมูลสุดท้าย
        await port?.write(data); // ส่งข้อมูลทั้งหมดไปยังพอร์ต
        await Future.delayed(Duration(milliseconds: 50));
      }

      await port.close();
    } else {}
  }
}
