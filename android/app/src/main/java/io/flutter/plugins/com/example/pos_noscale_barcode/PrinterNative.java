package com.example.pos_noscale_barcode;

import android.content.Context;
import android.util.Log;
import java.io.FileOutputStream;
import java.io.File;

public class PrinterNative {
    private static final String TAG = "PrinterNative";
    private Context context;
    private FileOutputStream output;
    private int currentBaudRate = 115200;

    // Printer Commands
    private static final byte[] INIT_COMMAND = {
        (byte) 0x1B, (byte) 0x40  // ESC @ Initialize printer
    };

    private static final byte[] FEED_COMMAND = {
        (byte) 0x1B, (byte) 0x64, (byte) 0x05  // ESC d n - Feed n lines
    };

    private static final byte[] LINE_FEED = {
        (byte) 0x0A  // LF - Line Feed
    };

    private static final byte[] CENTER_ALIGN = {
        (byte) 0x1B, (byte) 0x61, (byte) 0x01  // ESC a 1
    };

    private static final byte[] LEFT_ALIGN = {
        (byte) 0x1B, (byte) 0x61, (byte) 0x00  // ESC a 0
    };

    private static final byte[] DOUBLE_SIZE = {
        (byte) 0x1B, (byte) 0x21, (byte) 0x30  // ESC ! 0x30
    };

    private static final byte[] NORMAL_SIZE = {
        (byte) 0x1B, (byte) 0x21, (byte) 0x00  // ESC ! 0x00
    };

    // UTF-8 and Thai language support
    private static final byte[] THAI_CHARACTER_CODE = {
        (byte) 0x1B, (byte) 0x74, (byte) 0x0F  // ESC t 15 - Select Thai Character Code
    };

    private static final byte[] SET_UTF8_MODE = {
        (byte) 0x1C, (byte) 0x43, (byte) 0x01  // FS C 1 - Enable UTF-8
    };

    private static final byte[] SET_CODEPAGE_UTF8 = {
        (byte) 0x1B, (byte) 0x74, (byte) 0x03  // ESC t 3 - Select UTF-8 codepage
    };

    // เพิ่ม command ควบคุมความเร็ว
    private static final byte[] SET_MAX_SPEED = {
        (byte) 0x1B, (byte) 0x73, (byte) 0x00  // Set maximum speed
    };

    private static final byte[] PRINT_DENSITY = {
        (byte) 0x1B, (byte) 0x6D  // Set print density to high
    };

    public PrinterNative(Context context) {
        this.context = context;
    }

    public boolean openPort(String portPath, int baudRate) {
        try {
            closePort(); // Close any existing connection
            
            File device = new File(portPath);
            if (!device.exists() || !device.canWrite()) {
                Log.e(TAG, "Device not found or not writable: " + portPath);
                return false;
            }

            output = new FileOutputStream(device);
            currentBaudRate = baudRate;
            
            // Initialize printer and set UTF-8 mode
            output.write(INIT_COMMAND);
            output.write(SET_CODEPAGE_UTF8);
            output.write(SET_UTF8_MODE);
            output.write(THAI_CHARACTER_CODE);
            output.flush();
            
            // เพิ่มการตั้งค่าความเร็วตั้งแต่เริ่มต้น
            output.write(SET_MAX_SPEED);
            output.write(PRINT_DENSITY);
            output.flush();
            
            Log.d(TAG, "Port opened successfully at " + baudRate + " baud");
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error opening port: " + e.getMessage());
            return false;
        }
    }

    public boolean sendCommand(String portPath) {
        try {
            if (output == null) {
                if (!openPort(portPath, currentBaudRate)) {
                    return false;
                }
            }

            output.write(INIT_COMMAND);
            output.write(FEED_COMMAND);
            output.write(LINE_FEED);
            
            output.flush();
            Log.d(TAG, "Feed command sent successfully");
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error sending feed command: " + e.getMessage());
            return false;
        }
    }

    // Add new methods
    public boolean printTestPattern(String portPath) {
        try {
            if (output == null) {
                if (!openPort(portPath, 115200)) {
                    return false;
                }
            }

            // Initialize printer
            output.write(INIT_COMMAND);
            
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
            Log.d(TAG, "Test pattern printed successfully");
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error printing test pattern: " + e.getMessage());
            return false;
        }
    }

    public boolean printText(String portPath, byte[] data) {
        try {
            if (output == null) {
                if (!openPort(portPath, currentBaudRate)) {
                    return false;
                }
            }

            // Initialize printer and set configurations
            output.write(INIT_COMMAND);
            output.flush();
            Thread.sleep(100);

            // Set character encoding
            output.write(SET_CODEPAGE_UTF8);
            output.write(SET_UTF8_MODE);
            output.write(THAI_CHARACTER_CODE);
            output.flush();
            Thread.sleep(100);

            // Set print speed
            byte[] printSpeed = {
                (byte) 0x1B, 
                (byte) 0x73, 
                (byte) 0x02  // Medium speed (0x00=fastest, 0x04=slowest)
            };
            output.write(printSpeed);
            output.flush();

            // Write data directly without conversion
            output.write(data);
            output.flush();
            Thread.sleep(150);

            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error printing text: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ถ้าต้องการ feed หลายบรรทัด
    public boolean feedLines(String portPath, int lines) {
        try {
            if (output == null) {
                if (!openPort(portPath, 115200)) {
                    return false;
                }
            }

            // สร้างคำสั่ง feed ตามจำนวนบรรทัดที่ต้องการ
            byte[] feed = {
                (byte) 0x1B, 
                (byte) 0x64, 
                (byte) (lines & 0xff)  // จำนวนบรรทัด
            };

            output.write(feed);
            output.flush();
            Log.d(TAG, "Fed " + lines + " lines");
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error feeding lines: " + e.getMessage());
            return false;
        }
    }

    // เพิ่มเมธอดใหม่สำหรับรับ byte array โดยตรง
    public boolean printBytes(String portPath, byte[] data) {
        try {
            if (output == null) {
                if (!openPort(portPath, currentBaudRate)) {
                    return false;
                }
            }

            // เขียน byte array โดยตรง
            output.write(data);
            output.flush();
            
            Log.d(TAG, "Bytes printed successfully, length: " + data.length);
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error printing bytes: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public void closePort() {
        try {
            if (output != null) {
                output.write(INIT_COMMAND);
                output.flush();
                Thread.sleep(100); // รอให้ข้อมูลถูกส่งจนหมด
                output.close();
                output = null;
            }
        } catch (Exception e) {
            Log.e(TAG, "Error closing port: " + e.getMessage());
        }
    }
}