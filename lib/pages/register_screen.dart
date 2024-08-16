import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.brown),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Join the Coffee Club',
                    style: TextStyle(fontSize: 32, color: Colors.brown, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Create your new account',
                    style: TextStyle(fontSize: 16, color: Colors.brown[300]),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.brown[50],
                      hintText: 'Full Name',
                      prefixIcon: Icon(Icons.person, color: Colors.brown),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.brown[50],
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.brown),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.brown[50],
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.brown),
                      suffixIcon: Icon(Icons.visibility_off, color: Colors.brown),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Text('Register', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(height: 20),
                  Center(child: Text('Or continue with')),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue), onPressed: () {}),
                      IconButton(icon: FaIcon(FontAwesomeIcons.google, color: Colors.red), onPressed: () {}),
                      IconButton(icon: FaIcon(FontAwesomeIcons.apple, color: Colors.black), onPressed: () {}),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      child: Text('Already have an account? Sign in', style: TextStyle(color: Colors.brown)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}