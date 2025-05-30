package com.example.pos_noscale_barcode; // ตรวจสอบ package name ให้ถูกต้อง

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList; // เพิ่ม import นี้
import java.util.List; // เพิ่ม import นี้

public class PrinterNativeIMG {

  private static final String TAG = "PrinterNativeIMG";
  private FileOutputStream output;

  public String currentlyOpenPortPath = null;
  public Integer currentlyOpenBaudRate = null;

  public PrinterNativeIMG() {
    // Constructor
  }

  // ตรวจสอบว่าพอร์ตเปิดอยู่หรือไม่
  public boolean isPortCurrentlyOpen(String portPath, int baudRate) {
    return (
      this.output != null &&
      this.currentlyOpenPortPath != null &&
      this.currentlyOpenPortPath.equals(portPath) &&
      this.currentlyOpenBaudRate != null &&
      this.currentlyOpenBaudRate.equals(baudRate)
    );
  }

  // เปิดพอร์ตสำหรับเครื่องพิมพ์รูปภาพ
  public boolean openPort(String portPath, int baudRate) {
    Log.d(TAG, "Attempting to open port: " + portPath + " with baud rate: " + baudRate);
    if (isPortCurrentlyOpen(portPath, baudRate)) {
      Log.w(
        TAG,
        "Port " +
        portPath +
        " is already open by PrinterNativeIMG with baud rate " +
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
      this.currentlyOpenPortPath = portPath;
      this.currentlyOpenBaudRate = baudRate;
      Log.d(
        TAG,
        "PrinterNativeIMG: Port opened successfully at " + baudRate + " baud."
      );
      return true;
    } catch (Exception e) {
      this.currentlyOpenPortPath = null;
      this.currentlyOpenBaudRate = null;
      Log.e(TAG, "PrinterNativeIMG: Error opening port: " + e.getMessage());
      return false;
    }
  }

  // ส่งข้อมูลรูปภาพไปยังเครื่องพิมพ์
  public boolean printByteIMG(String portPath, byte[] imageData) {
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
          "Printer port is not open or parameters mismatched for printByteIMG."
        );
        return false;
      }

      output.write(imageData);
      output.flush();

