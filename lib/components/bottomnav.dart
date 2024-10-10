import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce1/colors/color.dart';
import 'package:ecommerce1/components/order.dart';
import 'package:ecommerce1/components/profile.dart';
import 'package:ecommerce1/screens/home.dart';
import 'package:flutter/material.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => BottomnavState();
}

class BottomnavState extends State<Bottomnav> {
  List<Widget> pages = [];
  late HomeScreen homepage;
  late Order order;
  late Profile profile;
  int currentindex = 0;

  @override
  void initState() {
    homepage = const HomeScreen();
    order = const Order();
    profile = const Profile();
    pages = [homepage, order, profile];
    super.initState();
  }

  // Function to allow external widgets to set the current index
  void setCurrentIndex(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: bgcolor,
        color: gry,
        animationDuration: const Duration(microseconds: 500),
        onTap: (int index) {
          setState(() {
            currentindex = index;
          });
        },
        items: const [
          Icon(
            Icons.home,
            color: white,
          ),
          Icon(
            Icons.shopping_bag,
            color: white,
          ),
          Icon(
            Icons.person,
            color: white,
          )
        ],
      ),
      body: pages[currentindex],
    );
  }
}
