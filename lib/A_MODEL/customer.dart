class customer {
  String INDEX = "";
  String name = "";
  String id = "";
  String type = "";
  customer({
    required this.INDEX,
    required this.name,
    required this.id,
    required this.type,
  });
}

class discount_customer {
  String type = "";
  double discount = 0.00;
  discount_customer({required this.type, required this.discount});
}
