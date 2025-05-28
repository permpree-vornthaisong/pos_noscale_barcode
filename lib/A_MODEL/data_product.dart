class data_product {
  String index = "";
  String id = "";
  String name = "";

  String price = "";
  String picture = "";
  String type = "";
  int item = 0;
  String other = "";
  String unit = "";
  String weight = "";
  String state = "";

  data_product({
    required this.index,
    required this.id,
    required this.name,
    required this.price,
    required this.picture,
    required this.type,
    required this.item,
    required this.unit,
    required this.other,
    required this.weight,
    required this.state,
  });
}

class data_scanner {
  String data = "";
  String money = "";
  String weight = "";
  data_scanner({required this.data, required this.money, required this.weight});
}

class type_data {
  String type = "";

  type_data({required this.type});
}
