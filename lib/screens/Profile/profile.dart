import 'package:commect/screens/Community/create_community_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Text("Create Community"),
        onPressed: () {
          print("Tapped on create community");
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreateCommunityScreen(),
              ));
        },
      ),
    );
  }
}
