package com.example.pos_noscale_barcode;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.util.Log;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.pos_noscale_barcode/printer";
    private static final String TAG = "MainActivity";
    private PrinterNative printerNative;
    private boolean isPortOpen = false;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        printerNative = new PrinterNative(getContext());

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
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
                        Integer baudRate = call.argument("baudRate");
                        if (portPath == null || baudRate == null) {
                            result.error("INVALID_ARGUMENTS", "Port path and baud rate required", null);
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

                    case "closePort":
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
                            result.error("INVALID_ARGUMENTS", "Port path and data required", null);
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
                            result.error("INVALID_ARGUMENTS", "Port path and data required", null);
                            return;
                        }
                        
                        boolean bytesPrintSuccess = printerNative.printBytes(bytesPortPath, bytesData);
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
    }

    @Override
    protected void onDestroy() {
        if (isPortOpen) {
            printerNative.closePort();
        }
        super.onDestroy();
    }
}