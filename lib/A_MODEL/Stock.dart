class Stock {
  int unix = 0;
  String data_time = "";
  String units = "";
  String id = "";
  String type = "";
  String name = "";

  String state = "";
  String who = "";
  double num = 0;
  String other = "";

  Stock({
    required this.unix,
    required this.data_time,
    required this.units,
    required this.type,
    required this.name,
    required this.id,
    required this.state,
    required this.who,
    required this.num,
    required this.other,
  });
}

class display_stock {
  String id = "";
  String units = "";
  String type = "";

  String name = "";
  double sum = 0;

  display_stock({
    required this.id,
    required this.units,
    required this.type,
    required this.name,
    required this.sum,
  });
}
