import 'package:ecommerce1/colors/color.dart';
import 'package:ecommerce1/screens/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Stack(
        children: [
          
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Image.asset('assets/images/splashpng.png',fit: BoxFit.cover,),
              
            )),
            Align(
            alignment: Alignment.bottomCenter,
             child:
              GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => const Login(), ));
              },
               child: Container(
                  width: MediaQuery.of(context).size.width*0.19,
                  height: MediaQuery.of(context).size.height*0.2,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 100, 99, 99),
                    shape: BoxShape.circle
                  ),
                  child: const Icon(Icons.forward,color: Colors.white,size: 40,),
                ),
             ),
           ),
        ],
      ),
    );
  }
}