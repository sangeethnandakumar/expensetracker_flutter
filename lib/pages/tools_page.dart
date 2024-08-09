import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA2CEFF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/2409/2409313.png', // Replace with your actual app logo URL
                  height: 100,
                ),
                SizedBox(height: 32.0),

                // Welcome Text
                Text(
                  'Welcome to Expense Tracker',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Lets get started by logging in' ,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),

                // Sign in with Google button
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Google Sign-In
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Set the button's background color
                    foregroundColor: Color(0xFF1565C0), // Set the button's text color
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  icon: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/281/281764.png',
                    height: 24.0,
                  ),
                  label: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}