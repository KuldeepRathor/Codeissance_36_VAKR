import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commect/btm_navbar.dart';
import 'package:commect/provider/selectedtags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
  final tagsuser = context!.read<Tags>().selectedTagsUser.map((e) {
    if (e != "nothing") {
      return e;
    }
  }).toList();

  final data = {
    "uid": _auth.currentUser!.uid,
    "username": username,
    "name": name,
    "bio": bio,
    "following": [],
    "tags": tagsuser,
    "createdComm": false,
    "dp": dp,
    "banner": banner,
    "cid": null,
    "timestamp": FieldValue.serverTimestamp(),
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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).whenComplete(() {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
        (route) => false,
      );
    });
  } catch (e) {
    SnackBar snackBar = const SnackBar(
      content: Text("Something went Wrong"),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print("Error adding user $e");
  }
}

void createCommunity({
  File? profileImage,
  File? bannerImage,
  String? username,
  String? name,
  String? bio,
  BuildContext? context,
}) async {
  var uuid = Uuid().v1();
  final reference = _storage.ref().child("ProfilePics/" + uuid);
  final referenceBanner = _storage.ref().child("Banners/" + uuid);
  final dp =
      await uploadPic(profilePicture: profileImage, reference: reference);
  final banner =
      await uploadPic(profilePicture: bannerImage, reference: referenceBanner);

  final tags = context!.read<Tags>().selectedTags.map((e) {
    if (e != "nothing") {
      return e;
    }
  }).toList();
  final data = {
    "uid": _auth.currentUser!.uid,
    "cid": uuid,
    "username": username,
    "name": name,
    "bio": bio,
    "following": [],
    "tags": tags,
    "createdComm": false,
    "dp": dp,
    "banner": banner,
    "timestamp": FieldValue.serverTimestamp(),
  };

  try {
    final userLocation =
        _firestore.collection("users").doc(_auth.currentUser!.uid);
    final commLocation =
        _firestore.collection("Community").doc(_auth.currentUser!.uid);
    _firestore.runTransaction((transaction) async {
      await transaction.set(commLocation, data);
      final updates = {
        "cid": uuid,
        "createdComm": true,
      };
      await transaction.update(userLocation, updates);
    }).onError((error, stackTrace) {
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
    // final location = _firestore
    //     .collection("users")
    //     .doc(_auth.currentUser!.uid)
    //     .set(data)
    //     .onError((error, stackTrace) {
    //   SnackBar snackBar = const SnackBar(
    //     content: Text("Something went Wrong"),
    //     backgroundColor: Colors.red,
    //   );
    //   ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    // }).whenComplete(() {
    //   Navigator.pushAndRemoveUntil(
    //     context!,
    //     CupertinoPageRoute(
    //       builder: (context) => const BottomNavBar(),
    //     ),
    //     (route) => false,
    //   );
    // });
  } catch (e) {
    SnackBar snackBar = const SnackBar(
      content: Text("Something went Wrong"),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print("Error adding user $e");
  }
}
