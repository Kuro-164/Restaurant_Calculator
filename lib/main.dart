import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/menu_item.dart';
import 'models/cart_item.dart';
import 'screens/calculator_screen.dart';
import 'data/load_menu_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(MenuItemAdapter());
  Hive.registerAdapter(CartItemAdapter());

  // Open boxes with proper types
  final menuBox = await Hive.openBox<MenuItem>('menu');
  final cartBox = await Hive.openBox<CartItem>('cart');  // ← Change this line

  // Load menu data
  await loadMenuData(menuBox);

  runApp(MyApp(menuBox: menuBox, cartBox: cartBox));
}

class MyApp extends StatelessWidget {
  final Box<MenuItem> menuBox;
  final Box<CartItem> cartBox;  // ← Change this line

  const MyApp({
    Key? key,
    required this.menuBox,
    required this.cartBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saravana Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: CalculatorScreen(
        menuBox: menuBox,
        cartBox: cartBox,
      ),
    );
  }
}