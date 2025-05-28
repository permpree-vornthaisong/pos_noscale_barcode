package com.example.pos_noscale_barcode;

import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;

public class MainActivity extends FlutterActivity {

  // **CHANNEL สำหรับ Printer (ตรงกับ 'platform' ใน Flutter)**
  private static final String PRINTER_CHANNEL =
    "com.example.pos_noscale_barcode/printer";
  // **CHANNEL สำหรับ WeightReader (ตรงกับ '_channel' ใน Flutter)**
  private static final String WEIGHT_CHANNEL =
    "com.example.pos_noscale_barcode/printer_weight";

  // แก้ไข 'private private' เป็น 'private'
  private static final String TAG = "MainActivity";
  private PrinterNative printerNative;
  private WeightReader weightReader;

  // ไม่จำเป็นต้องมี isPortOpen หรือ isWeightPortOpen ที่นี่แล้ว
  // เพราะ PrinterNative และ WeightReader จะดูแลสถานะการเปิดพอร์ตของตัวเอง
  // และ MainActivity จะเรียก isPortCurrentlyOpen() จาก PrinterNative/WeightReader โดยตรง

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    printerNative = new PrinterNative(getContext());
    weightReader = new WeightReader();

    // **MethodChannel สำหรับ Printer operations**
    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      PRINTER_CHANNEL // ใช้ PRINTER_CHANNEL เพื่อให้ตรงกับ 'platform' ใน Flutter
    ).setMethodCallHandler((call, result) -> {
      String portPath;
      byte[] printData;
      boolean success;

      switch (call.method) {
        case "getPorts":
          ArrayList<String> ports = new ArrayList<>();
          File dev = new File("/dev");
          File[] files = dev.listFiles((dir, name) -> name.startsWith("tty"));
          if (files != null) {
            for (File file : files) {
              ports.add(file.getAbsolutePath());
            }
          }
          result.success(ports);
          break;
        case "openPort":
          portPath = call.argument("portPath");
          Integer baudRateInteger = call.argument("baudRate");
          if (portPath == null || baudRateInteger == null) {
            result.error(
              "INVALID_ARGUMENTS",
              "Port path and baud rate required",
              null
            );
            return;
          }
          int baudRate = baudRateInteger.intValue();

          // ตรวจสอบพอร์ตขัดแย้งกับ WeightReader ก่อนเปิด
          if (weightReader.isPortCurrentlyOpen(portPath, baudRate)) {
            result.error(
              "PORT_CONFLICT",
              "Port " + portPath + " is currently in use by WeightReader.",
              null
            );
            return;
          }

          success = printerNative.openPort(portPath, baudRate);
          if (success) {
            result.success("Port opened successfully");
          } else {
            result.error("OPEN_ERROR", "Failed to open printer port", null);
          }
          break;
        case "sendFeedCommand":
          portPath = call.argument("portPath");
          if (portPath == null) {
            result.error("INVALID_PORT", "Port path is required", null);
            return;
          }
          // ตรวจสอบว่าพอร์ตของ PrinterNative เปิดอยู่หรือไม่
          if (!printerNative.isPortCurrentlyOpen(portPath, 115200)) { // ใช้ baudRate ที่คุณใช้เปิด port เครื่องพิมพ์
            result.error(
              "PORT_CLOSED",
              "Printer port is not open or parameters mismatched",
              null
            );
            return;
          }

          success = printerNative.sendCommand(portPath);
          if (success) {
            result.success("Command sent successfully");
          } else {
            result.error("SEND_ERROR", "Failed to send command", null);
          }
          break;
        case "closePort": // ปิดพอร์ตเครื่องพิมพ์
          printerNative.closePort();
          result.success("Printer port closed");
          break;
        case "printTestPattern":
          String testPortPath = call.argument("portPath");
          if (testPortPath == null) {
            result.error("INVALID_PORT", "Port path is required", null);
            return;
          }
          if (!printerNative.isPortCurrentlyOpen(testPortPath, 115200)) { // ใช้ baudRate ที่คุณใช้เปิด port เครื่องพิมพ์
            result.error(
              "PORT_CLOSED",
              "Printer port is not open or parameters mismatched",
              null
            );
            return;
          }
          boolean testSuccess = printerNative.printTestPattern(testPortPath);
          if (testSuccess) {
            result.success("Test pattern printed successfully");
          } else {
            result.error("PRINT_ERROR", "Failed to print test pattern", null);
          }
          break;
        case "printText":
          portPath = call.argument("portPath");
          printData = call.argument("data");

          if (portPath == null || printData == null) {
            result.error(
              "INVALID_ARGUMENTS",
              "Port path and data required",
              null
            );
            return;
          }
          if (!printerNative.isPortCurrentlyOpen(portPath, 115200)) { // ใช้ baudRate ที่คุณใช้เปิด port เครื่องพิมพ์
            result.error(
              "PORT_CLOSED",
              "Printer port is not open or parameters mismatched",
              null
            );
            return;
          }

          success = printerNative.printText(portPath, printData);
          if (success) {
            result.success(true);
          } else {
            result.error("PRINT_ERROR", "Failed to print text", null);
          }
          break;
        case "feedLines":
          String feedPortPath = call.argument("portPath");
          Integer lines = call.argument("lines");
          if (feedPortPath == null || lines == null) {
            result.error("INVALID_ARGS", "Port path and lines required", null);
            return;
          }
          if (!printerNative.isPortCurrentlyOpen(feedPortPath, 115200)) { // ใช้ baudRate ที่คุณใช้เปิด port เครื่องพิมพ์
            result.error(
              "PORT_CLOSED",
              "Printer port is not open or parameters mismatched",
              null
            );
            return;
          }
          boolean feedSuccess = printerNative.feedLines(feedPortPath, lines);
          if (feedSuccess) {
            result.success("Fed " + lines + " lines successfully");
          } else {
            result.error("FEED_ERROR", "Failed to feed paper", null);
          }
          break;
        case "printBytes":
          String bytesPortPath = call.argument("portPath");
          byte[] bytesData = call.argument("data");

          if (bytesPortPath == null || bytesData == null) {
            result.error(
              "INVALID_ARGUMENTS",
              "Port path and data required",
              null
            );
            return;
          }
          if (!printerNative.isPortCurrentlyOpen(bytesPortPath, 115200)) { // ใช้ baudRate ที่คุณใช้เปิด port เครื่องพิมพ์
            result.error(
              "PORT_CLOSED",
              "Printer port is not open or parameters mismatched",
              null
            );
            return;
          }

          boolean bytesPrintSuccess = printerNative.printBytes(
            bytesPortPath,
            bytesData
          );
          if (bytesPrintSuccess) {
            result.success(true);
          } else {
            result.error("PRINT_ERROR", "Failed to print bytes", null);
          }
          break;
        default:
          result.notImplemented();
          break;
      }
    });

    // **MethodChannel สำหรับ WeightReader operations**
    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      WEIGHT_CHANNEL // ใช้ WEIGHT_CHANNEL เพื่อให้ตรงกับ '_channel' ใน Flutter
    ).setMethodCallHandler((call, result) -> {
      String portPath;
      Integer baudRateReadInteger;
      int baudRateRead;

      switch (call.method) {
        case "readWeight":
          portPath = call.argument("portPath");
          baudRateReadInteger = call.argument("baudRate");

          if (portPath == null || baudRateReadInteger == null) {
            result.error(
              "INVALID_ARGUMENTS",
              "Port path and baud rate required",
              null
            );
            return;
          }
          baudRateRead = baudRateReadInteger.intValue();

          // ตรวจสอบพอร์ตขัดแย้งกับ PrinterNative ก่อนเรียกอ่านน้ำหนัก
          if (printerNative.isPortCurrentlyOpen(portPath, baudRateRead)) {
            result.error(
              "PORT_CONFLICT",
              "Port " + portPath + " is currently in use by PrinterNative.",
              null
            );
            return;
          }

          // เรียกใช้เมธอด readAndLogRawData จาก WeightReader
          // WeightReader จะจัดการการเปิด/ปิดพอร์ตของตัวเอง
          String rawData = weightReader.readAndLogRawData(
            portPath,
            baudRateRead
          );
          if (rawData != null) {
            result.success(rawData);
          } else {
            result.error(
              "READ_ERROR",
              "Failed to read raw data from scale",
              null
            );
          }
          break;
        case "closeWeightPort": // เมธอดสำหรับปิดพอร์ตเครื่องชั่งโดยเฉพาะ
          weightReader.closePort();
          result.success("Weight port closed");
          break;
        default:
          result.notImplemented();
          break;
      }
    });
  }

  @Override
  protected void onDestroy() {
    // ปิดพอร์ตเครื่องพิมพ์หากเปิดอยู่
    if (printerNative != null) {
      printerNative.closePort();
    }
    // ปิดพอร์ตเครื่องชั่งหากเปิดอยู่
    if (weightReader != null) {
      weightReader.closePort();
    }
    super.onDestroy();
  }
}
