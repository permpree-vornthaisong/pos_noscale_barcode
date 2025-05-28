import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:usb_serial/usb_serial.dart';

List<dynamic> thaiAscii(String character) {
  print("dfdf");

  Map<String, List<dynamic>> thaiAsciiMap = {
    /*
        ' ั่': [146, "E"], //ไม่หัน
    ' ั้': [147, "E"],
    ' ั๊': [148, "E"],
    ' ั๋': [149, "E"],

    ' ิ่': [150, "E"], //สระอิ
    ' ิ้': [151, "E"],
    ' ิ๊': [152, "E"],
    ' ิ๋': [153, "E"],
    ' ิ์': [154, "E"],

    ' ี่': [155, "E"],
    ' ิี้': [156, "E"], //สระ อี
    ' ิี๊': [157, "E"],
    ' ี๋': [158, "E"],

    ' ึ่': [219, "E"], //สระอือ
    ' ิึ้': [220, "E"],
    ' ิึ๊': [221, "E"],
    ' ึ๋': [222, "E"],


*/

    'ก': [161, "C"],
    'ข': [162, "C"],
    'ฃ': [163, "C"],
    'ค': [164, "C"],
    'ฅ': [165, "C"],
    'ฆ': [166, "C"],
    'ง': [167, "C"],
    'จ': [168, "C"],
    'ฉ': [169, "C"],
    'ช': [170, "C"],
    'ซ': [171, "C"],
    'ฌ': [172, "C"],
    'ญ': [173, "C"],
    'ฎ': [174, "C"],
    'ฏ': [175, "C"],
    'ฐ': [176, "C"],
    'ฑ': [177, "C"],
    'ฒ': [178, "C"],
    'ณ': [179, "C"],
    'ด': [180, "C"],
    'ต': [181, "C"],
    'ถ': [182, "C"],
    'ท': [183, "C"],
    'ธ': [184, "C"],
    'น': [185, "C"],
    'บ': [186, "C"],
    'ป': [187, "C"],
    'ผ': [188, "C"],
    'ฝ': [189, "C"],
    'พ': [190, "C"],
    'ฟ': [191, "C"],
    'ภ': [192, "C"],
    'ม': [193, "C"],
    'ย': [194, "C"],
    'ร': [195, "C"],
    'ฤ': [196, "C"],
    'ล': [197, "C"],
    'ฦ': [198, "C"],
    'ว': [199, "C"],
    'ศ': [200, "C"],
    'ษ': [201, "C"],
    'ส': [202, "C"],
    'ห': [203, "C"],
    'ฬ': [204, "C"],
    'อ': [205, "C"],
    'ฮ': [206, "C"],
    'ฯ': [207, "C"],
    'ะ': [208, "C"],
    'ั': [209, "U"],
    'า': [210, "C"],
    'ำ': [211, "C"],

    'ิ': [212, "U"],
    'ึ': [213, "U"],
    'ื': [214, "U"],
    'ี': [215, "U"],
    'ุ': [216, "D"], // สระ อุ
    'ู': [217, "D"], // สระ อู
    //'.': [218, "C"],

    '฿': [223, "C"],
    'เ': [224, "C"],
    'แ': [225, "C"],
    'โ': [226, "C"],
    'ใ': [227, "C"],
    'ไ': [228, "C"],
    'ๅ': [229, "C"],
    'ๆ': [230, "C"],
    '็': [231, "U"],
    '่': [232, "U"], //เอก
    '้': [233, "U"], // โท
    '๊': [234, "U"], // ตรี
    '๋': [235, "U"], // จัด
    '์': [236, "U"], //การัน
    'ฺ': [237, "U"],
    // '': [238, "D"],
    // '': [239, "C"],
    // '0': [240, "C"],
    '๑': [241, "C"],
    '๒': [242, "C"],
    '๓': [243, "C"],
    '๔': [244, "C"],
    '๕': [245, "C"],
    '๖': [246, "C"],
    '๗': [247, "C"],
    '๘': [248, "C"],
    '๙': [249, "C"], // เพิ่มตำแหน่ง 3 ให้ return ตัวเอง มาเช็คได้ ซ้ำหรับ  อิ่ อิ้ อิ๊ อิ๋ อื อึ// แมป ใหม่
  };

  return thaiAsciiMap[character] ?? [-1]; // หรืออื่นๆ ตามความเหมาะสม
}

