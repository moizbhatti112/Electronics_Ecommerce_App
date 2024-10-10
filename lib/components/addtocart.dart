import 'package:ecommerce1/colors/color.dart';
import 'package:flutter/material.dart';

class Addtocart extends StatefulWidget {
  const Addtocart({super.key});

  @override
  State<Addtocart> createState() => _AddtocartState();
}

class _AddtocartState extends State<Addtocart> {
  @override
  Widget build(BuildContext context) {
    return Container(
     
      height: MediaQuery.of(context).size.height*0.05,
      width: MediaQuery.of(context).size.width*0.15,
      decoration:  BoxDecoration(
        color: Colors.orange,
        borderRadius:BorderRadius.circular(20)
      ),
      child: const Icon(Icons.shopping_cart,color: white,),
    );
  }
}