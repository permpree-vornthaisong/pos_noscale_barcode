import 'dart:ffi';

import 'package:pos_noscale_barcode/A_MODEL/data_display.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_display_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/filter_numname_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/tab_timer_provider.dart';
import 'package:provider/provider.dart';

void test(String data, String KEYS, context) {
  final data_displays = Provider.of<data_display_provider>(context, listen: false);
  final filter_num_name_provider filter_num_names = Provider.of<filter_num_name_provider>(context, listen: false);
  final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false); //TabTimerProvider
  final TabTimerProvider TabTimerProviders = Provider.of<TabTimerProvider>(context, listen: false);
  if (KEYS != "Tab") {
    if (KEYS == "Backspace") {
      data_displays.removeLastCharacter();
      filter_num_names.update_data(data_displays.get_all()[0].name);
      data_products.info(context);
    } else if (KEYS == "Enter") {
      final data_display_provider data_displays = Provider.of<data_display_provider>(context, listen: false);
      final bill_provider bills = Provider.of<bill_provider>(context, listen: false);

      if (data_products.get_all()[0].unit != "KG") {
        data_displays.update(data_display(
            index: "index",
            id: "id",
            name: data_products.get_all()[0].name,
            price: data_products.get_all()[0].price,
            type: "type",
            item: 1,
            unit: "unit"));
      } else if (data_products.get_all()[0].unit != "p") {
        data_displays.update(data_display(index: "index", id: "id", name: " ", price: "0.00", type: "type", item: 1, unit: "unit"));
      }
      bills.add_data_pick_up(data_products.get_all()[0].id, context);
    } else {
      List<dynamic> DATA = mapping_th_key(data);

      if (TabTimerProviders.getTransactions()[0].state) {
        print(DATA[0].length);
        /* if (DATA[1] == 1) {
          DATA[0] = DATA[0].substring(1);
        }*/

        data_displays.update_name(data_displays.get_all()[0].name + DATA[0]);

        filter_num_names.update_data(data_displays.get_all()[0].name);
        data_products.info(context);
      } else {
        /* if (DATA[1] == 1) {
          DATA[0] = DATA[0].substring(1);
        }*/
        data_displays.update_name(data_displays.get_all()[0].name + data);
        filter_num_names.update_data(data_displays.get_all()[0].name);
        data_products.info(context);
      }
    }
  } else if (KEYS == "Tab") {
    TabTimerProviders.startTimer();
  }
}

List<dynamic> mapping_th_key(String data) {
  //print(data);
  Map<String, List<dynamic>> HID_TH_MAPPING =
      // Map แบบธรรมดา
      {
    'q': ['ๆ', 0],
    'w': ['ไ', 0],
    'e': ['ำ', 0],
    'r': ['พ', 0],
    't': ['ะ', 0],
    'y': ['ั', 0],
    'u': ['ี', 0],
    'i': ['ร', 0],
    'o': ['น', 0],
    'p': ['ย', 0],
    'a': ['ฟ', 0],
    's': ['ห', 0],
    'd': ['ก', 0],
    'f': ['ด', 0],
    'g': ['เ', 0],
    'h': ['้', 0],
    'j': ['่', 0],
    'k': ['า', 0],
    'ส': ['l', 0],
    ';': ['ว', 0],
    'z': ['ผ', 0],
    'x': ['ป', 0],
    'c': ['แ', 0],
    'v': ['อ', 0],
    'b': ['ิ', 0],
    'n': ['ื', 0],
    'l': ['ส', 0],
    'm': ['ท', 0],
    ',': ['ม', 0],
    '.': ['ใ', 0],
    '/': ['ฝ', 0],
    '[': ['บ', 0],
    ']': ['ล', 0],
    '\\': ['ฃ', 0],
    '`': ['`', 0],
    '=': ['ช', 0],
    '-': ['ข', 0],
    '\'': ['ง', 0],
    '1': ['ๅ', 0],
    '2': ['/', 0],
    '3': ['-', 0],
    '4': ['ภ', 0],
    '5': ['ถ', 0],
    '6': ['ุ', 0],
    '7': ['ึ', 0],
    '8': ['ค', 0],
    '9': ['ต', 0],
    '0': ['จ', 0],
    /////////////////////////////
    'Q': ['๐', 1],
    'W': ['"', 1],
    'E': ['ฎ', 1],
    'R': ['ฑ', 1],
    'T': ['ธ', 1],
    'Y': ['ํ', 1],
    'U': ['๊', 1],
    'I': ['ณ', 1],
    'O': ['ฯ', 1],
    'P': ['ญ', 1],
    'A': ['ฤ', 1],
    'S': ['ฆ', 1],
    'D': ['ฏ', 1],
    'F': ['โ', 1],
    'G': ['ฌ', 1],
    'H': ['็', 1],
    'J': ['๋', 1],
    'K': ['ษ', 1],
    'L': ['ศ', 1],
    ':': ['ซ', 1],
    'Z': ['(', 1],
    'X': [')', 1],
    'C': ['ฉ', 1],
    'V': ['ฮ', 1],
    'B': ['ฺ', 1],
    'N': ['์', 1],
    'M': ['?', 1],
    '<': ['ฒ', 1],
    '>': ['ฬ', 1],
    '?': ['ฦ', 1],
    '{': ['ฐ', 1],
    '}': [',', 1],
    '|': ['ฅ', 1],
    '!': ['+', 1],
    '@': ['๑', 1],
    '#': ['๒', 1],
    '\$': ['๓', 1],
    '%': ['๔', 1],
    '^': ['ู', 1],
    '&': ['฿', 1],
    '*': ['๕', 1],
    '(': ['๖', 1],
    ')': ['๗', 1],
    '_': ['๘', 1],
    '+': ['๙', 1],
    /*
    '~': '~',
    '`': '~',
    '"': '"',
    '\'': '"',
    '1': '!',
    '2': '@',
    '3': '#',
    '4': '\$',
    '5': '%',
    '6': '^',
    '7': '&',
    '8': '*',
    '9': '(',
    '0': ')',
    ' ': ' ',
    '\n': '\n',
    '\t': '\t'*/
  };
  /*// Map แบบ Caps Lock
  {
    'q': '๐', 'w': 'ไ', 'e': 'ฎ', 'r': 'ฑ', 't': 'ธ', 'y': 'ํ', 'u': '๊', 'i': 'ณ', 'o': 'ฯ', 'p': 'ญ',
    'a': 'A', 's': 'S', 'd': 'D', 'f': 'F', 'g': 'G', 'h': 'H', 'j': 'J', 'k': 'K', 'l': 'L', ';': ':',
    'z': 'Z', 'x': 'X', 'c': 'C', 'v': 'V', 'b': 'B', 'n': 'N', 'm': 'M', ',': '<', '.': '>', '/': '?',
    '[': '{', ']': '}', '\\': '|', '`': '~', '=': '+', '-': '_', '\'': '"', '1': '!', '2': '@', '3': '#',
    '4': '\$', '5': '%', '6': '^', '7': '&', '8': '*', '9': '(', '0': ')', '!': '!', '@': '@', '#': '#',
    '\$': '\$', '%': '%', '^': '^', '&': '&', '*': '*', '(': '(', ')': ')', '_': '_', '+': '+', '~': '~',
    '{': '{', '}': '}', '|': '|', ':': ':', '"': '"', '<': '<', '>': '>', '?': '?', ' ': ' ', '\n': '\n',
    '\t': '\t'
  },*/

  return HID_TH_MAPPING[data] ?? [-1];
}