int LIMIT_RANGE(String text, int LIMIT) {
  int total_index = text.length;
  int UP = 0;
  int CENTER = 0;
  int DOWN = 0;
  for (int i = 0; i < total_index; i++) {
    //  print(i);
    List<dynamic> asciiValue = thaiAscii(text[i]);

    if (asciiValue.isEmpty || asciiValue.length != 2) {
      // ตรวจสอบความยาวของ List
      // If it's not a Thai character, use normal ASCII code units

      CENTER++;
      if (CENTER >= LIMIT) {
        break;
      }
    } else {
      int asciiCode = asciiValue[0];
      String position = asciiValue[1];
      if (position == "U") {
        UP++;
      } else if (position == "C") {
        CENTER++;
        if (CENTER >= LIMIT) {
          break;
        }
      } else if (position == "D") {
        DOWN++;
      }
    }
  }

  return UP + CENTER + DOWN;
}

List<List<int>> thaiStringToAsciiList(String text) {
  List<int> UP_UP = [];

  List<int> UP = [];
  List<int> CENTER = [];
  List<int> DOWN = [];

  int total_index = text.length;
  for (int i = 0; i < total_index; i++) {
    //  print(i);
    List<dynamic> asciiValue = thaiAscii(text[i]);

    //print(asciiValue);

    if (asciiValue.isEmpty || asciiValue.length != 2) {
      // ตรวจสอบความยาวของ List
      // If it's not a Thai character, use normal ASCII code units
      UP.add(0x20);
      CENTER.add(text[i].codeUnitAt(0));
      DOWN.add(0x20);
    } else {
      int asciiCode = asciiValue[0];
      String position = asciiValue[1];
      if (position == "U") {
        UP.removeLast();
        UP.add(asciiCode);
        if (i > 1) {
          //  print("fsfsfff");

          List<dynamic> asciiValue_before = thaiAscii(text[i - 1]);
          String position_before = asciiValue_before[1];
          int asciiCode_before = asciiValue_before[0];

          if (position_before == "U") {
            print("U");

            if (asciiCode_before == 209) {
              //ไม่หัน
              if (asciiCode == 232) {
                UP.removeLast();
                UP.add(145);

                //เอก
              } else if (asciiCode == 233) {
                //โท
                UP.removeLast();
                UP.add(146);
              } else if (asciiCode == 234) {
                //ตรี
                UP.removeLast();
                UP.add(147);
              } else if (asciiCode == 235) {
                //ตรี
                UP.removeLast();
                UP.add(148);
              } else {}
            }

            if (asciiCode_before == 212) {
              //อิ
              if (asciiCode == 232) {
                UP.removeLast();
                UP.add(150);

                //เอก
              } else if (asciiCode == 233) {
                //โท
                UP.removeLast();
                UP.add(151);
              } else if (asciiCode == 234) {
                //ตรี
                UP.removeLast();
                UP.add(152);
              } else if (asciiCode == 235) {
                //ตรี    UP.removeLast();
                UP.removeLast();
                UP.add(153);
              } else if (asciiCode == 236) {
                //ตรี    UP.removeLast();
                UP.removeLast();
                UP.add(154);
              } else {}
            }
            if (asciiCode_before == 213) {
              //อี
              if (asciiCode == 232) {
                UP.removeLast();
                UP.add(155);
              } else if (asciiCode == 233) {
                UP.removeLast();
                UP.add(156);
              } else if (asciiCode == 234) {
                UP.removeLast();
                UP.add(157);
              } else if (asciiCode == 235) {
                UP.removeLast();
                UP.add(158);
              } else {}
            }

            /*  if (asciiCode_before == 214) {
              //อึ
              if (asciiCode == 232) {
              } else if (asciiCode == 233) {
                UP.removeLast();
                UP.add(219);
              } else if (asciiCode == 234) {
                UP.removeLast();
                UP.add(220);
              } else if (asciiCode == 235) {
                UP.removeLast();
                UP.add(221);
              } else if (asciiCode == 235) {
                //ตรี
                UP.removeLast();
                UP.add(222);
              } else {}
            }*/
            if (asciiCode_before == 214 || asciiCode_before == 215) {
              //อื
              if (asciiCode == 232) {
                UP.removeLast();
                UP.add(219);
              } else if (asciiCode == 233) {
                UP.removeLast();
                UP.add(220);
              } else if (asciiCode == 234) {
                UP.removeLast();
                UP.add(221);
              } else if (asciiCode == 235) {
                UP.removeLast();
                UP.add(222);
              } else {}
            }
          }
        }
        //  CENTER.add(0x20);
        // DOWN.add(0x20);
      } else if (position == "C") {
        UP.add(0x20);
        CENTER.add(asciiCode);
        DOWN.add(0x20);
      } else if (position == "D") {
        // UP.add(0x20);
        // CENTER.add(0x20);
        DOWN.removeLast();

        DOWN.add(asciiCode);
      }

      //////1B 4A 00
    }
  }
  return [UP, CENTER, DOWN];
}

