import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pos_noscale_barcode/A_MODEL/system.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/page_state_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class activate {
  String who = "";
  String where = "";
  String model = "";
  String datetime = "";
  activate({required this.who, required this.where, required this.model, required this.datetime});
}

class activate_providerGG with ChangeNotifier {
  List<activate> activates = [activate(who: "who", where: "where", model: "model", datetime: "datetime")];

  List<activate> get_all() {
    return activates;
  }

  Future<void> add_data(activate data) async {
    // print("add");
    activates.add(data);
    notifyListeners();
  }

  Future<void> clear_all() async {
    //  print("clear");

    activates.clear();
    notifyListeners();
  }
}

Future<void> activate_req(context, String who, String WW, String model) async {
  DateTime now = DateTime.now();

  // แปลงเป็น string ในรูปแบบที่ต้องการ
  String formattedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
  final activate_providerGG activates = Provider.of<activate_providerGG>(context, listen: false);
  await activates.clear_all();
  activate GG = activate(who: who, where: WW, model: model, datetime: formattedDateTime);
  await activates.add_data(GG);

  // URL ของ API ที่ต้องการเรียกใช้
  String apiUrl = 'https://us-central1-activateproduct-b272d.cloudfunctions.net/ActivateProduct/activate';

  // ข้อมูลที่ต้องการส่งไปยัง API (สามารถเปลี่ยนแปลงตามที่ต้องการ)
  Map<String, dynamic> data = {"datetime": formattedDateTime, "who": who, "WW": WW, "model": model, "state": "false"};

  // Header ที่ใช้สำหรับการร้องขอ (ในที่นี้คือ API Key)
  Map<String, String> headers = {
    'Content-Type': 'application/json', // ประเภทของข้อมูลที่ส่ง
    'api-key': 'idnhlfqkhsnonpupytcfjmkibrvdtptiggrujvpfpdhqmlfvvfpojqmmqecplsaqyouxjjnbrsmvcaiuvarasnnxdtszkpiixrcrwhgxguobzxhxmvbqpqmpezrxlgud'
  };

  try {
    // ทำการร้องขอ HTTP POST ไปยัง API
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers, // ส่ง header พร้อมร้องขอ
      body: json.encode(data), // แปลงข้อมูลเป็น JSON ก่อนส่ง
    );

    // ตรวจสอบสถานะการตอบกลับ
    if (response.statusCode == 200) {
      // สำเร็จ
      //  print('Success: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ส่งค่าสำเร็จ'),
        ),
      );
    } else {
      // ไม่สำเร็จ
      //  print('Error: ${response.reasonPhrase}');
    }
  } catch (error) {
    // หากเกิดข้อผิดพลาดในการเชื่อมต่อ
    // print('Error: $error');
  }
}

Future<void> activate_confirm(context) async {
  final localDatabase = LocalDatabase();

  final activate_providerGG activates = Provider.of<activate_providerGG>(context, listen: false);
  final system_provider systems = Provider.of<system_provider>(context, listen: false);
  final page_state_provider page_states = Provider.of<page_state_provider>(context, listen: false);

  // URL ของ API ที่ต้องการเรียกใช้
  String apiUrl = 'https://us-central1-activateproduct-b272d.cloudfunctions.net/ActivateProduct/activate';

  // ข้อมูลที่ต้องการส่งไปยัง API (สามารถเปลี่ยนแปลงตามที่ต้องการ)
  Map<String, dynamic> data = {
    "datetime": activates.get_all()[0].datetime,
    "who": activates.get_all()[0].who,
    "WW": activates.get_all()[0].where,
    "model": activates.get_all()[0].model,
    "state": "true"
  };

  // Header ที่ใช้สำหรับการร้องขอ (ในที่นี้คือ API Key)
  Map<String, String> headers = {
    'Content-Type': 'application/json', // ประเภทของข้อมูลที่ส่ง
    'api-key': 'idnhlfqkhsnonpupytcfjmkibrvdtptiggrujvpfpdhqmlfvvfpojqmmqecplsaqyouxjjnbrsmvcaiuvarasnnxdtszkpiixrcrwhgxguobzxhxmvbqpqmpezrxlgud'
  };

  try {
    // ทำการร้องขอ HTTP POST ไปยัง API
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers, // ส่ง header พร้อมร้องขอ
      body: json.encode(data), // แปลงข้อมูลเป็น JSON ก่อนส่ง
    );

    // ตรวจสอบสถานะการตอบกลับ
    if (response.statusCode == 200) {
// แปลง JSON เป็น List<dynamic>
      List<dynamic> jsonData = jsonDecode(response.body);

// แปลง List<dynamic> เป็น List<Map<String, dynamic>>
      List<Map<String, dynamic>> data = jsonData.map((item) => item as Map<String, dynamic>).toList();

// เข้าถึงค่าของ "req"
      bool reqValue = data[0]['req'];

      if (reqValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ACTIVATE'),
          ),
        );

        /* await localDatabase.updatedata_state_systems(
          activate: true,
          discount_mode: systems.get_all()[0].discount_mode,
          vat_mode: systems.get_all()[0].vat_mode,
          login_mode: systems.get_all()[0].login_mode,
          SN: systems.get_all()[0].SN,
          number_prompt_pay: systems.get_all()[0].number_prompt_pay,
          cashier: systems.get_all()[0].cashier,
          language: systems.get_all()[0].language,
          vat: systems.get_all()[0].vat,
          vat_num: systems.get_all()[0].vat_num,
        );*/

        await systems.prepare_data(context);
        await page_states.update_state(1);
      }
// พิมพ์ค่าของ "req"
      // print(reqValue); // ผลลัพธ์คือ true

      //  print('Success: ${response.body}');
    } else {
      // ไม่สำเร็จ
      //  print('Error: ${response.reasonPhrase}');
    }
  } catch (error) {
    // หากเกิดข้อผิดพลาดในการเชื่อมต่อ
    //   print('Error: $error');
  }
}

Future<void> ACTIVE_PRODUCT(context) async {
  final localDatabase = LocalDatabase();

  final activate_providerGG activates = Provider.of<activate_providerGG>(context, listen: false);
  final system_provider systems = Provider.of<system_provider>(context, listen: false);
  final page_state_provider page_states = Provider.of<page_state_provider>(context, listen: false);
  await localDatabase.updatedata_state_systems(
    activate: true,
    discount_mode: systems.get_all()[0].discount_mode,
    vat_mode: systems.get_all()[0].vat_mode,
    login_mode: systems.get_all()[0].login_mode,
    SN: systems.get_all()[0].SN,
    number_prompt_pay: systems.get_all()[0].number_prompt_pay,
    cashier: systems.get_all()[0].cashier,
    role: systems.get_all()[0].role,
    language: systems.get_all()[0].language,
    vat: systems.get_all()[0].vat,
    vat_num: systems.get_all()[0].vat_num,
    format_input: systems.get_all()[0].format_input,
    printter: systems.get_all()[0].printter,
    weight_mode: systems.get_all()[0].weight_mode,
    low_cash_allow: systems.get_all()[0].low_cash_allow,
    drawer_manual: systems.get_all()[0].drawer_manual,
  );

  await systems.prepare_data(context);
  await page_states.update_state(1);
}
