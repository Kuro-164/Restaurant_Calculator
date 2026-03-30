import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'billing_screen.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';

class CalculatorScreen extends StatefulWidget {
  final Box<MenuItem> menuBox;
  final Box<CartItem> cartBox;

  const CalculatorScreen({
    Key? key,
    required this.menuBox,
    required this.cartBox,
  }) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';
  String _operator = '';
  double _firstNumber = 0;
  bool _shouldResetDisplay = false;
  List<MenuItem> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = [];
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() => _filtered = []);
      return;
    }

    query = query.toLowerCase();
    setState(() {
      _filtered = widget.menuBox.values
          .where((item) =>
      item.name.toLowerCase().contains(query) ||
          item.keywords.any((kw) => kw.toLowerCase().contains(query)) ||
          item.price.toString().contains(query))
          .toList();
    });
  }

  // ✅ FIXED: Prevent leading zero issue
  void _onNumberPressed(String num) {
    setState(() {
      if (_shouldResetDisplay) {
        _display = num;
        _shouldResetDisplay = false;
      } else {
        if (_display == '0') {
          _display = num;
        } else {
          _display += num;
        }
      }
      _filterItems(_display);
    });
  }

  void _onOperatorPressed(String op) {
    if (_display.isEmpty) return;

    setState(() {
      _firstNumber = double.tryParse(_display) ?? 0;
      _operator = op;
      _display = '';
      _filtered = [];
    });
  }

  void _onEquals() {
    if (_operator.isEmpty || _display.isEmpty) return;

    double secondNumber = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operator) {
      case '+':
        result = _firstNumber + secondNumber;
        break;
      case '-':
        result = _firstNumber - secondNumber;
        break;
      case '×':
        result = _firstNumber * secondNumber;
        break;
      case '÷':
        result = secondNumber != 0 ? _firstNumber / secondNumber : 0;
        break;
    }

    setState(() {
      _display = result.toString();
      if (result == result.toInt()) {
        _display = result.toInt().toString();
      }
      _operator = '';
      _firstNumber = 0;
      _shouldResetDisplay = true;
      _filterItems(_display);
    });
  }

  void _onClear() {
    setState(() {
      _display = '';
      _operator = '';
      _firstNumber = 0;
      _shouldResetDisplay = false;
      _filtered = [];
    });
  }

  void _onAllClear() {
    widget.cartBox.clear();
    setState(() {
      _display = '';
      _operator = '';
      _firstNumber = 0;
      _shouldResetDisplay = false;
      _filtered = [];
    });
  }

  // ✅ NEW: Backspace
  void _onBackspace() {
    if (_display.isNotEmpty) {
      setState(() {
        _display = _display.substring(0, _display.length - 1);
        _filterItems(_display);
      });
    }
  }

  void _addToCart(MenuItem item) {
    CartItem? existingItem;
    for (var i = 0; i < widget.cartBox.length; i++) {
      final cartItem = widget.cartBox.getAt(i);
      if (cartItem != null &&
          cartItem.name == item.name &&
          cartItem.price == item.price) {
        existingItem = cartItem;
        break;
      }
    }

    if (existingItem != null) {
      existingItem.quantity++;
      existingItem.save();
    } else {
      widget.cartBox.add(CartItem(
        name: item.name,
        price: item.price,
        quantity: 1,
      ));
    }

    setState(() {});
  }

  void _removeFromCart(MenuItem item) {
    for (var i = 0; i < widget.cartBox.length; i++) {
      final cartItem = widget.cartBox.getAt(i);
      if (cartItem != null &&
          cartItem.name == item.name &&
          cartItem.price == item.price) {
        if (cartItem.quantity > 1) {
          cartItem.quantity--;
          cartItem.save();
        } else {
          cartItem.delete();
        }
        setState(() {});
        return;
      }
    }
  }

  int _getItemQuantity(MenuItem item) {
    for (var i = 0; i < widget.cartBox.length; i++) {
      final cartItem = widget.cartBox.getAt(i);
      if (cartItem != null &&
          cartItem.name == item.name &&
          cartItem.price == item.price) {
        return cartItem.quantity;
      }
    }
    return 0;
  }

  double _getTotal() {
    double total = 0;
    for (var cartItem in widget.cartBox.values) {
      total += cartItem.price * cartItem.quantity;
    }
    return total;
  }

  int _getTotalItems() {
    int count = 0;
    for (var cartItem in widget.cartBox.values) {
      count += cartItem.quantity;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final total = _getTotal();
    final itemCount = _getTotalItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saravana Calculator'),
        backgroundColor: Colors.teal,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Items: $itemCount',
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Display area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Text(
                  _display.isEmpty ? '0' : _display,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cart Total: ₹${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.teal[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Filtered items list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _display.isEmpty
                        ? Icons.restaurant_menu
                        : Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _display.isEmpty
                        ? 'Enter numbers to search items'
                        : 'No items found for "$_display"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final item = _filtered[index];
                final qty = _getItemQuantity(item);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '₹${item.price.toStringAsFixed(2)} • ${item.category}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (qty > 0) ...[
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            color: Colors.red[400],
                            iconSize: 28,
                            onPressed: () => _removeFromCart(item),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.teal, width: 1.5),
                            ),
                            child: Text(
                              '$qty',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          color: Colors.teal,
                          iconSize: 28,
                          onPressed: () => _addToCart(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Calculator buttons
          Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                const Divider(height: 1, thickness: 1),
                _buildButtonRow(['7', '8', '9', '÷']),
                _buildButtonRow(['4', '5', '6', '×']),
                _buildButtonRow(['1', '2', '3', '-']),
                _buildButtonRow(['C', '0', '=', '+']),
                _buildButtonRow(['AC', '.', '⌫', 'Bill']), // ✅ Backspace added, 00 removed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      children: buttons.map((btn) {
        Color? color;
        Color? textColor;

        if (btn == 'AC') {
          color = Colors.red;
          textColor = Colors.white;
        } else if (btn == 'C') {
          color = Colors.orange;
          textColor = Colors.white;
        } else if (btn == 'Bill') {
          color = Colors.teal;
          textColor = Colors.white;
        } else if (btn == '=' || ['+', '-', '×', '÷'].contains(btn)) {
          color = Colors.blue[700];
          textColor = Colors.white;
        }

        return Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color ?? Colors.white,
                foregroundColor: textColor ?? Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              onPressed: () => _onButtonPressed(btn),
              child: Text(
                btn,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _onButtonPressed(String btn) {
    if (['+', '-', '×', '÷'].contains(btn)) {
      _onOperatorPressed(btn);
    } else {
      switch (btn) {
        case 'C':
          _onClear();
          break;
        case 'AC':
          _onAllClear();
          break;
        case '=':
          _onEquals();
          break;
        case '⌫':
          _onBackspace();
          break;
        case 'Bill':
          if (widget.cartBox.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cart is empty!'),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BillingScreen(
                  cartItemsRaw: widget.cartBox.values.toList(),
                ),
              ),
            );
          }
          break;
        default:
          _onNumberPressed(btn);
      }
    }
  }
}