Future<void> ENGPRINT(UsbPort port, String aline, String data, int font, bool both) async {
  List<int> engtext = [];
  List<int> spaceList = [];
  List<int> FONT = []; //27, 36, 0, 0, 29, 33, 17, 28, 46  //27, 36, 0, 0, 28, 46,
  List<int> BOTH = [];
  int Lenght = data.length;

  for (int i = 0; i < data.length; i++) {
    engtext.add(data[i].codeUnitAt(0));
  }

  if (aline == "center" && Lenght < 32 && font == 1) {
    int D_lenght = ((32 - Lenght) / 2).round();
    for (int i = 0; i < D_lenght; i++) {
      spaceList.add(0x20);
    }
    engtext.insertAll(0, spaceList);
  } else if (aline == "right" && Lenght < 32 && font == 1) {
    int D_lenght = ((32 - Lenght)).round();
    for (int i = 0; i < D_lenght; i++) {
      spaceList.add(0x20);
    }
    engtext.insertAll(0, spaceList);
  } else if (aline == "center" && Lenght < 16 && font == 2) {
    int D_lenght = ((16 - Lenght) / 2).round();
    for (int i = 0; i < D_lenght; i++) {
      spaceList.add(0x20);
    }
    engtext.insertAll(0, spaceList);
  } else if (aline == "right" && Lenght < 16 && font == 2) {
    int D_lenght = ((16 - Lenght)).round();
    for (int i = 0; i < D_lenght; i++) {
      spaceList.add(0x20);
    }
    engtext.insertAll(0, spaceList);
  }

  if (Lenght > 32 && font == 1) {
    engtext = engtext.sublist(0, 32);
  }
  if (Lenght > 16 && font == 2) {
    engtext = engtext.sublist(0, 16);
  }

  if (both) {
    BOTH = [
      27,
      69,
      1,
    ];
  } else {
    BOTH = [
      27,
      69,
      0,
    ];
  }
  if (font == 2) {
    FONT = [27, 36, 0, 0, 29, 33, 17, 28, 46];
  } else if (font == 1) {
    FONT = [27, 36, 0, 0, 29, 33, 0]; //center  = [0x1B, 0x21, 0x01];
  } else {
    FONT = [0x00];
  }
  await port?.write(Uint8List.fromList([0x1B, 0x33, 0x00])); //
  await Future.delayed(Duration(milliseconds: 10));
  await port?.write(Uint8List.fromList(FONT));
  await Future.delayed(Duration(milliseconds: 10));
  await port?.write(Uint8List.fromList(BOTH));
  await Future.delayed(Duration(milliseconds: 10));

  await port?.write(Uint8List.fromList(engtext + [0x0d, 0x0a]));

  await Future.delayed(Duration(milliseconds: 10));
}

