import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamsclone/chat/chatscreen.dart';
import 'package:teamsclone/chat/delete_popup.dart';
import 'package:teamsclone/data/chatdataman.dart';
import 'package:connectivity/connectivity.dart';
import 'package:teamsclone/data/userdata.dart';
import 'package:teamsclone/usermodel/firebaseuser.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

List<String> filterdata = [];

class _ChatState extends State<Chat> {
  final CollectionReference cref3 =
      FirebaseFirestore.instance.collection('chats');

  final loginuser5 = FirebaseAuth.instance.currentUser!;

  StreamSubscription? sub;
  bool connection = true;

  UserDataManagement user = new UserDataManagement();
  DeleteChat deletecontext = new DeleteChat();

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen((res) {
      setState(() {
        connection = (res != ConnectivityResult.none);
      });
    });
    getchatlist();
  }

  List chatlist = [];
  bool loading = true;

  Future<Null> getchatlist() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      chatlist.clear();
      filterdata.clear();
    });
    await cref3.get().then((values) {
      values.docs.forEach((ele) {
        setState(() {
          chatlist.add(ele.data());
        });
      });
    });
    for (int i = 0; i < chatlist.length; i++) {
      if (chatlist[i]['fromemail '] == loginuser5.email) {
        setState(() {
          filterdata.add(chatlist[i]['toemail']);
        });
      }

      if (chatlist[i]['toemail'] == loginuser5.email) {
        setState(() {
          filterdata.add(chatlist[i]['fromemail '].toString());
        });
      }
    }
    setState(() {
      loading = false;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (!connection) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/no_internett.png'),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                color: Colors.lightBlue,
                backgroundColor: Colors.grey[900],
                onRefresh: getchatlist,
                child: ListView.builder(
                  itemCount: filterdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        color: Colors.grey[900],
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              getonpressemail = filterdata[index].toString();
                              chatto = filterdata[index].toString();
                            });
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ConversationPage(
                                  receivername:
                                      user.returninfo(filterdata[index], 1),
                                ),
                              ),
                            );
                          },
                          leading: FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            heroTag: filterdata[index],
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => UserInfoPage(
                                    useremail: filterdata[index],
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                user.returninfo(filterdata[index], 0),
                              ),
                            ),
                          ),
                          title: Text(
                            user.returninfo(filterdata[index], 1),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: IconButton(
                            disabledColor: Colors.white,
                            onPressed: () {
                              deletecontext.showbottombuilder(
                                  context, filterdata[index], "Delete");
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      );
    }
  }
}
