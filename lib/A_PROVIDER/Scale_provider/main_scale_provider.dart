import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:provider/provider.dart';
import 'package:usb_serial/usb_serial.dart';

class ScaleProvider with ChangeNotifier {
  UsbDevice? _device;
  UsbPort? _port;
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
  String get_data() {
    return _DATA;
  }

  Future<void> initialize(context) async {
    final system_provider systems = Provider.of<system_provider>(context, listen: false);
    String format = systems.get_all()[0].format_input;

    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isNotEmpty) {
      if (format == "jhs") {
        for (var usbDevice in devices) {
          if (usbDevice.productName == "USB Serial") {
            _device = usbDevice;
            break;
          }
        }
      } else {
        for (var usbDevice in devices) {
          if (usbDevice.productName == "USB2.0-Ser!") {
            _device = usbDevice;
            break;
          }
        }
      }

      int count1 = 0;

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

      if (_device != null) {
        _port = await _device!.create();
        if (_port != null) {
          await _port!.open();
          await _port!.setDTR(true);
          await _port!.setRTS(true);
          await _port!.setPortParameters(
            9600,
            UsbPort.DATABITS_8,
            UsbPort.STOPBITS_1,
            UsbPort.PARITY_NONE,
          );
        }

        _subscription = _port!.inputStream!.listen((List<int> data) {
          for (int i = 0; i < data.length; i++) {
            data[i] = data[i] & 0x7F;
          }
          try {
            _DATA = FORMAT(data, format);
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
        });
      }
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
    _port?.close();
    super.dispose();
  }

  String FORMAT(List<int> data, String format) {
    String data_out = "";
    if (format == "0") {
      if (data[3] != 0x20) {
        data_out += String.fromCharCodes([data[3]]);
      }
      if (data[4] != 0x20) {
        data_out += String.fromCharCodes([data[4]]);
      }
      if (data[5] != 0x20) {
        data_out += String.fromCharCodes([data[5]]);
      }
      if (data[6] != 0x20) {
        data_out += String.fromCharCodes([data[6]]);
      }
      if (data[7] != 0x20) {
        data_out += String.fromCharCodes([data[7]]);
      }
      if (data[8] != 0x20) {
        data_out += String.fromCharCodes([data[8]]);
      }
      if (data[9] != 0x20) {
        data_out += String.fromCharCodes([data[9]]);
      }
    } else if (format == "1") {
      // FA FB FC FD
      if (data[5] != 0x20) {
        data_out += String.fromCharCodes([data[5]]);
      }
      if (data[1] == 0xFE) {
        data_out += ".";
      }
      if (data[6] != 0x20) {
        data_out += String.fromCharCodes([data[6]]);
      }
      if (data[1] == 0xFD) {
        data_out += ".";
      }
      if (data[7] != 0x20) {
        data_out += String.fromCharCodes([data[7]]);
      }
      if (data[1] == 0xFC) {
        data_out += ".";
      }
      if (data[8] != 0x20) {
        data_out += String.fromCharCodes([data[8]]);
      }
      if (data[1] == 0xFB) {
        data_out += ".";
      }
      if (data[9] != 0x20) {
        data_out += String.fromCharCodes([data[9]]);
      }
    } else if (format == "2") {
      //format == "2"
      if (data[6] != 0x20) {
        data_out += String.fromCharCodes([data[6]]);
      }
      if (data[7] != 0x20) {
        data_out += String.fromCharCodes([data[7]]);
      }
      if (data[8] != 0x20) {
        data_out += String.fromCharCodes([data[8]]);
      }
      if (data[9] != 0x20) {
        data_out += String.fromCharCodes([data[9]]);
      }
      if (data[10] != 0x20) {
        data_out += String.fromCharCodes([data[10]]);
      }
      if (data[11] != 0x20) {
        data_out += String.fromCharCodes([data[11]]);
      }
      if (data[12] != 0x20) {
        data_out += String.fromCharCodes([data[12]]);
      }
      if (data[13] != 0x20) {
        data_out += String.fromCharCodes([data[13]]);
      }
    } else if (format == "3") {
      if (data[1] != 0x20) {
        data_out += String.fromCharCodes([data[1]]);
      }
      if (data[2] != 0x20) {
        data_out += String.fromCharCodes([data[2]]);
      }
      if (data[3] != 0x20) {
        data_out += String.fromCharCodes([data[3]]);
      }
      if (data[4] != 0x20) {
        data_out += String.fromCharCodes([data[4]]);
      }
      if (data[5] != 0x20) {
        data_out += String.fromCharCodes([data[5]]);
      }
      if (data[6] != 0x20) {
        data_out += String.fromCharCodes([data[6]]);
      }
      if (data[7] != 0x20) {
        data_out += String.fromCharCodes([data[7]]);
      }
      if (data[8] != 0x20) {
        data_out += String.fromCharCodes([data[8]]);
      }
    } else if (format == "jhs") {
      if (data[4] != 0x20) {
        if (String.fromCharCodes([data[4]]) == "-") {
          data_out += String.fromCharCodes([data[4]]);
        }
      }
      if (data[5] != 0x20) {
        data_out += String.fromCharCodes([data[5]]);
      }
      if (data[6] != 0x20) {
        data_out += String.fromCharCodes([data[6]]);
      }
      if (data[7] != 0x20) {
        data_out += String.fromCharCodes([data[7]]);
      }
      if (data[8] != 0x20) {
        data_out += String.fromCharCodes([data[8]]);
      }
      if (data[9] != 0x20) {
        data_out += String.fromCharCodes([data[9]]);
      }
      if (data[10] != 0x20) {
        data_out += String.fromCharCodes([data[10]]);
      }
      if (data[11] != 0x20) {
        data_out += String.fromCharCodes([data[11]]);
      }
      /* if (data[8] != 0x20) {
        data_out += String.fromCharCodes([data[8]]);
      }*/
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