Future<void> THAI_PRINT(UsbPort port, String aline, String data, int font, bool both) async {
  List<List<int>> TEXT = thaiStringToAsciiList(data);
  List<int> spaceList = [];
  List<int> FONT = []; //27, 36, 0, 0, 29, 33, 17, 28, 46  //27, 36, 0, 0, 28, 46,
  List<int> BOTH = [];
  int Lenght = TEXT[1].length;

  if (TEXT.length >= 3) {
    //15
    if (aline == "center" && Lenght < 32 && font == 1) {
      int D_lenght = ((32 - Lenght) / 2).round();
      for (int i = 0; i < D_lenght; i++) {
        spaceList.add(0x20);
      }
      TEXT[0].insertAll(0, spaceList);
      TEXT[1].insertAll(0, spaceList);
      TEXT[2].insertAll(0, spaceList);
    } else if (aline == "right" && Lenght < 32 && font == 1) {
      int D_lenght = ((32 - Lenght)).round();
      for (int i = 0; i < D_lenght; i++) {
        spaceList.add(0x20);
      }
      TEXT[0].insertAll(0, spaceList);
      TEXT[1].insertAll(0, spaceList);
      TEXT[2].insertAll(0, spaceList);
    } else if (aline == "center" && Lenght < 16 && font == 2) {
      int D_lenght = ((16 - Lenght) / 2).round();
      for (int i = 0; i < D_lenght; i++) {
        spaceList.add(0x20);
      }
      TEXT[0].insertAll(0, spaceList);
      TEXT[1].insertAll(0, spaceList);
      TEXT[2].insertAll(0, spaceList);
    } else if (aline == "right" && Lenght < 16 && font == 2) {
      int D_lenght = ((16 - Lenght)).round();
      for (int i = 0; i < D_lenght; i++) {
        spaceList.add(0x20);
      }
      TEXT[0].insertAll(0, spaceList);
      TEXT[1].insertAll(0, spaceList);
      TEXT[2].insertAll(0, spaceList);
    }

    if (Lenght > 32 && font == 1) {
      TEXT[0] = TEXT[0].sublist(0, 32);
      TEXT[1] = TEXT[1].sublist(0, 32);
      TEXT[2] = TEXT[2].sublist(0, 32);
    }
    if (Lenght > 16 && font == 2) {
      TEXT[0] = TEXT[0].sublist(0, 16);
      TEXT[1] = TEXT[1].sublist(0, 16);
      TEXT[2] = TEXT[2].sublist(0, 16);
    }

    if (both) {
      BOTH = [
        27,
        69,
        1,
      ];
    } else {
      BOTH = [
        27,
        69,
        0,
      ];
    }
    if (font == 2) {
      FONT = [27, 36, 0, 0, 29, 33, 17, 28, 46];
    } else if (font == 1) {
      FONT = [27, 36, 0, 0, 29, 33, 0]; //center  = [0x1B, 0x21, 0x01];
    } else {
      FONT = [0x00];
    }

    await port?.write(Uint8List.fromList([0x1B, 0x33, 0x00])); //
    await Future.delayed(Duration(milliseconds: 10));
    await port?.write(Uint8List.fromList(FONT));
    await Future.delayed(Duration(milliseconds: 10));
    await port?.write(Uint8List.fromList(BOTH));
    await Future.delayed(Duration(milliseconds: 10));

    await port?.write(Uint8List.fromList(TEXT[0] + [0x0d, 0x0a]));
    await Future.delayed(Duration(milliseconds: 10));
    await port?.write(Uint8List.fromList(TEXT[1] + [0x0d, 0x0a]));
    await Future.delayed(Duration(milliseconds: 10));
    await port?.write(Uint8List.fromList(TEXT[2] + [0x0d, 0x0a]));
    await Future.delayed(Duration(milliseconds: 10));

    //await port?.write(Uint8List.fromList([0x0d, 0x0a]));
    // await port?.close();
  } else {
    print("ERROR");
  }
}

Future<void> PRINT_ENG_FULL_CENTER(UsbPort port, String data1, String data2) async {
  List<int> TEXT1 = [];
  List<int> TEXT2 = [];

  for (int i = 0; i < data1.length; i++) {
    TEXT1.add(data1[i].codeUnitAt(0));
  }
  for (int i = 0; i < data2.length; i++) {
    TEXT2.add(data2[i].codeUnitAt(0));
  }

  List<int> FONT = [];
  List<int> BOTH = [];
  int LENGHT = 32 - (TEXT1.length + TEXT2.length);
  if (LENGHT < 0) {
    LENGHT = 0;
  }
  List<int> dashList0 = List.filled(LENGHT, 0x20);

  List<int> ALL_TEXT0 = TEXT1 + dashList0 + TEXT2;

  if (ALL_TEXT0.length > 32) {
    ALL_TEXT0 = ALL_TEXT0.sublist(0, 32);
  }

/*
     while (TEXT[2].length < 32) {
        TEXT[0].add(0x20);
        TEXT[1].add(0x20);
        TEXT[2].add(0x20);
      }*/

  BOTH = [
    27,
    69,
    0,
  ];
  FONT = [27, 36, 0, 0, 29, 33, 0]; //center  = [0x1B, 0x21, 0x01];

  await port?.write(Uint8List.fromList([0x1B, 0x33, 0x0A])); //
  await Future.delayed(Duration(milliseconds: 20));
  await port?.write(Uint8List.fromList(FONT));
  await Future.delayed(Duration(milliseconds: 20));
  await port?.write(Uint8List.fromList(BOTH));
  await Future.delayed(Duration(milliseconds: 20));

  await port?.write(Uint8List.fromList(ALL_TEXT0 + [0x0d, 0x0a])); //+ [0x0d, 0x0a]
  await Future.delayed(Duration(milliseconds: 20));
}

