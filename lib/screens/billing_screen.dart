import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class BillingScreen extends StatelessWidget {
  final List<CartItem> cartItemsRaw;

  const BillingScreen({Key? key, required this.cartItemsRaw}) : super(key: key);

  double _cartTotal() {
    return cartItemsRaw.fold(
      0,
          (sum, item) => sum + (item.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _cartTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Summary'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'SARAVANA RESTAURANT',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              DateTime.now().toString().substring(0, 16),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Cart Total: ₹${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 30, thickness: 1.5),

            // Item list
            Expanded(
              child: cartItemsRaw.isEmpty
                  ? const Center(child: Text('No items in the bill'))
                  : ListView.separated(
                itemCount: cartItemsRaw.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final item = cartItemsRaw[i];
                  final lineTotal = item.price * item.quantity;
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('₹${item.price.toStringAsFixed(2)} each'),
                    trailing: Text(
                      'x${item.quantity}  ₹${lineTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit, color: Colors.teal),
                    label: const Text('Edit Order',
                        style: TextStyle(color: Colors.teal)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.teal),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Complete Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      for (var item in cartItemsRaw) {
                        item.delete();
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order completed!')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
