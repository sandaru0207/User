class Menu {
  final String name;
  final int? price;

  const Menu({
    required this.name,
    required this.price,
  });

  static Menu fromJson(json) => Menu(
        name: json['name'],
        price: json['price'],
      );
}