Future<void> PRINT_THAI_FULL_CENTER(UsbPort port, String data1, String data2) async {
  List<List<int>> TEXT1 = thaiStringToAsciiList(data1);
  List<List<int>> TEXT2 = thaiStringToAsciiList(data2);
  List<int> FONT = [];
  List<int> BOTH = [];
  int LENGHT = 32 - (TEXT1[1].length + TEXT2[1].length);
  if (LENGHT < 0) {
    LENGHT = 0;
  }
  List<int> dashList0 = List.filled(LENGHT, 0x20);
  List<int> dashList1 = List.filled(LENGHT, 0x20);
  List<int> dashList2 = List.filled(LENGHT, 0x20);

  List<int> ALL_TEXT0 = TEXT1[0] + dashList0 + TEXT2[0];
  List<int> ALL_TEXT1 = TEXT1[1] + dashList1 + TEXT2[1];
  List<int> ALL_TEXT2 = TEXT1[2] + dashList2 + TEXT2[2];

  if (ALL_TEXT0.length > 32) {
    ALL_TEXT0 = ALL_TEXT0.sublist(0, 32);
  }
  if (ALL_TEXT1.length > 32) {
    ALL_TEXT1 = ALL_TEXT1.sublist(0, 32);
  }
  if (ALL_TEXT2.length > 32) {
    ALL_TEXT2 = ALL_TEXT2.sublist(0, 32);
  }
/*
     while (TEXT[2].length < 32) {
        TEXT[0].add(0x20);
        TEXT[1].add(0x20);
        TEXT[2].add(0x20);
      }*/

  BOTH = [
    27,
    69,
    0,
  ];
  FONT = [27, 36, 0, 0, 29, 33, 0]; //center  = [0x1B, 0x21, 0x01];
  await port?.write(Uint8List.fromList([0x1B, 0x33, 0x00])); //
  await Future.delayed(Duration(milliseconds: 20));
  await port?.write(Uint8List.fromList(FONT));
  await Future.delayed(Duration(milliseconds: 20));
  await port?.write(Uint8List.fromList(BOTH));
  await Future.delayed(Duration(milliseconds: 20));

  await port?.write(Uint8List.fromList(ALL_TEXT0 + [0x0d, 0x0a])); //+ [0x0d, 0x0a]
  await Future.delayed(Duration(milliseconds: 20));
  await port?.write(Uint8List.fromList(ALL_TEXT1 + [0x0d, 0x0a]));
  await Future.delayed(Duration(milliseconds: 20));
  await port?.write(Uint8List.fromList(ALL_TEXT2 + [0x0d, 0x0a])); //0x1B, 0x33, 0x00
  await Future.delayed(Duration(milliseconds: 20));
}

Future<void> LINE_PRINT(UsbPort port) async {
  List<int> FONT = []; //27, 36, 0, 0, 29, 33, 17, 28, 46  //27, 36, 0, 0, 28, 46,
  List<int> BOTH = [];
  List<int> dashList = List.filled(32, '.'.codeUnitAt(0));
  BOTH = [
    27,
    69,
    0,
  ];
  FONT = [27, 36, 0, 0, 29, 33, 0]; //center  = [0x1B, 0x21, 0x01];
  // await port?.write(Uint8List.fromList([0x0d, 0x0a, 0x1B, 0x33, 0x00])); //

  await port?.write(Uint8List.fromList(dashList + [0x0d, 0x0a]));
  await Future.delayed(Duration(milliseconds: 20));
}

Future<void> LINE_FEED(UsbPort port) async {
  await port?.write(Uint8List.fromList([0x0d, 0x0a]));
  await Future.delayed(Duration(milliseconds: 20));
}
/*
  final index = list.indexOf(valueToRemove);
  List<int> FINAL_TEXT = [];
  if (index != -1) {
    List<int> firstPart = list.sublist(0, index); // แบ่งส่วนแรกจาก index 0 ถึง 2 (ไม่รวม index 3)
    List<int> secondPart = list.sublist(index + 1);

    firstPart.addAll(newValue);
    firstPart.addAll(secondPart);
    FINAL_TEXT.addAll(firstPart);
  }
  print(list);*/
