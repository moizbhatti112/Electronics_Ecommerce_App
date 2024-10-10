import 'package:ecommerce1/colors/color.dart';
import 'package:flutter/material.dart';

class Addbutton extends StatefulWidget {
  const Addbutton({super.key});

  @override
  State<Addbutton> createState() => _AddbuttonState();
}

class _AddbuttonState extends State<Addbutton> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height*0.05,
      width: MediaQuery.of(context).size.width*0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: gry
      ),
      child: const Icon(Icons.add,color: Colors.white,),
    );
  }
}