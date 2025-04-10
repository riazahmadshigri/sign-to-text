import 'package:flutter/material.dart';
import 'package:pract/Pages/home.dart';
import 'package:pract/Pages/signup.dart'; // Navigates to Signup page
import 'package:pract/widget/widget_support.dart';

import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  Future<void> loginCheck(String email, String password) async {
    // Define connection settings
    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2', // e.g., 'localhost' or '192.168.1.1'
      port: 3306, // Default MySQL port
      userName: 'root1', // MySQL username
      password: 'root', // MySQL password
      databaseName: 'stt', // Database name
      secure: false
    );

    try {
      // Open the connection
      await conn.connect();

      // Execute the insert query
      // var result = await conn.execute(
      //   'INSERT INTO users (name, email) VALUES (:name, :email)',
      //   {
      //     'name': name,
      //     'email': email,
      //   },
      // );
      var result = await conn.execute(
        'SELECT * FROM users WHERE email = :email AND password = :password',
        {
          'email': email,
          'password': password,
        },
      );
      // Check if any rows are returned
      if (result.rows.isNotEmpty) {
        // Successful login
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        // Invalid email or password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );

      }


    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),

      );

    } finally {
      // Close the connection
      await conn.close();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
    child: SingleChildScrollView(
        child: Stack(
          children: [
            // Background gradient
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 54, 206, 244),
                    Color.fromARGB(255, 6, 140, 158),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3,
              ),
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: const Text(""),
            ),

            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 14,
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),

                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 1.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              "Login",
                              style: AppWidget.HeadlineTextfeildStyle(),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: AppWidget.semiBoldTextfeildStyle(),
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: AppWidget.semiBoldTextfeildStyle(),
                                prefixIcon: const Icon(Icons.lock_outline),
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Forgot Password?",
                                style: AppWidget.semiBoldTextfeildStyle(),
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                width: 200,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 33, 120, 219),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: GestureDetector(
                                  onTap: () {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
        loginCheck(email,password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
                                  },
                                child: const Center(

                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
    ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  // Sign-up redirect text
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                    child: Text(
                      "Don't have an Account? Sign up",
                      style: AppWidget.semiBoldTextfeildStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
