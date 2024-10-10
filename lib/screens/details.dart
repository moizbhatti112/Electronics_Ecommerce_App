import 'package:ecommerce1/components/addtocart.dart';
import 'package:ecommerce1/components/bottomnav.dart';
import 'package:ecommerce1/components/buybutton.dart';
import 'package:ecommerce1/models/dataholder.dart';
import 'package:ecommerce1/models/productmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 232, 235),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the product image using Image.network for online images
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            color: const Color.fromARGB(255, 226, 232, 235),
            child: product.image.isNotEmpty
                ? Image.network(
                    product
                        .image, // If product.image is a URL, use Image.network
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                  )
                : Image.asset(
                    'assets/images/placeholder.png', // Use a placeholder if no image
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${product.price}', // Display price with dollar sign
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              product.description,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    // Add product to cart using Provider
                    Provider.of<Shop>(context, listen: false)
                        .addtocart(product);

                    // Show a snackbar to confirm product was added
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                      ),
                    );

                    // Navigate to the Order page of Bottomnav
                    Navigator.of(context).popUntil((route) =>
                        route.isFirst); // Pops back to the bottom navigation
                    BottomnavState? navState =
                        context.findAncestorStateOfType<BottomnavState>()!;
                    navState
                        .setCurrentIndex(1); // Navigate to order page index
                                    },
                  child: const Addtocart(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      // Add functionality for buy button tap
                    },
                    child: const Buybutton(),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
