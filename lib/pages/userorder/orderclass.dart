class Order {
  final int total;
  final int veg_count;
  final int veg_price;
  final int egg_count;
  final int egg_price;
  final int chicken_count;
  final int chicken_price;
  final int rice_count;
  final int rice_price;
  final int kottu_count;
  final int kottu_price;
  final int fish_count;
  final int fish_price;
  final String orderid;

  const Order({
    required this.total,
    required this.veg_count,
    required this.veg_price,
    required this.egg_count,
    required this.egg_price,
    required this.chicken_count,
    required this.chicken_price,
    required this.rice_count,
    required this.rice_price,
    required this.kottu_count,
    required this.kottu_price,
    required this.fish_count,
    required this.fish_price,
    required this.orderid,
  });

  static Order fromJson(json) => Order(
        total: json['total'],
        veg_count: json['veg_count'],
        veg_price: json['veg_price'],
        egg_count: json['egg_count'],
        egg_price: json['egg_price'],
        chicken_count: json['chicken_count'],
        chicken_price: json['chicken_price'],
        rice_count: json['rice_count'],
        rice_price: json['rice_price'],
        kottu_count: json['kottu_count'],
        kottu_price: json['kottu_price'],
        fish_count: json['fish_count'],
        fish_price: json['fish_price'],
        orderid: json['_id'],
      );
}
