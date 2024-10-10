import 'package:ecommerce1/colors/color.dart';
import 'package:flutter/material.dart';

class Buybutton extends StatelessWidget {
  const Buybutton({super.key});

  @override
  Widget build(BuildContext context) {
    return 
       Container(
        height: MediaQuery.of(context).size.height*0.05,
        width: MediaQuery.of(context).size.width*0.5,
        decoration: BoxDecoration(
          color: gry,
          borderRadius: BorderRadius.circular(20)
        ),
        child: const Center(child: Text('Buy Now',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: white),))
      );
    
  }
}