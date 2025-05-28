import 'dart:convert';
/*
Future<void> read_data_bill(List<Map<String, dynamic>> dataList, context) async {
  //customer_names.clearAllData();

  for (Map<String, dynamic> data in dataList) {
    String sn = data['sn'] ?? '';
    String id_bill = data['SN'] ?? '';
    String cahier = data['SN'] ?? '';
    String date_time = data['SN'] ?? '';
    String tax_id = data['SN'] ?? '';
    String tax_money = data['SN'] ?? '';
    String sum_money_before_tax = data['SN'] ?? '';
    String sum_money = data['SN'] ?? '';
    String pay_money = data['SN'] ?? '';

    String money_back = data['SN'] ?? '';
    String method_pay = data['SN'] ?? '';
    String sum_list = data['SN'] ?? '';
    String sum_detial_list = data['SN'] ?? '';
    String state = data['SN'] ?? '';
    String detial = data['SN'] ?? '';

    List<Map<String, dynamic>> decodedDetailList = (jsonDecode(detial) as List).cast<Map<String, dynamic>>();
  }
}*/
/*
  sn: systems.get_all()[0].SN,
      id_bill: INDEXString,
      cahier: systems.get_all()[0].cashier,
      date_time: formattedDate,

      tax_id: edit_bills.get_all()[0].TAXS,
      tax_money: vat.toStringAsFixed(2),
      sum_money_before_tax: sum_money_before_vat.toStringAsFixed(2),

      sum_money: sum_money.toStringAsFixed(2),
      pay_money: pay_money.toStringAsFixed(2),
      money_back: pay_back.toStringAsFixed(2),

      method_pay: bills.Qrcode_state() ? "Qr-code/000000000" : "rought",
      sum_list: bills.get_all().length.toString(),
      sum_detial_list: item_all.toString(),
      state: systems.get_all()[0].vat_mode ? "offline/yes/vat" : "offline/yes/no-vat", //vat
      detial: jsonEncode(detailList),

*/