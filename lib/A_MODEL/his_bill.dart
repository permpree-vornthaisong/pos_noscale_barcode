class his_bill {
  int INDEX = 0;
  String sn = "";
  String id_bill = "";
  String cahier = "";
  String date_time = "";

  String tax_id = "";
  String tax_money = "";
  String sum_money_before_tax = "";
  String customer = ""; // id ลูกค้า
  String type_customer = ""; // กลุ่มลูกค้า
  String discount_customer = ""; // เปอร์เซนที่ลด
  String sum_money_t = ""; // ก่อนลดราคา
  String discount = ""; // ราคาที่ลด
  // tax
  String sum_money = "";
  String pay_money = "";
  String money_back = "";
  String method_pay = ""; //if promptpay  +/ เบอร์
  String sum_list = "";
  String sum_detial_list = "";
  String state = ""; // "offline/yes/vat" //
  String sum_weight = "";
  List<dynamic> detial = [];

  his_bill({
    required this.INDEX,
    required this.sn,
    required this.id_bill,
    required this.cahier,
    required this.date_time,
    required this.tax_id,
    required this.tax_money,
    required this.customer,
    required this.type_customer,
    required this.discount_customer,
    required this.sum_money_t,
    required this.discount,
    required this.sum_money_before_tax,
    required this.sum_money,
    required this.pay_money,
    required this.money_back,
    required this.method_pay,
    required this.sum_list,
    required this.sum_detial_list,
    required this.state,
    required this.sum_weight,
    required this.detial,
  });
}
