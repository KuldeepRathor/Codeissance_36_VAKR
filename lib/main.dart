import 'package:commect/btm_navbar.dart';
import 'package:commect/provider/selectedtags.dart';
import 'package:commect/screens/Login/create_profile.dart';
//import 'package:commect/screens/Login/create_profile.dart';
import 'package:commect/screens/Login/login.dart';
import 'package:commect/screens/Onboarding%20Screen/onboardingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => Tags(),
      ),
    ], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Commect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xff252525),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xff252525),
            selectedIconTheme: IconThemeData(
              color: Colors.blue,
            ),
          ),
        ),
        home: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(FirebaseAuth.instance.currentUser!.uid);
                return const BottomNavBar();
              } else {
                return const OnboardingScreen();
              }
            },
          ),
        ));
  }
}
