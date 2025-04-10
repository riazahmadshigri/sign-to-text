import 'package:flutter/material.dart';
import 'package:pract/Pages/About.dart';
import 'package:pract/Pages/Setting.dart';
import 'Signcamerascreen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    const appColor = Color.fromARGB(255, 33, 120, 219);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Flow'),
        backgroundColor: appColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Image.asset(
              "images/com 3.png",
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 2.2,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 30),
            const Text(
              'Simply click on the button below to get started!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to SignCameraScreen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const SignCameraScreen(),
                //   ),
                // );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text(''),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: const Color.fromARGB(255, 33, 120, 219),
                foregroundColor: Colors.white,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 33, 120, 219)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.settings, color: Color.fromARGB(255, 33, 120, 219)),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Color.fromARGB(255, 33, 120, 219)),
            label: 'About',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 1) {
            // Navigate to Settings Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Setting(),
              ),
            );
          } else if (index == 2) {
            // Navigate to About Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const About(),
              ),
            );
          }
        },
      ),
    );
  }
}
