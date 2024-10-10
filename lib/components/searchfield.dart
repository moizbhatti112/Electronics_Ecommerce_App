import 'package:flutter/material.dart';

class Mysearchbar extends StatefulWidget {
  const Mysearchbar({super.key});

  @override
  State<Mysearchbar> createState() => _MysearchbarState();
}

class _MysearchbarState extends State<Mysearchbar> {
  @override
  Widget build(BuildContext context) {
    return  TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20), // Circular border
      borderSide: BorderSide.none, // No visible border
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20), // Circular border when not focused
      borderSide: BorderSide.none, // No visible border
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20), // Circular border when focused
      borderSide: BorderSide.none, // No visible border
    ),
    fillColor: Colors.white, // White background color
    filled: true, // Ensures the fill color is applied
  hintText: 'Search Product',hintStyle: const TextStyle(fontSize: 15,color: Colors.grey),
  prefixIcon: const Icon(Icons.search,color: Colors.grey,)
  ),
  
)
;
  }
}
