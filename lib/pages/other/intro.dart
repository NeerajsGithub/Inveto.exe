import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterupdated/main.dart';

class IntroForm extends StatelessWidget {
  const IntroForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton.icon(
              onPressed: () {
                SystemNavigator.pop(); // Exit the app properly
              },
              label: Text(
                "Exit",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 94, 94, 94),
                ),
              ),
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Color.fromRGBO(6, 148, 132, 1),
              ),
            ),
          ),
        ],
      ),
      body: Center( // Centers everything vertically & horizontally
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Centers vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Centers content
            children: [
              Image.asset(
                'lib/images/logo.png',
                height: 100, // Fixed height for consistency
                color: Color.fromRGBO(6, 148, 132, 1),
              ),
              SizedBox(height: 30),
              Text(
                'Welcome to \nInveto by Meteo',
                textAlign: TextAlign.center, // Centered text
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  color: Color.fromARGB(255, 75, 73, 73),
                ),
              ),
              SizedBox(height: 40),
              _buildButton(
                icon: Icons.person_outline,
                label: 'Open a new account',
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => SignUpPage(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
              _buildButton(
                icon: Icons.exit_to_app,
                label: 'Login to Inveto',
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginPage(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 40),
              Text(
                'Inveto is a game-changing inventory management app designed to streamline stock processes,\n optimize logistics, and boost efficiency for businesses. With real-time tracking, insightful analytics.\nService Number: +1 (555) 123-4567',
                textAlign: TextAlign.center, // Centered text
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 104, 104, 104),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(40, 189, 189, 189),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 100, 100, 100),
          ),
        ),
        icon: Icon(icon, color: Color.fromRGBO(6, 148, 132, 1)),
      ),
    );
  }
}
