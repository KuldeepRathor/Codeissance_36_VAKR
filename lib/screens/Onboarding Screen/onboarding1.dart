import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/constants.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({Key? key}) : super(key: key);

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Column(
          //   children: [
          //
          //   ],
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.1),
                // O1Title(),
                SizedBox(height: size.height * 0.1),
                SizedBox(
                  width: size.width,
                  height: size.width * 0.8,
                  child: Lottie.asset(
                    'assets/lottie/handshake-blue.json',
                    fit: BoxFit.contain,
                  ),
                ),
                Center(
                  child: Text(
                    title1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Center(
                  child: Text(
                    body1,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
