import 'package:commect/screens/ChatScreen/chat_screen.dart';
import 'package:commect/screens/Homepage/homepage.dart';
import 'package:commect/screens/Profile/profile.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Homepage(),
    Container(
      child: Center(
        child: Text("Events Page"),
      ),
    ),
    ChatScreen(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xff252525),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedItemColor: const Color(0xff6200ee),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.play_arrow_rounded,
              ),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message_rounded,
              ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
