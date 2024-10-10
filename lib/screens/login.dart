import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce1/Admin/addproduct.dart';
import 'package:ecommerce1/colors/color.dart';
import 'package:ecommerce1/components/bottomnav.dart';
import 'package:ecommerce1/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;

  /// Handles regular user login
  // void userLogin() async {
  //   showDialog(
  //     context: context,
  //     builder: (context) => const Center(
  //       child: CircularProgressIndicator(
  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
  //       ),
  //     ),
  //   );

  //   try {
  //     // Sign in the user with email and password
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );

  //     // If the userCredential contains a valid user
  //     if (userCredential.user != null) {
  //       // If the widget is still in the tree, navigate to the home screen
  //       if (mounted) {
  //         dismisskeyboard(context);
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const Bottomnav(), // Navigate to home for user
  //           ),
  //         );
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     // Handle login errors
  //     String errorMessage = '';

  //     if (e.code == 'user-not-found') {
  //       errorMessage = 'No user found for that email.';
  //     } else if (e.code == 'wrong-password') {
  //       errorMessage = 'Wrong password provided.';
  //     } else {
  //       errorMessage = 'Error: ${e.message}';
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(errorMessage),
  //         backgroundColor: Colors.red,
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('An unknown error occurred: $e'),
  //         backgroundColor: Colors.red,
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //   } finally {
  //     // Always dismiss the loading dialog
  //     if (mounted) {
  //       Navigator.pop(context);
  //     }
  //   }
  // }

  /// Check if the user is an admin by comparing credentials with Firestore
  // Future<void> checkAdminLogin() async {
  //   try {
  //     // Fetch admin credentials from Firestore
  //     DocumentSnapshot adminData =
  //         await FirebaseFirestore.instance.collection('Admin').doc('admin').get();

  //     // Check if the email and password match the stored credentials
  //     String storedEmail = adminData.get('email');
  //     String storedPassword = adminData.get('password');

  //     if (emailController.text.trim() == storedEmail &&
  //         passwordController.text.trim() == storedPassword) {
  //       // Navigate to admin page
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const Addproduct(), // Navigate to Addproduct page for admin
  //         ),
  //       );
  //     } else {
  //       // If not admin, proceed to regular user login
  //       userLogin();
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to verify admin credentials: $e'),
  //         backgroundColor: Colors.red,
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            const Icon(Icons.shopping_bag, color: gry, size: 150),
            const SizedBox(height: 50),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email, color: gry),
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      validator: (value) {
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        if (value.isEmpty) return "Enter Email";
                        if (!emailValid) return "Please Enter Valid Email";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextFormField(
                      obscureText: isPasswordVisible,
                      controller: passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: isPasswordVisible
                              ? const Icon(Icons.visibility, color: gry)
                              : const Icon(Icons.visibility_off, color: gry),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: gry),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Enter Password";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(gry),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Show loading dialog
                        showDialog(
                          context: context,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          ),
                        );

                        try {
                          // Fetch admin credentials from Firestore
                          DocumentSnapshot adminData = await FirebaseFirestore
                              .instance
                              .collection('Admin')
                              .doc('admin')
                              .get();

                          String storedEmail = adminData.get('email');
                          String storedPassword = adminData.get('password');

                          // Check if the entered email and password match the admin credentials
                          if (emailController.text.trim() == storedEmail &&
                              passwordController.text.trim() ==
                                  storedPassword) {
                            // If admin credentials match, navigate to AddProduct page
                            Navigator.pop(
                                context); // Dismiss the loading indicator
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Addproduct()),
                            );
                          } else {
                            // Proceed with regular user login via Firebase Authentication
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            if (userCredential.user != null) {
                              // If login is successful, navigate to user home page (Bottomnav)
                              Navigator.pop(
                                  context); // Dismiss the loading indicator
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Bottomnav()),
                              );
                            }
                          }
                        } on FirebaseAuthException catch (e) {
                          // Dismiss the loading dialog and show error message
                          Navigator.pop(context);
                          String errorMessage = '';
                          if (e.code == 'user-not-found') {
                            errorMessage = 'No user found for that email.';
                          } else if (e.code == 'wrong-password') {
                            errorMessage = 'Wrong password provided.';
                          } else {
                            errorMessage = 'Error: ${e.message}';
                          }

                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } catch (e) {
                          // Dismiss the loading dialog and handle any other errors
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('An unknown error occurred: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Login', style: TextStyle(color: white)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(color: gry)),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()),
                          );
                        },
                        child: const Text(
                          'Signup',
                          style: TextStyle(
                              color: Color.fromARGB(183, 48, 65, 218),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
