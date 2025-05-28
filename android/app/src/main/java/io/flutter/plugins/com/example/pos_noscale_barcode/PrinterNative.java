package com.example.pos_noscale_barcode;

import android.content.Context;
import android.util.Log;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class PrinterNative {

  private static final String TAG = "PrinterNative";
  private Context context;
  private FileOutputStream output;

  private String currentlyOpenPortPath = null;
  private Integer currentlyOpenBaudRate = null;

  // Printer Commands (คงเดิม)
  private static final byte[] INIT_COMMAND = { (byte) 0x1B, (byte) 0x40 };
  private static final byte[] FEED_COMMAND = {
    (byte) 0x1B,
    (byte) 0x64,
    (byte) 0x05,
  };
  private static final byte[] LINE_FEED = { (byte) 0x0A };
  private static final byte[] CENTER_ALIGN = {
    (byte) 0x1B,
    (byte) 0x61,
    (byte) 0x01,
  };
  private static final byte[] LEFT_ALIGN = {
    (byte) 0x1B,
    (byte) 0x61,
    (byte) 0x00,
  };
  private static final byte[] DOUBLE_SIZE = {
    (byte) 0x1B,
    (byte) 0x21,
    (byte) 0x30,
  };
  private static final byte[] NORMAL_SIZE = {
    (byte) 0x1B,
    (byte) 0x21,
    (byte) 0x00,
  };
  private static final byte[] THAI_CHARACTER_CODE = {
    (byte) 0x1B,
    (byte) 0x74,
    (byte) 0x0F,
  };
  private static final byte[] SET_UTF8_MODE = {
    (byte) 0x1C,
    (byte) 0x43,
    (byte) 0x01,
  }; // GS C 1 - Set UTF-8 mode
  private static final byte[] SET_CODEPAGE_UTF8 = {
    (byte) 0x1B,
    (byte) 0x74,
    (byte) 0x03,
  }; // ESC t 3 (PC437 or similar, depends on printer) - Should be used carefully with Thai characters
  private static final byte[] SET_MAX_SPEED = {
    (byte) 0x1B,
    (byte) 0x73,
    (byte) 0x00,
  }; // ESC s n - Set print speed
  private static final byte[] PRINT_DENSITY = { (byte) 0x1B, (byte) 0x6D }; // ESC m - Select print density (might need specific value)

  public PrinterNative(Context context) {
    this.context = context;
  }

  public boolean isPortCurrentlyOpen(String portPath, int baudRate) {
    return (
      this.output != null &&
      this.currentlyOpenPortPath != null &&
      this.currentlyOpenPortPath.equals(portPath) &&
      this.currentlyOpenBaudRate != null &&
      this.currentlyOpenBaudRate.equals(baudRate)
    );
  }

  public boolean openPort(String portPath, int baudRate) {
    if (isPortCurrentlyOpen(portPath, baudRate)) {
      Log.w(
        TAG,
        "Port " +
        portPath +
        " is already open by PrinterNative with baud rate " +
        baudRate
      );
      return true;
    }

    try {
      closePort(); // ปิดการเชื่อมต่อเดิมก่อนเสมอ

      File device = new File(portPath);
      if (!device.exists() || !device.canWrite()) {
        Log.e(TAG, "Device not found or not writable: " + portPath);
        this.currentlyOpenPortPath = null;
        this.currentlyOpenBaudRate = null;
        return false;
      }

      output = new FileOutputStream(device);

      // **ตั้งค่าเริ่มต้นเครื่องพิมพ์เพียงครั้งเดียวเมื่อเปิดพอร์ต**
      output.write(INIT_COMMAND);
      output.write(SET_CODEPAGE_UTF8);
      output.write(SET_UTF8_MODE);
      output.write(THAI_CHARACTER_CODE); // หากจำเป็นสำหรับภาษาไทย
      output.write(SET_MAX_SPEED); // ตั้งค่าความเร็วสูงสุด
      output.write(PRINT_DENSITY); // ตั้งค่าความหนาแน่นการพิมพ์ (อาจต้องกำหนดค่า 0x00-0xFF)
      output.flush();

      this.currentlyOpenPortPath = portPath;
      this.currentlyOpenBaudRate = baudRate;
      Log.d(
        TAG,
        "PrinterNative: Port opened successfully at " +
        baudRate +
        " baud with initial settings."
      );
      return true;
    } catch (Exception e) {
      this.currentlyOpenPortPath = null;
      this.currentlyOpenBaudRate = null;
      Log.e(TAG, "PrinterNative: Error opening port: " + e.getMessage());
      return false;
    }
  }

  public boolean sendCommand(String portPath) {
    try {
      if (
        output == null ||
        !isPortCurrentlyOpen(
          portPath,
          currentlyOpenBaudRate != null ? currentlyOpenBaudRate : 0
        )
      ) {
        Log.e(
          TAG,
          "Printer port is not open or parameters mismatched for sendCommand."
        );
        return false;
      }

      // ไม่ต้องส่ง INIT_COMMAND ซ้ำอีก
      output.write(FEED_COMMAND);
      output.write(LINE_FEED);

      output.flush();
      Log.d(TAG, "PrinterNative: Feed command sent successfully");
      return true;
    } catch (Exception e) {
      Log.e(
        TAG,
        "PrinterNative: Error sending feed command: " + e.getMessage()
      );
      return false;
    }
  }

  public boolean printTestPattern(String portPath) {
    try {
      if (
        output == null ||
        !isPortCurrentlyOpen(
          portPath,
          currentlyOpenBaudRate != null ? currentlyOpenBaudRate : 0
        )
      ) {
        Log.e(
          TAG,
          "Printer port is not open or parameters mismatched for printTestPattern."
        );
        return false;
      }

      // ไม่ต้องส่ง INIT_COMMAND ซ้ำอีก
      // Center alignment, double size
      output.write(CENTER_ALIGN);
      output.write(DOUBLE_SIZE);
      output.write("*** TEST PRINT ***\n".getBytes());
      // Normal size
      output.write(NORMAL_SIZE);
      output.write("Printer OK\n".getBytes());
      // Reset to left align
      output.write(LEFT_ALIGN);
      // Feed paper
      output.write(FEED_COMMAND);
      output.flush();
      Log.d(TAG, "PrinterNative: Test pattern printed successfully");
      return true;
    } catch (Exception e) {
      Log.e(
        TAG,
        "PrinterNative: Error printing test pattern: " + e.getMessage()
      );
      return false;
    }
  }

  public boolean printText(String portPath, byte[] data) {
    try {
      if (
        output == null ||
        !isPortCurrentlyOpen(
          portPath,
          currentlyOpenBaudRate != null ? currentlyOpenBaudRate : 0
        )
      ) {
        Log.e(
          TAG,
          "Printer port is not open or parameters mismatched for printText."
        );
        return false;
      }

      // **ลบคำสั่ง INIT_COMMAND, SET_CODEPAGE_UTF8, SET_UTF8_MODE, THAI_CHARACTER_CODE, SET_MAX_SPEED ออกจากตรงนี้**
      // **ลบ Thread.sleep() ทั้งหมดออก**
      // **ถือว่าการตั้งค่าเหล่านี้ทำไปแล้วใน openPort**

      // Write data directly without conversion
      output.write(data);
      output.flush(); // เพียงแค่เขียนข้อมูลและ flush เท่านั้น

      Log.d(
        TAG,
        "PrinterNative: Text printed successfully, length: " + data.length
      );
      return true;
    } catch (Exception e) {
      Log.e(TAG, "PrinterNative: Error printing text: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  public boolean feedLines(String portPath, int lines) {
    try {
      if (
        output == null ||
        !isPortCurrentlyOpen(
          portPath,
          currentlyOpenBaudRate != null ? currentlyOpenBaudRate : 0
        )
      ) {
        Log.e(
          TAG,
          "Printer port is not open or parameters mismatched for feedLines."
        );
        return false;
      }

      byte[] feed = { (byte) 0x1B, (byte) 0x64, (byte) (lines & 0xff) };

      output.write(feed);
      output.flush();
      Log.d(TAG, "PrinterNative: Fed " + lines + " lines");
      return true;
    } catch (Exception e) {
      Log.e(TAG, "PrinterNative: Error feeding lines: " + e.getMessage());
      return false;
    }
  }

  // เมธอด printBytes ของคุณยังคงเหมือนเดิม เพราะมันมีประสิทธิภาพอยู่แล้ว
  public boolean printBytes(String portPath, byte[] data) {
    try {
      if (
        output == null ||
        !isPortCurrentlyOpen(
          portPath,
          currentlyOpenBaudRate != null ? currentlyOpenBaudRate : 0
        )
      ) {
        Log.e(
          TAG,
          "Printer port is not open or parameters mismatched for printBytes."
        );
        return false;
      }

      output.write(data);
      output.flush();

      Log.d(
        TAG,
        "PrinterNative: Bytes printed successfully, length: " + data.length
      );
      return true;
    } catch (Exception e) {
      Log.e(TAG, "PrinterNative: Error printing bytes: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  public void closePort() {
    try {
      if (output != null) {
        output.write(INIT_COMMAND); // ส่งคำสั่ง Initialize อีกครั้งก่อนปิด (ไม่จำเป็นเสมอไป แต่ก็ไม่เสียหาย)
        output.flush();
        Thread.sleep(100); // รอให้ข้อมูลถูกส่งจนหมด
        output.close();
        output = null;
      }
    } catch (Exception e) {
      Log.e(TAG, "PrinterNative: Error closing port: " + e.getMessage());
    } finally {
      this.currentlyOpenPortPath = null;
      this.currentlyOpenBaudRate = null;
    }
  }
}