      Log.d(
        TAG,
        "PrinterNativeIMG: Image bytes printed successfully, length: " +
        imageData.length
      );
      return true;
    } catch (Exception e) {
      Log.e(TAG, "PrinterNativeIMG: Error printing image: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  // เมธอดใหม่สำหรับพิมพ์ Bitmap
  public boolean printBitmap(String portPath, Bitmap bitmap) {
    if (output == null || !isPortCurrentlyOpen(portPath, currentlyOpenBaudRate != null ? currentlyOpenBaudRate : 0)) {
      Log.e(TAG, "Printer port is not open for printBitmap.");
      return false;
    }

    try {
      // ขนาดของรูปภาพ
      int width = bitmap.getWidth();
      int height = bitmap.getHeight();

      // แปลง Bitmap เป็นขาวดำแบบ 1 บิตต่อพิกเซล
      // EPSON printers: 1 = print dot, 0 = no print dot
      // แต่เรามักจะใช้ 1 = black, 0 = white ในการประมวลผลของเรา
      // และคำสั่ง ESC/POS GS v 0 จะใช้ 1 = print, 0 = no print
      // ดังนั้น, ถ้าพิกเซลเป็นสีดำใน bitmap, เราจะตั้งบิตให้เป็น 1
      Bitmap monoBitmap = convertToMonochromeAndDither(bitmap);

      // คำนวณความกว้างเป็นจำนวนไบต์ (แต่ละไบต์แทน 8 จุด)
      int widthBytes = (monoBitmap.getWidth() + 7) / 8; // ปัดขึ้นเพื่อให้ครอบคลุมทุกพิกเซล

      // คำสั่งพิมพ์รูปภาพ GS v 0
      // GS v 0 m xL xH yL yH d1...dk
      // m = 0 (Normal mode, no double-density)
      // xL, xH = (width in dots) / 8
      // yL, yH = height in dots
      List<Byte> commands = new ArrayList<>();
      commands.add((byte) 0x1D); // GS
      commands.add((byte) 0x76); // v
      commands.add((byte) 0x30); // 0
      commands.add((byte) 0x00); // m = 0 (Normal mode, no double-density, no double-height/width)
      commands.add((byte) (widthBytes % 256)); // xL
      commands.add((byte) (widthBytes / 256)); // xH
      commands.add((byte) (height % 256));     // yL
      commands.add((byte) (height / 256));     // yH

      // วนลูปเพื่อสร้างข้อมูล bit-image
      for (int y = 0; y < height; y++) {
          for (int x = 0; x < widthBytes; x++) {
              byte b = 0;
              for (int bit = 0; bit < 8; bit++) {
                  int pixelX = x * 8 + bit;
                  if (pixelX < width) {
                      int pixel = monoBitmap.getPixel(pixelX, y);
                      // เนื่องจาก convertToMonochromeAndDither ทำให้พิกเซลเป็นขาว (255) หรือดำ (0)
                      // ถ้าเป็นสีดำ (0) ให้ตั้งค่าบิตเป็น 1 (เครื่องพิมพ์จะพิมพ์จุด)
                      // ถ้าเป็นสีขาว (255) ให้ตั้งค่าบิตเป็น 0 (เครื่องพิมพ์ไม่พิมพ์จุด)
                      if (android.graphics.Color.red(pixel) == 0) { // ตรวจสอบว่าพิกเซลเป็นสีดำ (red component = 0)
                          b |= (1 << (7 - bit)); // ตั้งค่าบิต (MSB first)
                      }
                  }
              }
              commands.add(b);
          }
      }

      // แปลง List<Byte> เป็น byte[]
      byte[] printData = new byte[commands.size()];
      for (int i = 0; i < commands.size(); i++) {
        printData[i] = commands.get(i);
      }

      output.write(printData);
      output.flush();

      Log.d(TAG, "PrinterNativeIMG: Bitmap printed successfully.");
      return true;

    } catch (Exception e) {
      Log.e(TAG, "PrinterNativeIMG: Error printing bitmap: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  // Helper method to convert Bitmap to 1-bit monochrome with simple dithering
  // (สามารถปรับปรุงให้ใช้ Floyd-Steinberg dithering เพื่อคุณภาพที่ดีขึ้นได้)
  private Bitmap convertToMonochromeAndDither(Bitmap originalBitmap) {
      int width = originalBitmap.getWidth();
      int height = originalBitmap.getHeight();
      Bitmap monoBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);

      int[][] error = new int[width + 2][height + 2]; // For error diffusion

      for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
              int pixel = originalBitmap.getPixel(x, y);
              int red = (pixel >> 16) & 0xff;
              int green = (pixel >> 8) & 0xff;
              int blue = pixel & 0xff;
              int alpha = (pixel >> 24) & 0xff;

              // Convert to grayscale
              int grayscale = (red + green + blue) / 3;

              // Apply error from previous pixels
              int oldPixelValue = grayscale + error[x + 1][y + 1];

              int newPixelValue;
              int quantError;

              if (oldPixelValue < 128) { // Threshold for black
                  newPixelValue = 0; // Black
                  quantError = oldPixelValue;
              } else {
                  newPixelValue = 255; // White
                  quantError = oldPixelValue - 255;
              }

              monoBitmap.setPixel(x, y, android.graphics.Color.argb(alpha, newPixelValue, newPixelValue, newPixelValue));

              // Distribute error (Floyd-Steinberg coefficients)
              // To the right: 7/16
              if (x + 2 < width + 2) error[x + 2][y + 1] += quantError * 7 / 16;
              // To the bottom-left: 3/16
              if (x > 0 && y + 2 < height + 2) error[x][y + 2] += quantError * 3 / 16;
              // To the bottom: 5/16
              if (y + 2 < height + 2) error[x + 1][y + 2] += quantError * 5 / 16;
              // To the bottom-right: 1/16
              if (x + 2 < width + 2 && y + 2 < height + 2) error[x + 2][y + 2] += quantError * 1 / 16;
          }
      }
      return monoBitmap;
  }

  // ปิดพอร์ตเครื่องพิมพ์รูปภาพ
  public void closePort() {
    try {
      if (output != null) {
        output.flush();
        Thread.sleep(100); // รอให้ข้อมูลถูกส่งจนหมด
        output.close();
        output = null;
      }
    } catch (Exception e) {
      Log.e(TAG, "PrinterNativeIMG: Error closing port: " + e.getMessage());
    } finally {
      this.currentlyOpenPortPath = null;
      this.currentlyOpenBaudRate = null;
    }
  }
}