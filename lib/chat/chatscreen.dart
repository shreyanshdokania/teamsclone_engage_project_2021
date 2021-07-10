import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamsclone/data/chatdataman.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:teamsclone/data/userdata.dart';
import 'package:teamsclone/usermodel/firebaseuser.dart';

import 'delete_popup.dart';

class ConversationPage extends StatefulWidget {
  final String? receivername;
  const ConversationPage({Key? key, this.receivername}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

String getonpressemail = "";

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController chattext = new TextEditingController();

  final scontrol = ScrollController();
  bool scroller = false;
  bool loaded = false;

  Chatdatamanagement obj = new Chatdatamanagement();
  final loginuser3 = FirebaseAuth.instance.currentUser!;
  final CollectionReference cref4 =
      FirebaseFirestore.instance.collection('chats');

  UserDataManagement user = new UserDataManagement();
  DeleteChat clearchat = new DeleteChat();

  @override
  void initState() {
    super.initState();
    checks(getonpressemail);
    speech = stt.SpeechToText();
  }

  stt.SpeechToText? speech;

  bool miclisten = false;
  double confidencelevel = 1.0;

  String? text = "";

  startlistening() async {
    if (!miclisten) {
      setState(() {
        chattext.text = "";
      });
      bool available = await speech!.initialize();
      if (available) {
        setState(() {
          miclisten = true;
          speech!.listen(onResult: (val) {
            chattext.text = val.recognizedWords;
            print(val.recognizedWords);
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidencelevel = val.confidence;
            }
          });
        });
      }
    } else {
      setState(() {
        miclisten = false;
        speech!.stop();
      });
    }
  }

  String collectionname = "";

  checks(String tomail) async {
    String fromail = loginuser3.email.toString();
    var docid1 =
        await cref4.doc(fromail.substring(0, 5) + tomail.substring(0, 5)).get();
    if (docid1.exists) {
      setState(() {
        collectionname = fromail.substring(0, 5) + tomail.substring(0, 5);
      });
    } else {
      setState(() {
        collectionname = tomail.substring(0, 5) + fromail.substring(0, 5);
      });
    }
    setState(() {
      loaded = true;
    });
  }

  scrolltobottom() {
    if (scontrol.hasClients) scontrol.jumpTo(scontrol.position.maxScrollExtent);
  }

  Widget _chattile() {
    if (!loaded) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 7),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(collectionname)
              .collection("mainchats")
              .orderBy("counter")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            WidgetsBinding.instance
                ?.addPostFrameCallback((_) => scrolltobottom());
            if (!snapshot.hasData) return Container();
            return new ListView(
              controller: scontrol,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment:
                        document['from'] == loginuser3.email.toString()
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: document['from'] == loginuser3.email.toString()
                              ? Colors.lightBlue
                              : Colors.grey[500],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft:
                                document['from'] == loginuser3.email.toString()
                                    ? Radius.circular(25)
                                    : Radius.circular(0),
                            bottomRight:
                                document['from'] == loginuser3.email.toString()
                                    ? Radius.circular(0)
                                    : Radius.circular(25),
                          ),
                        ),
                        child: Text(
                          document['message'],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Color.fromRGBO(40, 41, 41, 1),
        shadowColor: Colors.lightBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.navigate_before,
          ),
        ),
        title: Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => UserInfoPage(
                      useremail: user.returninfobyname(widget.receivername!, 1),
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  user.returninfobyname(widget.receivername!, 0),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.receivername!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              clearchat.showbottombuilder(context,
                  user.returninfobyname(widget.receivername!, 1), "Clear");
            },
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: _chattile(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 90,
                padding: EdgeInsets.fromLTRB(0, 6, 10, 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 20,
                  color: Colors.grey[800],
                  child: ListTile(
                    leading: AvatarGlow(
                      animate: miclisten,
                      glowColor: Colors.lightBlue,
                      endRadius: 20,
                      duration: Duration(milliseconds: 1000),
                      repeatPauseDuration: Duration(milliseconds: 100),
                      repeat: true,
                      child: IconButton(
                        onPressed: () {
                          startlistening();
                        },
                        icon: Icon(
                          miclisten ? Icons.mic : Icons.mic_off_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: TextField(
                      onTap: () {},
                      controller: chattext,
                      onChanged: (String str) {},
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Type your message....",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (chattext.text.length != 0) {
                          String lu = loginuser3.email.toString();
                          obj.fetchcheck(lu.substring(0, 5),
                              chatto.substring(0, 5), chattext.text);
                        }

                        setState(() {
                          chattext.clear();
                        });
                      },
                      icon: Icon(
                        Icons.send_outlined,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
