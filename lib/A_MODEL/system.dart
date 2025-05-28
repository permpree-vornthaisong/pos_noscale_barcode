class System {
  bool activate = false;
  bool discount_mode = false;
  bool vat_mode = false;
  bool login_mode = false;
  bool drawer_manual = false;
  String SN = "";
  String number_prompt_pay = "";
  String cashier = "";
  String role = "";
  String low_cash_allow = "";
  String language = "thai";
  String vat = "0.00";
  String vat_num = "123456789";
  String format_input = "";
  String printter = "";

  bool weight_mode = false;

  System({
    required this.activate,
    required this.vat,
    required this.vat_num,
    required this.format_input,
    required this.printter,
    required this.discount_mode,
    required this.login_mode,
    required this.drawer_manual,
    required this.low_cash_allow,
    required this.SN,
    required this.vat_mode,
    required this.weight_mode,
    required this.number_prompt_pay,
    required this.cashier,
    required this.role,
    required this.language,
  });
}
