import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    // TODO: implement initState
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
      appBar: AppBar(
        title:const Text("Google Sign In"),
    ),
    body: _user != null ? _userInfo() : _googleSignInButton(),
    );
 }

 Widget _googleSignInButton(){
  return Center(child: SizedBox(
    height: 50,
    child: SignInButton(
    Buttons.google, 
    text:"Sign Up with Google",
    onPressed: _handleGoogleSignIn,

      )
    ),
  );
 }

 Widget _userInfo(){
   return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(_user!.photoURL!),
            fit: BoxFit.fill,
          ),
        ),
      ),
      Text(_user!.email!),
      Text(_user!.displayName ?? ""),
      MaterialButton(
        color: Colors.red,
        onPressed: () async {
          await _auth.signOut();
        },
        child: const Text("Sign Out"),
      ),
      ],
    )
   );
 }

 void _handleGoogleSignIn(){
  try{
    GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
    _auth.signInWithProvider(_googleAuthProvider);
  } catch(error){
    print(error);
  }
 }
}  