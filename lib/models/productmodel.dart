
class Product {
  final String image;
  final String name;
  final String price;
  final String description;
   int quantity; 

  // Constructor
  Product({
    required this.image,
    required this.name,
    required this.price,
    required this.description,
     this.quantity = 1,
  });

  // Convert a Product into a Map
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  // Create a Product from a Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      description: map['description'] ?? '',
    );
  }
}



