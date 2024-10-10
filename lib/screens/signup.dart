import 'package:ecommerce1/colors/color.dart';
import 'package:ecommerce1/helper/keyboardpop.dart';
import 'package:ecommerce1/screens/login.dart';
import 'package:ecommerce1/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formfield = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool isclicked = true;
  void userSignup() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        backgroundColor: bgcolor,
      )),
    );
    try {
      // Create a new user with email and password
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      String Id = randomAlphaNumeric(10);

      Map<String, dynamic> userinfomap = {
        "email": emailcontroller.text.trim(),
        "name": namecontroller.text.trim(),
        "Id": Id,
        "Image": 'https://avatar.iran.liara.run/public'
      };
      await Database().adduserdetails(userinfomap, Id);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', namecontroller.text.trim());
      emailcontroller.clear();
      namecontroller.clear();
      passwordcontroller.clear();

      if (mounted) {
        // Dismiss the keyboard
        dismisskeyboard(context);

        // Show success message in SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup successful! Redirecting to login page'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2), // Show for 2 seconds
          ),
        );
        Navigator.pop(context);
        // Wait for the SnackBar to disappear before navigating
        await Future.delayed(const Duration(seconds: 2));

        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // Handle different FirebaseAuthException error codes
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/password accounts are not enabled.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      // Show error message in SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Handle other errors that may occur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unknown error occurred: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            const Icon(
              Icons.person,
              size: 150,
              color: gry,
            ),
            Form(
              key: formfield,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextFormField(
                      // keyboardType: TextInputType.emailAddress,
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: gry,
                        ),
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      validator: (value) {
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        if (value.isEmpty) {
                          return "Enter Email";
                        } else if (!emailValid) {
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextFormField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: gry,
                        ),
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextFormField(
                      obscureText: isclicked,
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isclicked = !isclicked;
                              });
                            },
                            icon: isclicked
                                ? const Icon(
                                    Icons.visibility,
                                    color: gry,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: gry,
                                  )),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: gry,
                        ),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return " Enter Password";
                        } else if (passwordcontroller.text.length < 6) {
                          return "Password can not be less Than 6 Characters";
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(gry),
                    ),
                    onPressed: () {
                      // Handle login logic here
                      if (formfield.currentState!.validate()) {
                        userSignup();
                      }
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an acoount? ',
                        style: TextStyle(color: gry),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Color.fromARGB(183, 48, 65, 218),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
