import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  @HiveField(2)
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}
