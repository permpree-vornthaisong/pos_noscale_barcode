import 'dart:convert';
import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';

Future<List<int>> data_to_list_INT(String DATA, int X, int Y, int font, String type, int percen) async {
  var encoded = utf8.encode(DATA);
  List<String> hexStrings = encoded.map((value) => value.toRadixString(16).padLeft(2, '0')).toList();
//  hexStrings.removeLast();
//  hexStrings.removeLast();

  List<int> GG = [];

  if (type == "single") {
    GG += [
      // init
      0x02, 0x41,
      0x00, 0x02, 0x59,
      hexStrings.length + 0X10, //HEAD_BILLhexStrings
      0x12,
      ////
      0x00, 0x00, 0x00, font, 0x10 + X, 0x00, Y, 0x00,
      //////////////////
      0x00, 0x00, //01  80  //80 01 E8 03
      0x00, 0x00, //01  80
      //// data
      ...hexStrings.map((hex) => int.parse(hex, radix: 16)), //HEAD_BILLhexStrings
      0x00, 0x04,
      // 0x07
    ];
  }

  if (type == "con") {
    GG += [
      0x02, 0x41,
      0x00, 0x02, 0x59,
      hexStrings.length + 0X10, //HEAD_BILLhexStrings

      0x12,
      ////
      0x00, 0x00, 0x00, font, 0x00 + X, 0x00, Y, 0x00,
      //////////////////
      0x00, 0x00, //01  80  //80 01 E8 03
      0x00, 0x00, //01  80
      //// data
      ...hexStrings.map((hex) => int.parse(hex, radix: 16)), //HEAD_BILLhexStrings

      0x00,
      //0x04,
      //0x07
    ];
  }

  return GG;
}

Future<List<int>> gen_Qrcode(String DATA) async {
  // List<int> GG = [];
  List<int> bytes = [];

  // Xprinter XP-N160I
  final profile = await CapabilityProfile.load(name: 'XP-N160I'); //name: 'XP-N160I'  RP80USE
  // PaperSize.mm80 or PaperSize.mm5858
  final generator = Generator(PaperSize.mm58, profile);

  bytes += generator.text('');
  bytes += generator.qrcode(DATA);
  bytes.removeRange(7, 20);
  bytes[14] = 0x08;

  return bytes;
}

Future<List<int>> gen_code128(String DATA) async {
  var encoded = utf8.encode(DATA);
  List<String> hexStrings = encoded.map((value) => value.toRadixString(16).padLeft(2, '0')).toList();

  List<int> B123 = [
    0x02,
    0x41,
    0x00,
    0x02,
    0x59,
    hexStrings.length + 0X18,
    //   0x1E, // ขนาด byte
    0x14, ////  //00 20 05 01 00 00 58 00
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00, //
    0x00, ////
    0x80, //80  [code128  80]
    0x01, //01  [code128  01]
    0x80, //1A  [code128  80]
    0x00,
    0x06, ///////type 11
    0x02, // Y  [code128  45]   [QR ความ ละเอียด ]
    0x02, // X   [code128  30]  //08
    0x00,
    0x00, //
    0x00,
    0x00, //
    0x00,
    //////
    /* 0x31,
    0x32,
    0x33,
    0x34,
    0x35,
    0x36,*/

    ///
    ...hexStrings.map((hex) => int.parse(hex, radix: 16)),

    ///
    0x00,
    0x04,
    0x07
  ];

  return B123;
}

Future<List<int>> gen_ean128(String DATA) async {
  var encoded = utf8.encode(DATA);
  List<String> hexStrings = encoded.map((value) => value.toRadixString(16).padLeft(2, '0')).toList();
  List<int> B124 = [
    0x02,
    0x41,
    0x00,
    0x02,
    0x59,
    hexStrings.length + 0X18,
    //   0x1E, // ขนาด byte
    0x14, ////  //00 20 05 01 00 00 58 00
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00, //
    0x00, ////
    0x00, //80  [code128  80]
    0x00, //01  [code128  01]
    0x80, //1A  [code128  80]
    0x00,
    0x01, ///////type 11
    0x01, // Y  [code128  45]   [QR ความ ละเอียด ]
    0x04, // X   [code128  30]  //08
    0x00,
    0x00, //
    0x00,
    0x00, //
    0x00,
    //////
    /* 0x31,
    0x32,
    0x33,
    0x34,
    0x35,
    0x36,*/

    ///
    ...hexStrings.map((hex) => int.parse(hex, radix: 16)),

    ///
    0x00,
    0x04,
    0x07
  ];

  return B124;
}

Future<List<int>> feed_print() async {
  List<int> GG = [];
  List<int> bytes = [0x02, 0x41, 0x00, 0x02, 0x59, 0x01, 0x07];

  return bytes;
}

int range_data(String DATA) {
  var encoded = utf8.encode(DATA);
  List<String> hexStrings = encoded.map((value) => value.toRadixString(16).padLeft(2, '0')).toList();

  return hexStrings.length;
}

Future<int> CUT_WORD(String DATA) async {
  int num = 0;
  for (int i = 0; i < DATA.length; i++,) {
    if (DATA[i] == "่") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "้") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "๊") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "๋") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "ุ") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "ู") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "ิ") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "ี") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "ั") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "์") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "ึ") {
      //  " ่ "

      num++;
    }
    if (DATA[i] == "์") {
      //  " ่ "

      num++;
    }
  }

  return num;
}

Future<List<int>> serial_cash_box(context) async {
  List<int> DATA2 = [
    0x02,
    0x40,
    0x00,
    0x02,
    0x58,
    0x02,
    0x03,
    0x00,
  ];

  return DATA2;
}
