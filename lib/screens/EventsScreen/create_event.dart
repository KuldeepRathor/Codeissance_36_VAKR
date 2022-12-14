import 'dart:io';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commect/firebase/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../btm_navbar.dart';
import '../../utils/constants.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  DateTime dateTime = DateTime.now();

  int isOnline = 1;
  int isInPerson = 0;
  File? _image;
  TextEditingController descController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLinkController = TextEditingController();
  TextEditingController venueController = TextEditingController();

  Future<void> sendLinkToDatabase({
    File? image,
    String? desc,
    String? eventName,
    String? venue,
    String? eventLink,
    bool? isOnline,
    var date,
    var time,
  }) async {
    final uid = Uuid().v1();
    final reference = FirebaseStorage.instance.ref().child("Events/" + uid);
    final banner = await uploadPic(profilePicture: image, reference: reference);

    final data = {
      "image": banner,
      "timestamp": FieldValue.serverTimestamp(),
      "date": date,
      "desc": desc,
      "time": time,
      "isOnline": isOnline,
      "eventLink": eventLink,
      "eventName": eventName,
      "venue": venue,
      "eventId": uid,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "joined": [],
      "likes": [],
    };

    final location = FirebaseFirestore.instance.collection("Events").doc(uid);
    try {
      await location.set(data).onError((error, stackTrace) {
        SnackBar snackBar = const SnackBar(
          content: Text("Something went Wrong"),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
        (route) => false,
      );
    } catch (e) {
      SnackBar snackBar = const SnackBar(
        content: Text("Something went Wrong"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("Error Uploading Event $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString().padLeft(4, '0');
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Create Event",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            // InkWell(
            //   onTap: () async {
            //     await DateTimeApi().pickTime(context);
            //   },
            //   child: Icon(Icons.calendar_month),
            // )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          posterCard(),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    eventType(),
                    SizedBox(height: 10),
                    if (isOnline == 1) ...[
                      MyEvent(
                        textEditingController: eventLinkController,
                        title: "Event Link*",
                        hint: "Paste the external link for online meet",
                      ),
                      SizedBox(height: 15)
                    ],
                    MyEvent(
                      textEditingController: eventNameController,
                      title: "Event name*",
                      hint: "Enter the name of event*",
                    ),
                    SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date and Time*",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          width: getSize(context).width,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    DateTime? tp = await DateTimeApi().pickDate(
                                      context,
                                    );
                                    if (tp == null) return;
                                    final newDateTime = DateTime(
                                      tp.year,
                                      tp.month,
                                      tp.day,
                                      dateTime.hour,
                                      dateTime.minute,
                                    );

                                    setState(() {
                                      dateTime = newDateTime;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month),
                                      SizedBox(width: 10),
                                      Text("$day/$month/$year"),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                InkWell(
                                  onTap: () async {
                                    TimeOfDay? tp =
                                        await DateTimeApi().pickTime(context);

                                    if (tp == null) return;
                                    final newDateTime = DateTime(
                                      dateTime.year,
                                      dateTime.month,
                                      dateTime.day,
                                      tp.hour,
                                      tp.minute,
                                    );

                                    setState(() {
                                      dateTime = newDateTime;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.watch_later_outlined),
                                      SizedBox(width: 10),
                                      Text("$hours:$minutes"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    if (isInPerson == 2) ...[
                      MyEvent(
                        textEditingController: venueController,
                        title: "Venue*",
                        hint: "Enter the location for meet*",
                      ),
                      SizedBox(height: 15)
                    ],
                    MyEvent(
                      textEditingController: descController,
                      title: "Description",
                      hint: "Enter the description",
                      maxLine: 6,
                    ),
                    SizedBox(height: 35),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (eventNameController.text == "" ||
                              _image == null) {
                            SnackBar snackBar = const SnackBar(
                              content: Text("Please fill data"),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          if (isInPerson == 2) {
                            print("the person meets in person");
                            sendLinkToDatabase(
                                date: dateTime,
                                desc: descController.text.trim(),
                                eventLink: null,
                                eventName: eventNameController.text.trim(),
                                image: _image,
                                isOnline: false,
                                time: hours + minutes,
                                venue: venueController.text.trim());
                          }
                          if (isOnline == 1) {
                            print("the meet is online");
                            sendLinkToDatabase(
                                date: dateTime,
                                desc: descController.text.trim(),
                                eventLink: eventLinkController.text.trim(),
                                eventName: eventNameController.text.trim(),
                                image: _image,
                                isOnline: true,
                                time: hours + minutes,
                                venue: venueController.text.trim());
                          }
                          // sendLinkToDatabase(
                          //   desc: descController.text.trim(),
                          // );
                        },
                        child: MyButton1(
                          text: "Done",
                          color: Colors.purple,
                          borderRadius: 10,
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose an option to upload photo',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: InkWell(
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: InkWell(
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick image
  Future getImage(ImageSource imageSource) async {
    try {
      final image =
          await ImagePicker().pickImage(source: imageSource, imageQuality: 50);

      if (image == null) return;

      final imgTemp = File(image.path);

      setState(() {
        _image = imgTemp;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image $e');
    }
  }

  // Future<bool> _handlePermission(Permission permission) async {
  //   if (await permission.isGranted) {
  //     return true;
  //   } else {
  //     var result = await permission.request();
  //     if (result == PermissionStatus.granted) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  // }

  Widget posterCard() {
    return Stack(
      children: [
        _image == null
            ? Container(
                height: getSize(context).height * 0.3,
                width: getSize(context).width,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/event.jpg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
              )
            : SizedBox(
                height: getSize(context).height * 0.3,
                width: getSize(context).width,
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                ),
              ),
        Positioned(
          right: 10,
          top: 10,
          child: InkWell(
            onTap: () async {
              buildShowModalBottomSheet(context);
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget eventType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Event Type",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Radio(
              value: 1,
              activeColor: Colors.purple,
              onChanged: (value) {
                setState(() {
                  if (value == 1) {
                    isOnline = 1;
                    isInPerson = 0;
                  }
                });
              },
              groupValue: isOnline,
            ),
            Text(
              'Online',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Radio(
              value: 2,
              activeColor: Colors.purple,
              groupValue: isInPerson,
              onChanged: (value) {
                setState(() {
                  if (value == 2) {
                    isInPerson = 2;
                    isOnline = 0;
                  }
                });
              },
            ),
            Text(
              'In person',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}

class MyEvent extends StatelessWidget {
  const MyEvent({
    Key? key,
    required this.title,
    required this.hint,
    this.textEditingController,
    this.maxLine = 1,
    this.textInputType = TextInputType.name,
    this.onTap,
  }) : super(key: key);

  final String title, hint;
  final int maxLine;
  final TextEditingController? textEditingController;
  final TextInputType textInputType;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            onTap!();
          },
          child: TextFormField(
            maxLines: maxLine,
            style: TextStyle(fontSize: 16),
            decoration: kTextFormFieldAuthDec.copyWith(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(2),
                ),
              ),
              hintText: hint,
              errorStyle: TextStyle(color: Colors.red),
              contentPadding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            ),
            keyboardType: textInputType,
            textInputAction: TextInputAction.newline,
            cursorColor: Colors.white,
            controller: textEditingController,
            onSaved: (value) {},
            // validator: myValidator(requiredField: 'This'),
          ),
        ),
      ],
    );
  }
}

class MyButton1 extends StatelessWidget {
  const MyButton1({
    Key? key,
    required this.text,
    this.borderRadius = 27,
    this.color = kGreenShadeColor,
  }) : super(key: key);
  final String text;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      height: 54,
      width: size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DateTimeApi {
  DateTime dateTime = DateTime.now();

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final DateTime? newDate = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple,
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.black,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDate: initialDate,
      firstDate: dateTime,
      lastDate: DateTime(2100, 12, 31),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    return showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple,
              surfaceTint: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
              onBackground: Colors.grey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.black,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
      initialTime: TimeOfDay(
        hour: dateTime.hour,
        minute: dateTime.minute,
      ),
    );
  }
}
