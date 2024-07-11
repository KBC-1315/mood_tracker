import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/intro/intro_1.json",
              repeat: false,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  "Track your mood",
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto",
                    shadows: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  speed: const Duration(
                    milliseconds: 80,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
