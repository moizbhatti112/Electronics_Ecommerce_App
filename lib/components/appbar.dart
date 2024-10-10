import 'package:ecommerce1/components/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  String? username;
  String profileImageUrl = 'https://avatar.iran.liara.run/public'; // Default profile image URL

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Fetch username when the screen initializes
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username'); // Load username from SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username != null
                  ? 'Welcome, $username ' // Display username once loaded
                  : 'Welcome', // Default message before username is loaded
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Profile(),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              profileImageUrl, // Display profile image from the URL
              height: 55,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}
