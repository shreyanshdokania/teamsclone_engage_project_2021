import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamsclone/data/inmeetchat.dart';
import 'package:teamsclone/data/userdata.dart';
import 'package:teamsclone/meeting_pages/meet_popup.dart';

class InmeetChat {
  InmeetChatManagement mchat = new InmeetChatManagement();

  final scrollcontrol = ScrollController();
  final user = FirebaseAuth.instance.currentUser!;

  TextEditingController inmeetchatcontroller = new TextEditingController();
  UserDataManagement userdata = new UserDataManagement();

  scrolltobottom() {
    if (scrollcontrol.hasClients)
      scrollcontrol.jumpTo(scrollcontrol.position.maxScrollExtent);
  }

  Widget _chattileinmeet(String nextdocid) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 7),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teams')
            .doc(pdocid)
            .collection("posts")
            .doc(nextdocid)
            .collection("inmeetchat")
            .orderBy("counter")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          WidgetsBinding.instance
              ?.addPostFrameCallback((_) => scrolltobottom());
          if (!snapshot.hasData) return Container();
          return new ListView(
            controller: scrollcontrol,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: document['from'] == user.email.toString()
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: document['from'] == user.email.toString()
                            ? Colors.lightBlue
                            : Colors.grey[500],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: document['from'] == user.email.toString()
                              ? Radius.circular(25)
                              : Radius.circular(0),
                          bottomRight: document['from'] == user.email.toString()
                              ? Radius.circular(0)
                              : Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (userdata.returninfo(document['from'], 1) ==
                                    user.displayName)
                                ? "You"
                                : userdata.returninfo(document['from'], 1),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            document['message'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
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

  bottomchat(context, String nextdocid, String meetid, bool behav) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey[900],
                body: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Chat",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _chattileinmeet(nextdocid),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 90,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 20,
                          color: Colors.grey[800],
                          child: ListTile(
                            title: TextField(
                              onTap: () {},
                              controller: inmeetchatcontroller,
                              onChanged: (String str) {},
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
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
                                mchat.getlastcount(
                                    meetid, inmeetchatcontroller.text, behav);
                                setState(() {
                                  inmeetchatcontroller.clear();
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
          },
        );
      },
    );
  }
}
