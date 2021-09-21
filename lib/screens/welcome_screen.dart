import 'package:flash_chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../components.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id ='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller=AnimationController(
      upperBound: 1,
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation=ColorTween(begin: Colors.grey,end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {
      });
    });
  }




  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Flash Chat',
                          textStyle: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900,
                          ))
                    ]
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(text: 'Log In',color: Colors.lightBlueAccent,onpressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(text: 'Register',color: Colors.blueAccent,onpressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },)
          ],
        ),
      ),
    );
  }
}
