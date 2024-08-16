import 'package:coffe_app/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.brown[700]!, Colors.brown[500]!],
            ),
          ),
          child: SafeArea(
            child: _user != null ? _userInfo() : _loginContent(),
          ),
        ),
      ),
    );
  }

  Widget _loginContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(height: 30),
          Text(
            'Welcome Back',
            style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'Login to your account',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 50),
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Full Name',
              prefixIcon: Icon(Icons.person, color: Colors.brown),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock, color: Colors.brown),
              suffixIcon: Icon(Icons.visibility_off, color: Colors.brown),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Text('Remember Me', style: TextStyle(color: Colors.white)),
                ],
              ),
              TextButton(
                child: Text('Forgot Password?', style: TextStyle(color: Colors.white)),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 30),
          ElevatedButton(
            child: Text('Login', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[800],
              padding: EdgeInsets.symmetric(vertical: 15),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: () {},
          ),
          SizedBox(height: 20),
          Center(child: Text('Or', style: TextStyle(color: Colors.white))),
          SizedBox(height: 20),
          _googleSignInButton(),
          SizedBox(height: 20),
          Center(
            child: TextButton(
              child: Text("Don't have an account? Sign up", style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleSignInButton() {
    return ElevatedButton.icon(
      icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
      label: Text(
        'Sign in with Google',
        style: TextStyle(fontSize: 18, color: Colors.black87),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87, backgroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      onPressed: _handleGoogleSignIn,
    );
  }

  Widget _userInfo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_user!.photoURL!),
          ),
          SizedBox(height: 20),
          Text(
            _user!.displayName ?? "",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          Text(
            _user!.email!,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}