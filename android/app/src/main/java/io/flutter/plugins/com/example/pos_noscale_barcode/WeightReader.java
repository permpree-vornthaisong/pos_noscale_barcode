package com.example.pos_noscale_barcode;

import android.util.Log;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class WeightReader {

  private static final String TAG = "WeightReader";
  private FileInputStream input;
  private String currentPortPath = null;
  private int currentBaudRate = 0; // เก็บ baud rate ที่ใช้เปิดพอร์ต

  /**
   * Opens the specified serial port for reading.
   *
   * @param portPath The path to the serial port (e.g., "/dev/ttyS8").
   * @param baudRate The baud rate for the serial port.
   * @return true if the port was opened successfully, false otherwise.
   */
  public boolean openPort(String portPath, int baudRate) {
    try {
      closePort(); // Close any existing connection first

      File device = new File(portPath);
      if (!device.exists() || !device.canRead()) {
        Log.e(TAG, "Device not found or not readable: " + portPath);
        return false;
      }

      input = new FileInputStream(device);
      currentPortPath = portPath;
      currentBaudRate = baudRate;
      Log.d(
        TAG,
        "WeightReader: Port opened successfully at " +
        baudRate +
        " baud for reading."
      );
      return true;
    } catch (Exception e) {
      Log.e(TAG, "WeightReader: Error opening port: " + e.getMessage());
      return false;
    }
  }

  /**
   * Reads data from the specified serial port and attempts to extract and adjust a weight value.
   *
   * @param portPath The path to the serial port (e.g., "/dev/ttyS8").
   * @param baudRate The baud rate for the serial port.
   * @param tareWeight The weight to subtract from the read value to achieve a "zero" reading.
   * @return The adjusted weight as a String, or null if an error occurs or weight cannot be parsed.
   */
  public String readWeight(String portPath, int baudRate, double tareWeight) {
    try {
      // Check if the port is open and matches the requested port. If not, try to open it.
      if (
        input == null ||
        !portPath.equals(currentPortPath) ||
        currentBaudRate != baudRate
      ) {
        Log.d(
          TAG,
          "WeightReader: Port not open or parameters changed. Attempting to open: " +
          portPath +
          " @ " +
          baudRate
        );
        if (!openPort(portPath, baudRate)) {
          Log.e(
            TAG,
            "WeightReader: Failed to open port for reading: " + portPath
          );
          return null;
        }
      }

      // Read data from the serial port
      byte[] buffer = new byte[128]; // Adjust buffer size as needed based on your scale's output length
      int bytesRead = input.read(buffer);
      if (bytesRead > 0) {
        String data = new String(buffer, 0, bytesRead).trim();
        Log.d(TAG, "WeightReader: Raw data from " + portPath + ": '" + data + "'");

        // Attempt to extract the numeric weight value
        // This regex looks for a sequence of digits, a dot, and digits, possibly preceded by a sign
        // followed by "kg" (case-insensitive, with optional spaces)
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("([+-]?\\d+\\.\\d+)\\s*kg", java.util.regex.Pattern.CASE_INSENSITIVE);
        java.util.regex.Matcher matcher = pattern.matcher(data);

        if (matcher.find()) {
          String weightStr = matcher.group(1);
          try {
            double rawWeight = Double.parseDouble(weightStr);
            double adjustedWeight = rawWeight - tareWeight;
            // Format to 3 decimal places with " kg" suffix
            return String.format("%.3f kg", adjustedWeight);
          } catch (NumberFormatException e) {
            Log.e(
              TAG,
              "WeightReader: Error parsing weight number: " + weightStr
            );
            return null;
          }
        } else {
          Log.w(
            TAG,
            "WeightReader: No weight pattern found in data: '" + data + "'"
          );
          return null;
        }
      } else {
        Log.d(TAG, "WeightReader: No bytes read from " + portPath);
        // In some cases, read() might return 0 bytes if no data is immediately available
        // and the stream is not closed. You might want to implement a timeout or polling.
        return null;
      }
    } catch (IOException e) {
      Log.e(
        TAG,
        "WeightReader: Error reading from port " +
        portPath +
        ": " +
        e.getMessage()
      );
      return null;
    }
  }

  /**
   * Checks if this WeightReader instance currently has the specified serial port open
   * with the given baud rate.
   *
   * @param portPath The path to the serial port.
   * @param baudRate The baud rate of the serial port.
   * @return true if the port is currently open by this instance with matching parameters, false otherwise.
   */
  public boolean isPortCurrentlyOpen(String portPath, int baudRate) {
    return (
      this.input != null &&
      portPath.equals(this.currentPortPath) &&
      baudRate == this.currentBaudRate
    );
  }

  /**
   * Closes the serial port.
   */
  public void closePort() {
    try {
      if (input != null) {
        input.close();
        input = null;
        Log.d(TAG, "WeightReader: Port closed.");
      }
      currentPortPath = null;
      currentBaudRate = 0;
    } catch (IOException e) {
      Log.e(TAG, "WeightReader: Error closing port: " + e.getMessage());
    }
  }
}