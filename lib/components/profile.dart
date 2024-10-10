import 'package:ecommerce1/colors/color.dart';
import 'package:ecommerce1/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image; // For storing the picked image
  bool _isUploading = false; // Track upload progress
  final ImagePicker _picker = ImagePicker();
  
  // Get current user's email and uid
  final User? _user = FirebaseAuth.instance.currentUser;
  String? _userName; // Variable to store the user's name
  String? _profileImageUrl; // Store profile image URL

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch the user's name and image when the widget initializes
  }

  // Function to fetch the user's name and profile image from Firestore
  Future<void> fetchUserData() async {
    try {
      // Get the current user's email
      String? email = _user?.email;

      if (email != null) {
        // Query the 'users' collection to find the document with the matching email
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Assuming 'name' and 'profile_image_url' are fields in the user document
          setState(() {
            _userName = snapshot.docs[0]['name'];
            _profileImageUrl = snapshot.docs[0]['profile_image_url'] ?? 'https://avatar.iran.liara.run/public';
          });
          
          // Save profile image URL in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('profileImageUrl', _profileImageUrl!);
        } else {
          print('User not found');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Function to pick image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload image to Firebase Storage and save the URL in Firestore and SharedPreferences
 // Function to upload image to Firebase Storage and save the URL in Firestore and SharedPreferences
// Function to upload image to Firebase Storage and save the URL in Firestore and SharedPreferences
Future<void> _uploadImage() async {
  if (_image == null) return;

  setState(() {
    _isUploading = true;
  });

  try {
    // Upload image to Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images/${FirebaseAuth.instance.currentUser!.uid}.jpg');

    UploadTask uploadTask = storageRef.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    // Get the current user's email
    String? email = _user?.email;

    if (email != null) {
      // Query the 'users' collection to find the document with the matching email
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Update the profile image URL in the first matching document (assuming email is unique)
        DocumentReference userDoc = snapshot.docs[0].reference;

        await userDoc.update({
          'Image': downloadUrl, // Replace the old avatar URL with the new one
        });

        // Update SharedPreferences with the new profile image URL
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('profileImageUrl', downloadUrl);

        // Update UI
        setState(() {
          _profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image uploaded successfully!')),
        );
      } else {
        print('User document not found');
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error uploading image: $e')),
    );
  } finally {
    setState(() {
      _isUploading = false;
    });
  }
}



  // Function to log out the user
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        )); // Navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : (_profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null),
                  child: _image == null && _profileImageUrl == null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, color: gry),
                title: Text(
                  _userName ?? 'No username',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: gry),
                title: Text(
                  _user?.email ?? 'No email available',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _uploadImage,
                    icon: const Icon(Icons.cloud_upload, color: gry),
                    label: const Text(
                      'Upload Profile Image',
                      style: TextStyle(color: gry),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
