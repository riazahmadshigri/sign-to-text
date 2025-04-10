import 'package:flutter/material.dart';
import 'package:pract/Pages/signup.dart';
import 'package:pract/widget/content_model.dart';
import 'package:pract/widget/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20.0),
                      Image.asset(
                        contents[index].image,
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 0.5,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        contents[index].title,
                        textAlign: TextAlign.center,
                        style: AppWidget.semiBoldTextfeildStyle(),
                      ),
                      const SizedBox(height: 15.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            contents[index].description,
                            textAlign: TextAlign.center,
                            style: AppWidget.LightTextfeildStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDot(index),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Signup()),
                );
              } else {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 33, 120, 219)),
              height: 60.0,
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                currentIndex == contents.length - 1 ? "Start" : "Next",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
    );
  }
}
