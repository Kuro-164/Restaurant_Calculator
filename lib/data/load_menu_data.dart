import 'package:hive/hive.dart';
import '../models/menu_item.dart';
import 'menu_data.dart';

// This function loads your menu data into Hive box
Future<void> loadMenuData(Box<MenuItem> box) async {
  final items = getMenuItems();

  // Add all items only if not already present
  if (box.isEmpty) {
    await box.addAll(items);
  }
}
