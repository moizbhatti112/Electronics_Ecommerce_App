import 'package:ecommerce1/colors/color.dart';
import 'package:ecommerce1/models/dataholder.dart';
import 'package:ecommerce1/models/productmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    // Access cart items from the provider
    List<Product> cartItems = Provider.of<Shop>(context).crt;

    // Calculate total cart price based on quantity
    double totalPrice = cartItems.fold(
        0, (sum, item) => sum + double.parse(item.price) * item.quantity);

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        title: const Text('Order Summary'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('No items in cart'))
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartItems[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Product image and details on the left
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        product.image,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Display individual price
                                        Text(
                                          "\$${double.parse(product.price).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            // Quantity selector
                                            IconButton(
                                              onPressed: () {
                                                if (product.quantity > 1) {
                                                  Provider.of<Shop>(context,
                                                          listen: false)
                                                      .decreaseQuantity(
                                                          product);
                                                }
                                              },
                                              icon: const Icon(Icons.remove),
                                            ),
                                            Text(
                                              product.quantity.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Provider.of<Shop>(context,
                                                        listen: false)
                                                    .increaseQuantity(product);
                                              },
                                              icon: const Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Total price of the product on the right side
                                Text(
                                  "\$${(double.parse(product.price) * product.quantity).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Total cart price display at the bottom
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${totalPrice.toStringAsFixed(2)}", // Display total cart price
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
