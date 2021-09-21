import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';


class ChatScreen extends StatefulWidget {
  static String id ='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth=FirebaseAuth.instance;
  late User loggedInUser;
  late String messageText;
  final _firestore=FirebaseFirestore.instance;
  final messageController=TextEditingController();

  void getCurrentUser () async
  {
    try
    {
      final user=  _auth.currentUser;
      if(user!=null)
        {
          loggedInUser=user;
        }
    }catch(e){print(e);}
  }


  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // print(loggedInUser.email);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async{
                // getMessages();
                await _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[800],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream:  _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
                builder: (context,snapshot) {
                  getCurrentUser();
                  bool iamLogged=false;
                  List<MessageBubble> messageBubbles=[];
                  if(!snapshot.hasData)
                  {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blueAccent,
                      ),
                    );
                  }
                  List<QueryDocumentSnapshot<Object?>> messages = snapshot.data!.docs;
                  for(var message in messages)
                      {
                        final data=message.data() as Map;
                        final messageText=data['text'];
                        final messageSender=data['sender'];
                        if(loggedInUser.email==messageSender)
                          {
                            iamLogged=true;
                          }
                        else
                          {
                            iamLogged=false;
                          }
                        final messageBubble=MessageBubble(text: messageText,sender: messageSender,logged: iamLogged,);
                        messageBubbles.add(messageBubble);
                      }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                      children: messageBubbles,
                    ),
                  );
                }),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            messageText=value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0)
                                  )
                              ),
                            backgroundColor: MaterialStateProperty.all(Colors.green)
                          ),
                          onPressed: () {
                            messageController.clear();
                            _firestore.collection('messages').add(
                              {
                                'text':messageText,
                                'sender':loggedInUser.email,
                                'timestamp':Timestamp.now()
                              }
                            );
                          },
                          child: Icon(Icons.send,color: Colors.white)
                          // Text(
                          //   'Send',
                          //   style: kSendButtonTextStyle,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {

  final BorderRadius loggedIn=BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.zero,bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20));
  final BorderRadius loggedOut=BorderRadius.only(topLeft: Radius.zero,topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20));
  final String text;
  final String sender;
  final bool logged;

  MessageBubble({required this.text,required this.sender,required this.logged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: (logged? CrossAxisAlignment.end: CrossAxisAlignment.start),
        children: [
          Text('$sender',
          style: TextStyle(color: Colors.white70),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Material(
              borderRadius: logged? loggedIn:loggedOut,
              elevation: 5,
              color:(logged? Colors.blueAccent:Colors.white),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                child: Text('$text',
                  style: TextStyle(
                      color: (logged?Colors.white:Colors.grey[800]),
                      fontSize: 18
                  )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
