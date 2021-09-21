import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components.dart';
import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id='login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late String email;
  late String password;
  bool showSpinner=false;

  final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                  ),
                  onChanged: (value) {
                    email=value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                  ),
                  onChanged: (value) { 
                    password=value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password')
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(text: 'Log In',color: Colors.lightBlueAccent,onpressed: () async
                {
                  try
                      {
                        setState(() {
                          showSpinner=true;
                        });
                        final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if(user!=null)
                          {
                            print('Logged In');
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        setState(() {
                          showSpinner=false;
                        });
                      }catch(e){print(e);}
                },),
            ],
          ),
        ),
      ),
    );
  }
}
