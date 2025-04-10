import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color constant
    const appColor = Color.fromARGB(255, 33, 120, 219);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        backgroundColor: appColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Title
            Center(
              child: const Text(
                "About Sign to Text Converter",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: appColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description Text
            const Text(
              "The Sign to Text Converter is an innovative application designed to enhance communication for individuals with speech and hearing impairments. "
              "It uses advanced machine learning techniques to recognize sign language gestures, convert them into text, and translate the text into multiple languages. "
              "The app also supports audio playback, enabling effective communication with ease.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Features Section
            const Text(
              "Features:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: appColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "- Real-time sign language to text conversion.\n"
              "- Text translation into multiple languages.\n"
              "- Audio playback for translated text.\n"
              "- User-friendly interface for effortless communication.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Purpose Section
            const Text(
              "Purpose:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: appColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This application aims to bridge the communication gap between individuals with hearing or speech disabilities and the wider community, fostering inclusivity and accessibility.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Acknowledgments Section
            const Text(
              "Acknowledgments:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: appColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This app leverages cutting-edge technologies like Google ML Kit and Flutter's robust framework. Special thanks to the open-source community for their invaluable contributions.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Contact Section
            const Text(
              "Contact Us:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: appColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "If you have any feedback or need assistance, feel free to reach out to us at support@signtextconverter.com.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
