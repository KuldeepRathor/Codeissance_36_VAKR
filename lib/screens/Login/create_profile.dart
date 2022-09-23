import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FinishSignUp extends StatefulWidget {
  // final Uint8List profileImage;
  const FinishSignUp({
    Key? key,
  }) : super(key: key);

  @override
  State<FinishSignUp> createState() => _FinishSignUpState();
}

class _FinishSignUpState extends State<FinishSignUp>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool privacyPolicy = true;
  final _formKeyForFB = GlobalKey<FormState>();
  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  //TextEditing controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String privacy = 'accepted';
  bool sending = false;

  ScrollController _scrollController = ScrollController();
  bool hideTopBar = false;

  var profileImage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print("Scrolling down");
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        print("Scrolling down");

        setState(() {
          hideTopBar = false;
        });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        print("Scrolling upwards");
        setState(() {
          hideTopBar = true;
        });
      }
    });
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        controller: _scrollController,
        child: Form(
          key: _formKeyForFB,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 80,
                  child: IconButton(
                    onPressed: () {
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) => const BottomNavBar(),
                      //   ),
                      //   (route) => false,
                      // );
                      if (_formKeyForFB.currentState!.validate()) {
                        // TODO submit
                        if (bioController.text.isEmpty) {
                          bioController.text = "";
                        }
                        if (privacyPolicy == false) {}
                        setState(() {
                          sending = true;
                        });

                        // addUser(
                        //     usernameController.text.trim(),
                        //     bioController.text.trim(),
                        //     nameController.text.trim(),
                        //     privacy,
                        //     widget.profileImage,
                        //     context);
                      }
                      if (mounted) {
                        setState(() {
                          sending = false;
                        });
                      }
                    },
                    icon: Visibility(
                      visible: privacyPolicy,
                      child: Row(
                        children: const [
                          Text(
                            "Next",
                            // style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.navigate_next_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(visible: sending, child: LinearProgressIndicator()),
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: ProfileWithSpinners(
              //     animation: animation,
              //     turnsTween: turnsTween,
              //     profileImage: widget.profileImage,
              //   ),
              // ),
              Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: hideTopBar ? 0 : 200,
                    width: double.infinity,
                    color: Colors.red,
                    child: GestureDetector(
                        onTap: () {
                          print("Tapped");
                        },
                        child: Image.network(
                          "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg",
                          fit: BoxFit.fitWidth,
                        )),
                  ),
                  Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: hideTopBar ? 0 : 150,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                          child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 40,
                              backgroundImage: profileImage == null
                                  ? Image.network(
                                      "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg",
                                    ).image
                                  : Image.memory(profileImage!).image),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: usernameController,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            hintText: "Username",
                            // border: InputBorder.none,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),

                            prefixStyle: const TextStyle(fontSize: 18),
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Username is empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: nameController,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            hintText: "Name",
                            // border: InputBorder.none,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),

                            prefixStyle: const TextStyle(fontSize: 18),
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Name is empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: bioController,
                          maxLines: 4,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            hintText: "Bio",
                            // border: InputBorder.none,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),

                            prefixStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                              activeColor: Colors.blue,
                              value: privacyPolicy,
                              onChanged: (value) {
                                setState(() {
                                  privacyPolicy = value!;
                                });
                              }),
                          Row(
                            children: [
                              Text('I accept the, '),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     CupertinoPageRoute(
                                  //       builder: (context) => PolicyScreend(),
                                  //     ));
                                },
                                child: Text(
                                  'Privacy and Policy',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}