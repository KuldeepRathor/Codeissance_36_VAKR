// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:commect/screens/Login/create_profile.dart';
import 'package:commect/screens/Profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../btm_navbar.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationIDReceived = "";

  bool otpCodeVisible = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
  }

  bool value = false;

  late Timer _timer;
  int _start = 90;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              );
            },
          ),
          centerTitle: true,
          title: Text(
            'Login',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continue with your Phone Number',
                          // textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff9852F6),
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: size.height * 0.1,
                    ),

                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text('Phone number'),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    TextFormField(
                      controller: phonecontroller,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        // fillColor: Colors.grey.shade300,
                        filled: true,
                        hintText: "Enter mobile number",
                        prefixIcon: Icon(Icons.mobile_friendly_rounded),
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: value,
                          onChanged: (bool? newvalue) {
                            setState(() {
                              value = newvalue!;
                            });
                          },
                        ),
                        Text(
                          'Accept terms and privacy policy',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: otpCodeVisible,
                      child: TextFormField(
                        controller: otpcontroller,
                        decoration: InputDecoration(
                          // fillColor: Colors.grey.shade300,
                          filled: true,
                          hintText: "Enter otp",
                          prefixIcon: Icon(Icons.password),
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: size.height * 0.05,
                    // ),
                    // Center(
                    //   child: InkWell(
                    //     onTap: () {
                    //       verifyNumber();
                    //       // Navigator.push(
                    //       //     context,
                    //       //     MaterialPageRoute(
                    //       //         builder: (context) => VerificationPage()));
                    //     },
                    //     child: Container(
                    //       width: size.width,
                    //       height: size.height * 0.06,
                    //       decoration: // ignore: prefer_const_constructors
                    //           BoxDecoration(
                    //         color: Color(0xff0065FF),
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           'Next',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Visibility(
                      visible: otpCodeVisible,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _start.toString(),
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (otpCodeVisible == false) {
                            print("verify Number function is called");
                            verifyNumber();
                          } else {
                            print("verify otp function is called");
                            verifyCode();
                          }
                          // verifyNumber();
                        },
                        child: Text(otpCodeVisible ? "Login" : "Verify"),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => BottomNavBar(),
                              ));
                        },
                        child: Text('homepage'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
      ),
    );
  }

  void verifyNumber() {
    auth.verifyPhoneNumber(
      phoneNumber: "+91${phonecontroller.text.trim()}",
      timeout: const Duration(seconds: 90),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) => {
              print("You are logged in successfully"),
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProfilePage(),
                  ))
            });
      },
      verificationFailed: (FirebaseAuthException exception) {
        print("The error is ${exception.message}");
      },
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          verificationIDReceived = verificationID;
          otpCodeVisible = true;
          startTimer();
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {},
    );
  }

  void verifyCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationIDReceived,
      smsCode: otpcontroller.text.trim(),
    );
    await auth.signInWithCredential(credential).then((value) {
      print('You are logged in successfully');
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => FinishSignUp(),
          ));
    });
  }
}
