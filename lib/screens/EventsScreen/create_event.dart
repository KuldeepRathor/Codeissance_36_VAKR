// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString().padLeft(4, '0');
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text(
      //         "Create Event",
      //         style: TextStyle(
      //           fontSize: 26,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //       // InkWell(
      //       //   onTap: () async {
      //       //     await DateTimeApi().pickTime(context);
      //       //   },
      //       //   child: Icon(Icons.calendar_montmh),
      //       // )
      //     ],
      //   ),
      // ),
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
                        title: "Event Link*",
                        hint: "Paste the external link for online meet*",
                      ),
                      SizedBox(height: 15)
                    ],
                    MyEvent(
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
                                  onTap: () {

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
                        title: "Venue*",
                        hint: "Enter the location for meet*",
                      ),
                      SizedBox(height: 15)
                    ],
                    MyEvent(
                      title: "Description",
                      hint: "Enter the description",
                      maxLine: 6,
                    ),
                    SizedBox(height: 35),
                    Center(
                      child: MyButton1(
                        text: "Done",
                        color: Colors.black,

                        borderRadius: 10,
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
                  color: Colors.black,
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
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
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
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/event.jpg"),
              fit: BoxFit.cover,
            ),
          ),
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
              activeColor: Colors.black,
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
              activeColor: Colors.black,
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
            style: TextStyle(color: Colors.black, fontSize: 16),
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
            cursorColor: Colors.black,
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