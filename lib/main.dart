import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterupdated/pages/homepage.dart';
import 'package:flutterupdated/pages/other/intro.dart';
import 'package:flutterupdated/pages/auth/login.dart';
import 'package:flutterupdated/pages/auth/signup.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(6, 148, 132, 1),
        hintColor: const Color.fromARGB(255, 94, 94, 94),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color.fromARGB(255, 52, 52, 52),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
          displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900),
          displayMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w800),
          displaySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
          titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
          titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300),
          titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w200),
          bodySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w100),
          labelLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
          labelSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color.fromRGBO(6, 148, 132, 1)),
      ),
      home: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.currentUser == null) {
            return IntroPage();
          } else {  
            return SplashScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => StorePage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/logo.png',
              height: 200,
              color: const Color.fromRGBO(6, 148, 132, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroForm(), // Replace with your intro page content
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoginForm(), // Replace with your login page content
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SignUpForm(), // Replace with your signup page content
    );
  }
}
