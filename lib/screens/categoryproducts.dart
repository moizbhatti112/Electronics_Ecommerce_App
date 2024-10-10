import 'package:ecommerce1/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce1/models/productmodel.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryName;

  const CategoryProductsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),  // Display the selected category name
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: categoryName) // Filter by category
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Show loading spinner
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));  // Error handling
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products available'));  // Handle no products case
          }

          final products = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Product(
              name: data['name'] ?? 'Unknown',
              price: data['price']?.toString() ?? '0',
              image: data['imageUrl'] ?? '',
              description: data['description'] ?? 'No description',
            );
          }).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,  // Two items per row
              crossAxisSpacing: 10,  // Horizontal space between items
              mainAxisSpacing: 10,  // Vertical space between items
              childAspectRatio: 0.75,  // Adjust the aspect ratio for item size
            ),
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to product detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          product.image.isNotEmpty
                              ? product.image
                              : 'https://via.placeholder.com/150',  // Placeholder image
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
