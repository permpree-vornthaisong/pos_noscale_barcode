import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_serial/flutter_serial.dart';

class ScaleProvider with ChangeNotifier {
  FlutterSerial _device = FlutterSerial();

  List<String>? serialList = [];

  StreamSubscription? _subscription;
  String _DATA = "0.00";
  bool _tare = false;
  bool _statble = true;
  bool _zero = false;

  String _stable_num = "";
  int _count_stable = 0;
  Timer? timer;

  double _zero_data = 0;
  bool _zero_data_state = false;
  double _buff = 0;
  double _tare_buff = 0;
  bool _state_tare = false;

  String logData = "";
  String receivedData = "";
  int count1 = 0;
  String format = "0";
  String get_data() {
    return _DATA;
  }

  Future<void> getSerialList() async {
    serialList = await _device?.getAvailablePorts();
    //   print(serialList);
  }

  Future<void> initialize(context) async {
    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    format = systems.get_all()[0].format_input;
    notifyListeners();
    // List<UsbDevice> devices = await UsbSerial.listDevices();
    /*  int selectedBaudRate = FlutterSerial().baudRateList.first;

    FlutterSerial flutterSerial = FlutterSerial();*/

    /* _device?.startSerial().listen(start);

    getSerialList();*/
    _device.startSerial().listen(start);
    getSerialList();

    await Future.delayed(Duration(seconds: 2));

    if (format == "jhs") {
      _device.openPort(dataFormat: DataFormat.ASCII, serialPort: "/dev/ttyS8", baudRate: 9600); //ttyCH341USB3
    } else {
      _device.openPort(dataFormat: DataFormat.ASCII, serialPort: "/dev/ttyUSB0", baudRate: 9600); //ttyCH341USB3
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count1 == 0) {
        _DATA = "NO_signal";
        //   print("NO_signal");

        notifyListeners();
      } else {
        count1 = 0;
        notifyListeners();
      }
    });
  }

  Future<void> start(SerialResponse? result) async {
    String _input = result?.readChannel ?? "";

    if (_input.isNotEmpty) {
      try {
        _DATA = _input.length > 23 ? _input.substring(23).trim() : "NO DATA";
        _DATA = FORMAT(_DATA, format);
        stable_input(_DATA);
        _DATA = Zero(_DATA);
        _DATA = Tare(_DATA);

        count1++;

        notifyListeners();
      } catch (e) {
        //  showAlertDialogG(context, e.toString());
        _DATA = e.toString();
        notifyListeners();
      }

      await Future.microtask(() {
        _device.clearLog();
        _device.clearRead();
      });
    }

    notifyListeners();
  }

  String Zero(String DATA_in) {
    if (_zero_data_state) {
      //  _buff = _zero_data;
      _zero_data = double.parse(DATA_in);
      zero_state(false);
    }
    double DATA_out = double.parse(DATA_in) - _zero_data;
    // -_buff;

    return DATA_out.toStringAsFixed(3);
  }

  String Tare(String DATA_in) {
    if (_tare) {
      if (_state_tare) {
        _tare_buff = double.parse(DATA_in);

        _state_tare = false;
      }

      double DATA_out = double.parse(DATA_in) - _tare_buff;

      return DATA_out.toStringAsFixed(3);
    } else {
      _tare_buff = 0;
      return DATA_in;
    }
  }

  void zero_state(bool data) {
    _zero_data_state = data;
    // _zero
    notifyListeners();
  }

  bool get_zero() {
    return _zero_data_state;
  }

  void TARE(bool data) {
    _tare = data;
    _state_tare = true;
    notifyListeners();
  }

  bool get_tare() {
    return _tare;
  }

  void STABLE(bool data) {
    _statble = data;
    notifyListeners();
  }

  bool get_stable() {
    return _statble;
  }

  @override
  void dispose() {
    _device?.clearRead();
    _device?.destroy();

    super.dispose();
  }

  String FORMAT(String data, String format) {
    List<int> bytes = data.codeUnits;
    String data_out = "";

    if (format == "0") {
      if (bytes.length > 9) {
        if (bytes[3] != 0x20) data_out += String.fromCharCode(bytes[3]);
        if (bytes[4] != 0x20) data_out += String.fromCharCode(bytes[4]);
        if (bytes[5] != 0x20) data_out += String.fromCharCode(bytes[5]);
        if (bytes[6] != 0x20) data_out += String.fromCharCode(bytes[6]);
        if (bytes[7] != 0x20) data_out += String.fromCharCode(bytes[7]);
        if (bytes[8] != 0x20) data_out += String.fromCharCode(bytes[8]);
        if (bytes[9] != 0x20) data_out += String.fromCharCode(bytes[9]);
      }
    } else if (format == "1") {
      if (bytes.length > 9) {
        if (bytes[5] != 0x20) data_out += String.fromCharCode(bytes[5]);
        if (bytes[1] == 0xFE) data_out += ".";
        if (bytes[6] != 0x20) data_out += String.fromCharCode(bytes[6]);
        if (bytes[1] == 0xFD) data_out += ".";
        if (bytes[7] != 0x20) data_out += String.fromCharCode(bytes[7]);
        if (bytes[1] == 0xFC) data_out += ".";
        if (bytes[8] != 0x20) data_out += String.fromCharCode(bytes[8]);
        if (bytes[1] == 0xFB) data_out += ".";
        if (bytes[9] != 0x20) data_out += String.fromCharCode(bytes[9]);
      }
    } else if (format == "2") {
      if (bytes.length > 13) {
        for (int i = 6; i <= 13; i++) {
          if (bytes[i] != 0x20) {
            data_out += String.fromCharCode(bytes[i]);
          }
        }
      }
    } else if (format == "3") {
      if (bytes.length > 8) {
        for (int i = 1; i <= 8; i++) {
          if (bytes[i] != 0x20) {
            data_out += String.fromCharCode(bytes[i]);
          }
        }
      }
    } else if (format == "jhs") {
      if (bytes.length > 11) {
        if (bytes[4] != 0x20 && bytes[4] == "-".codeUnitAt(0)) {
          data_out += "-";
        }
        for (int i = 5; i <= 11; i++) {
          if (bytes[i] != 0x20) {
            data_out += String.fromCharCode(bytes[i]);
          }
        }
      }
    } else {
      data_out = "ERROR";
    }

    return data_out;
  }

  void stable_input(String data) {
    if (!_statble) {
      _stable_num = data;

      if (_stable_num == data) {
        _count_stable++;
      } else {
        _count_stable = 0;
        STABLE(false);
      }

      if (_count_stable >= 5) {
        STABLE(true);
      }
    } else {
      if (_stable_num != data) {
        _count_stable = 0;
        STABLE(false);
      }
    }
  }
}

void showAlertDialogG(BuildContext context, String data) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(data),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}