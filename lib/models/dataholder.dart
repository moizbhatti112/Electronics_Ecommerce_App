import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'productmodel.dart';

class Shop extends ChangeNotifier {
  List<Product> cart = [];

  Shop() {
    loadCart(); // Load saved cart items when the app starts
  }

  List<Product> get crt => cart;

  List<Product> shop = [
    Product(
      image: 'assets/images/headphone2.png',
      name: 'Headphone',
      price: '\$100',
      description: "High-quality wireless headphones with noise cancellation.",
    ),
    Product(
      image: 'assets/images/watch2.png',
      name: 'Watch',
      price: '\$100',
      description:
          "Stylish smart watch with health and fitness tracking features.",
    ),
    Product(
      image: 'assets/images/laptop2.png',
      name: 'Laptop',
      price: '\$100',
      description:
          "Powerful laptop with excellent battery life for all-day use.",
    ),
  ];

  // Get the list of products
  List<Product> getshop() {
    return shop;
  }

  void addtocart(Product item) {
    cart.add(item);
    saveCart(); // Save the cart whenever a product is added
    notifyListeners();
  }

  void removefromcart(Product item) {
    cart.remove(item);
    saveCart(); // Save the cart whenever a product is removed
    notifyListeners();
  }

  // Save the cart items to Hive
  void saveCart() async {
    final box = await Hive.openBox('cartBox');
    box.put('cartItems', cart.map((item) => item.toMap()).toList());
  }

  // Load the cart items from Hive when the app starts
  void loadCart() async {
    final box = await Hive.openBox('cartBox');
    final List<dynamic> storedCart = box.get('cartItems', defaultValue: []);
    cart = storedCart.map((item) => Product.fromMap(item)).toList();
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    product.quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    if (product.quantity > 1) {
      product.quantity -= 1;
      notifyListeners();
    }
  }
}
