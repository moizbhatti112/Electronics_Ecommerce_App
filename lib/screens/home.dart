import 'package:ecommerce1/categories/cat_list.dart';
import 'package:ecommerce1/colors/color.dart';
import 'package:ecommerce1/components/addbutton.dart';
import 'package:ecommerce1/components/appbar.dart';
import 'package:ecommerce1/components/searchfield.dart';
import 'package:ecommerce1/screens/categoryproducts.dart';
import 'package:ecommerce1/screens/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:ecommerce1/models/productmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgcolor,
        body: SingleChildScrollView( // Wrap in SingleChildScrollView to handle overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Appbar()),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Mysearchbar(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                    ),
                    Text('See all',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(183, 41, 40, 40),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                        child: Text(
                      'All',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
             Expanded(
  child: SizedBox(
    height: MediaQuery.of(context).size.height * 0.15,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: Catlist.cat.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigate to the category products page with the selected category name
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryProductsPage(
                  categoryName: Catlist.cat[index]['name'],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Catlist.cat[index]['image'], // Display the category image
              ],
            ),
          ),
        );
      },
    ),
  ),
),

                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Products',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                    ),
                    Text('See all',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              // Fetch and display products from Firestore
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('products').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No products available');
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

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.32,
                    child: ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          margin: const EdgeInsets.only(left: 20),
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(
                                product.image.isNotEmpty
                                    ? product.image
                                    : 'https://via.placeholder.com/150', // Placeholder if no image
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.height * 0.16,
                              ),
                              Text(
                                product.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('\$${product.price}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: gry)),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailPage(product: product),
                                            ),
                                          );
                                        },
                                        child: const Addbutton())
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
