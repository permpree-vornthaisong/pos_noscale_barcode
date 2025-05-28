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

  private static final String CHANNEL =
    "com.example.pos_noscale_barcode/printer";
  private static final String TAG = "MainActivity";
  private PrinterNative printerNative;
  private boolean isPortOpen = false; // สถานะการเปิดพอร์ตสำหรับ PrinterNative

  private WeightReader weightReader; // ประกาศ WeightReader ใหม่
  private boolean isWeightPortOpen = false; // สถานะการเปิดพอร์ตของ WeightReader สำหรับ WeightReader โดยเฉพาะ

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    printerNative = new PrinterNative(getContext());
    weightReader = new WeightReader(); // สร้าง instance ของ WeightReader

    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      CHANNEL
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
        case "getAllSerialPorts":
          try {
            String[] allPorts = PrinterNative.getAllSerialPorts();
            result.success(Arrays.asList(allPorts));
          } catch (Exception e) {
            result.error(
              "UNAVAILABLE",
              "Serial ports not available.",
              e.getMessage()
            );
          }
          break;
        case "openPort": // สำหรับ PrinterNative
          portPath = call.argument("portPath");
          Integer baudRate = call.argument("baudRate");
          if (portPath == null || baudRate == null) {
            result.error(
              "INVALID_ARGUMENTS",
              "Port path and baud rate required",
              null
            );
            return;
          }

          // ตรวจสอบว่าพอร์ตกำลังถูกใช้โดย WeightReader หรือไม่ หากใช่ ให้แจ้งข้อผิดพลาด
          if (weightReader.isPortCurrentlyOpen(portPath, baudRate)) {
            result.error(
              "PORT_CONFLICT",
              "Port is currently in use by WeightReader.",
              null
            );
            return;
          }

          isPortOpen = printerNative.openPort(portPath, baudRate);
          if (isPortOpen) {
            result.success("Port opened successfully");
          } else {
            result.error("OPEN_ERROR", "Failed to open port", null);
          }
          break;
        case "sendFeedCommand":
          if (!isPortOpen) {
            result.error("PORT_CLOSED", "Port is not open", null);
            return;
          }

          portPath = call.argument("portPath");
          if (portPath == null) {
            result.error("INVALID_PORT", "Port path is required", null);
            return;
          }

          success = printerNative.sendCommand(portPath);
          if (success) {
            result.success("Command sent successfully");
          } else {
            result.error("SEND_ERROR", "Failed to send command", null);
          }
          break;
        case "closePort": // สำหรับ PrinterNative
          printerNative.closePort();
          isPortOpen = false;
          result.success("Port closed");
          break;
        case "printTestPattern":
          String testPortPath = call.argument("portPath");
          if (testPortPath == null) {
            result.error("INVALID_PORT", "Port path is required", null);
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
        case "readWeight": // ใช้ WeightReader สำหรับเคสนี้
          portPath = call.argument("portPath");
          Integer baudRateRead = call.argument("baudRate");
          Double tareWeight = call.argument("tareWeight");

          if (portPath == null || baudRateRead == null || tareWeight == null) {
            result.error(
              "INVALID_ARGUMENTS",
              "Port path, baud rate, and tare weight required",
              null
            );
            return;
          }

          // ตรวจสอบว่าพอร์ตกำลังถูกใช้โดย PrinterNative หรือไม่ หากใช่ ให้แจ้งข้อผิดพลาด
          if (printerNative.isPortCurrentlyOpen(portPath, baudRateRead)) {
            result.error(
              "PORT_CONFLICT",
              "Port is currently in use by PrinterNative.",
              null
            );
            return;
          }

          String adjustedWeight = weightReader.readWeight(
            portPath,
            baudRateRead,
            tareWeight
          );
          if (adjustedWeight != null) {
            isWeightPortOpen = true; // ตั้งค่าสถานะการเปิดพอร์ตของ WeightReader
            result.success(adjustedWeight);
          } else {
            isWeightPortOpen = false; // ตั้งค่าสถานะหากล้มเหลว
            result.error("READ_ERROR", "Failed to read or adjust weight", null);
          }
          break;
        case "closeWeightPort": // เพิ่มเมธอดสำหรับปิดพอร์ตของ WeightReader โดยเฉพาะ
          weightReader.closePort();
          isWeightPortOpen = false;
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
    if (isPortOpen) { // เดิม
      printerNative.closePort();
    }
    if (isWeightPortOpen) { // ปิดพอร์ตของ WeightReader ด้วย
      weightReader.closePort();
    }
    super.onDestroy();
  }
}
