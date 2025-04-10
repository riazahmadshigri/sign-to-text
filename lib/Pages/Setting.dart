import 'package:flutter/material.dart';
import 'package:pract/Pages/login.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 33, 120, 219),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme Color'),
              subtitle: const Text('Change the theme color of the app'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('Select your preferred language'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {

                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              subtitle: const Text('Enable or disable notifications'),
              trailing: Switch(
                value: true,
                onChanged: (bool value) {},
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Manage your privacy preferences'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {


                },
              ),
            ),
            const Divider(),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: const Color.fromARGB(255, 33, 120, 219),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
