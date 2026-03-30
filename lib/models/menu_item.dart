import 'package:hive/hive.dart';

part 'menu_item.g.dart';

@HiveType(typeId: 0)
class MenuItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  @HiveField(2)
  List<String> keywords;

  @HiveField(3)
  String category;

  MenuItem({
    required this.name,
    required this.price,
    required this.keywords,
    required this.category,
  });
}
