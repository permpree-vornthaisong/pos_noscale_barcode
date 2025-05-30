package com.example.pos_noscale_barcode; // ตรวจสอบ package name ให้ถูกต้อง

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import androidx.annotation.NonNull;
// เพิ่ม import สำหรับ CoverIMG
import com.example.pos_noscale_barcode.CoverIMG;
// เพิ่ม import สำหรับ PrinterNativeIMG
import com.example.pos_noscale_barcode.PrinterNativeIMG;
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
  // **CHANNEL สำหรับ PrinterNativeIMG**
  private static final String PRINTERIMG_CHANNEL =
    "com.example.pos_noscale_barcode/printer_img";
  // **CHANNEL สำหรับ WeightReader (ตรงกับ '_channel' ใน Flutter)**
  private static final String WEIGHT_CHANNEL =
    "com.example.pos_noscale_barcode/printer_weight";

  // แก้ไข 'private private' เป็น 'private'
  private static final String TAG = "MainActivity";
  private PrinterNative printerNative;
  private WeightReader weightReader;
  private PrinterNativeIMG printerNativeIMG; // ประกาศตัวแปรสำหรับ PrinterNativeIMG

  // ไม่จำเป็นต้องมี isPort...
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    printerNative = new PrinterNative(getContext());
    weightReader = new WeightReader();
    printerNativeIMG = new PrinterNativeIMG(); // Initialize PrinterNativeIMG

    // PRINTER_CHANNEL
    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      PRINTER_CHANNEL
    )
      .setMethodCallHandler(
        (call, result) -> {
          String portPath = call.argument("portPath");
          int baudRate = call.argument("baudRate");
          if (portPath == null) {
            result.error(
              "INVALID_ARGUMENT",
              "Port path cannot be null.",
              null
            );
            return;
          }

          switch (call.method) {
            case "openPrinterPort":
              // ตรวจสอบว่าพอร์ตถูกใช้โดย PrinterNativeIMG หรือ WeightReader หรือไม่
              if (
                printerNativeIMG.isPortCurrentlyOpen(
                  portPath,
                  printerNativeIMG.currentlyOpenBaudRate != null
                    ? printerNativeIMG.currentlyOpenBaudRate
                    : 0
                )
              ) {
                result.error(
                  "PORT_CONFLICT",
                  "Port " + portPath + " is currently in use by PrinterNativeIMG.",
                  null
                );
                return;
              }
              if (
                weightReader.isPortCurrentlyOpen(
                  portPath,
                  weightReader.currentlyOpenBaudRate != null
                    ? weightReader.currentlyOpenBaudRate
                    : 0
                )
              ) {
                result.error(
                  "PORT_CONFLICT",
                  "Port " + portPath + " is currently in use by WeightReader.",
                  null
                );
                return;
              }

              boolean opened = printerNative.openPort(portPath, baudRate);
              if (opened) {
                result.success(true);
              } else {
                result.error("OPEN_FAILED", "Failed to open printer port.", null);
              }
              break;
            case "closePrinterPort":
              printerNative.closePort();
              result.success(true);
              break;
            case "printTestPattern":
              boolean printedTest = printerNative.printTestPattern(portPath);
              if (printedTest) {
                result.success(true);
              } else {
                result.error(
                  "PRINT_FAILED",
                  "Failed to print test pattern.",
                  null
                );
              }
              break;
            case "printText":
              String textToPrint = call.argument("text");
              if (textToPrint == null) {
                result.error("INVALID_ARGUMENT", "Text cannot be null.", null);
                return;
              }
              // แปลงข้อความเป็น UTF-8 bytes ก่อนส่ง
              byte[] textBytes = textToPrint.getBytes("UTF-8");
              boolean printedText = printerNative.printText(portPath, textBytes);
              if (printedText) {
                result.success(true);
              } else {
                result.error("PRINT_FAILED", "Failed to print text.", null);
              }
              break;
            case "feedLines":
              int lines = call.argument("lines");
              boolean fedLines = printerNative.feedLines(portPath, lines);
              if (fedLines) {
                result.success(true);
              } else {
                result.error("FEED_FAILED", "Failed to feed lines.", null);
              }
              break;
            case "printBytes":
              ArrayList<Object> byteList = call.argument("bytes");
              if (byteList == null) {
                result.error("INVALID_ARGUMENT", "Bytes cannot be null.", null);
                return;
              }
              byte[] bytesToPrint = new byte[byteList.size()];
              for (int i = 0; i < byteList.size(); i++) {
                bytesToPrint[i] = ((Number) byteList.get(i)).byteValue();
              }
              boolean printedBytes = printerNative.printBytes(portPath, bytesToPrint);
              if (printedBytes) {
                result.success(true);
              } else {
                result.error("PRINT_FAILED", "Failed to print bytes.", null);
              }
              break;
            default:
              result.notImplemented();
              break;
          }
        }
      );

    // PRINTERIMG_CHANNEL
    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      PRINTERIMG_CHANNEL
    )
      .setMethodCallHandler(
        (call, result) -> {
          String portPath = call.argument("portPath");
          int baudRate = call.argument("baudRate");
          if (portPath == null) {
            result.error(
              "INVALID_ARGUMENT",
              "Port path cannot be null.",
              null
            );
            return;
          }

          switch (call.method) {
            case "openPrinterImgPort":
              // ตรวจสอบว่าพอร์ตถูกใช้โดย PrinterNative หรือ WeightReader หรือไม่
              if (
                printerNative.isPortCurrentlyOpen(
                  portPath,
                  printerNative.currentlyOpenBaudRate != null
                    ? printerNative.currentlyOpenBaudRate
                    : 0
                )
              ) {
                result.error(
                  "PORT_CONFLICT",
                  "Port " + portPath + " is currently in use by PrinterNative.",
                  null
                );
                return;
              }
              if (
                weightReader.isPortCurrentlyOpen(
                  portPath,
                  weightReader.currentlyOpenBaudRate != null
                    ? weightReader.currentlyOpenBaudRate
                    : 0
                )
              ) {
                result.error(
                  "PORT_CONFLICT",
                  "Port " + portPath + " is currently in use by WeightReader.",
                  null
                );
                return;
              }
              boolean opened = printerNativeIMG.openPort(portPath, baudRate);
              if (opened) {
                result.success(true);
              } else {
                result.error("OPEN_FAILED", "Failed to open printer image port.", null);
              }
              break;
            case "closePrinterImgPort":
              printerNativeIMG.closePort();
              result.success(true);
              break;
            case "printImage": // <-- เมธอดใหม่สำหรับพิมพ์รูปภาพ
                byte[] imageBytes = call.argument("imageBytes");
                if (imageBytes == null) {
                    result.error("INVALID_ARGUMENT", "Image bytes cannot be null.", null);
                    return;
                }
                Bitmap bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);
                if (bitmap == null) {
                    result.error("IMAGE_DECODE_FAILED", "Failed to decode image bytes into Bitmap.", null);
                    return;
                }
                boolean printedImage = printerNativeIMG.printBitmap(portPath, bitmap);
                if (printedImage) {
                    result.success(true);
                } else {
                    result.error("PRINT_IMAGE_FAILED", "Failed to print image.", null);
                }
                break;
            default:
              result.notImplemented();
              break;
          }
        }
      );

    // WEIGHT_CHANNEL
    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      WEIGHT_CHANNEL
    )
      .setMethodCallHandler(
        (call, result) -> {
          String portPath = call.argument("portPath");
          int baudRateRead = call.argument("baudRate");
          if (portPath == null) {
            result.error(
              "INVALID_ARGUMENT",
              "Port path cannot be null.",
              null
            );
            return;
          }

          switch (call.method) {
            case "readWeight":
              // ตรวจสอบว่าพอร์ตถูกใช้โดย PrinterNative หรือ PrinterNativeIMG หรือไม่
              if (
                printerNative.isPortCurrentlyOpen(
                  portPath,
                  printerNative.currentlyOpenBaudRate != null
                    ? printerNative.currentlyOpenBaudRate
                    : 0
                )
              ) {
                result.error(
                  "PORT_CONFLICT",
                  "Port " + portPath + " is currently in use by PrinterNative.",
                  null
                );
                return;
              }
              if (
                printerNativeIMG.isPortCurrentlyOpen(
                  portPath,
                  printerNativeIMG.currentlyOpenBaudRate != null
                    ? printerNativeIMG.currentlyOpenBaudRate
                    : 0
                )
              ) {
                result.error(
                  "PORT_CONFLICT",
                  "Port " + portPath + " is currently in use by PrinterNativeIMG.",
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
        }
      );
  }

  @Override
  protected void onDestroy() {
    // ปิดพอร์ตเครื่องพิมพ์หากเปิดอยู่
    if (printerNative != null) {
      printerNative.closePort();
    }
    // ปิดพอร์ตเครื่องพิมพ์รูปภาพหากเปิดอยู่
    if (printerNativeIMG != null) {
      printerNativeIMG.closePort();
    }
    // ปิดพอร์ตเครื่องชั่งหากเปิดอยู่
    if (weightReader != null) {
      weightReader.closePort();
    }
    super.onDestroy();
  }
}