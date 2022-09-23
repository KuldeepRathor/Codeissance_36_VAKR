import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/constants.dart';
import '../Login/login.dart';
import 'onboarding1.dart';
import 'onboarding2.dart';
import 'onboarding3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int idx) {
              setState(() {
                _currentPage = idx;
              });
            },
            controller: controller,
            children: [
              Onboarding1(),
              Onboarding2(),
              Onboarding3(),
            ],
          ),
          SizedBox(
            height: size.height * 0.1,
            // color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        // color: secondaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 16,
                        dotColor: Colors.black38,
                        activeDotColor: Color(0xff4700A2),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_currentPage == 2) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      } else {
                        controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff4700A2),
                        shape: BoxShape.circle,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.shade400,
                        //     offset: Offset(2, 6),
                        //     blurRadius: 12,
                        //   ),
                        //],
                      ),
                      child: Icon(
                        Icons.arrow_forward_outlined,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
