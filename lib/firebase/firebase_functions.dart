import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commect/btm_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseStorage _storage = FirebaseStorage.instance;

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> uploadPic({profilePicture, reference}) async {
  //Get the file from the image picker and store it
  File image = profilePicture;

  //Create a reference to the location you want to upload to in firebase

  try {
    //Upload the file to firebase
    await reference.putFile(profilePicture);

    // Waits till the file is uploaded then stores the download url
    String location = await reference.getDownloadURL();

    //returns the download url
    return location;
  } catch (e) {
    print("The Error is = ${e.toString()}");
    return "File Not Uploaded";
  }
}

void addUser({
  File? profileImage,
  File? bannerImage,
  String? username,
  String? name,
  String? bio,
  BuildContext? context,
}) async {
  final reference =
      _storage.ref().child("ProfilePics/" + _auth.currentUser!.uid);
  final referenceBanner =
      _storage.ref().child("Banners/" + _auth.currentUser!.uid);
  final dp =
      await uploadPic(profilePicture: profileImage, reference: reference);
  final banner =
      await uploadPic(profilePicture: bannerImage, reference: referenceBanner);

  final data = {
    "uid": _auth.currentUser!.uid,
    "username": username,
    "name": name,
    "bio": bio,
    "following": [],
    "tags": [],
    "createdComm": false,
    "dp": dp,
    "banner": banner
  };

  try {
    final location = _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set(data)
        .onError((error, stackTrace) {
      SnackBar snackBar = const SnackBar(
        content: Text("Something went Wrong"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }).whenComplete(() {
      Navigator.pushAndRemoveUntil(
        context!,
        CupertinoPageRoute(
          builder: (context) => BottomNavBar(),
        ),
        (route) => false,
      );
    });
  } catch (e) {
    SnackBar snackBar = const SnackBar(
      content: Text("Something went Wrong"),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    print("Error adding user $e");
  }
}
