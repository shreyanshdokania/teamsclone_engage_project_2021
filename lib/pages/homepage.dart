import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teamsclone/chat/searchscreen.dart';
import 'package:teamsclone/navigation_control/sidenavbar.dart';
import 'package:teamsclone/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamsclone/pages/teams_page.dart';
import 'package:teamsclone/teams/createteam.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  final loginuser = FirebaseAuth.instance.currentUser!;
  final CollectionReference cref =
      FirebaseFirestore.instance.collection('userinfo');

  List data = [];
  bool check = true;

  adddata() {
    cref.add({
      "name": loginuser.displayName,
      "email": loginuser.email,
      "verification": loginuser.emailVerified,
      "profilepicurl": loginuser.photoURL,
    });
  }

  fetchdata() async {
    data.clear();
    setState(() {
      check = true;
    });
    await cref.get().then((snapshot) {
      snapshot.docs.forEach((res) {
        setState(() {
          data.add(res.data());
        });
      });
    });
    for (int i = 0; i < data.length; i++) {
      if (data[i]['email'].toString() == loginuser.email.toString()) {
        check = false;
        Fluttertoast.showToast(
          msg: "Welcome!",
          backgroundColor: Colors.grey[800],
          gravity: ToastGravity.BOTTOM,
        );
      }
    }

    if (check) adddata();
  }

  void buttonpress() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            ),
          ),
          height: 70,
          child: _bottomnavigatiomenu(),
        );
      },
    );
  }

  Container _bottomnavigatiomenu() {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: Icon(
              Icons.add,
              size: 35,
              color: Colors.grey[500],
            ),
            title: Text(
              "Create Team",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17.5,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CreateTeam(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int index = 1;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Sidenavbar(),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Microsoft Teams Clone",
        ),
        actions: [
          IconButton(
            iconSize: 25,
            splashColor: Colors.transparent,
            onPressed: () {
              buttonpress();
            },
            icon: Icon(
              Icons.more_vert,
            ),
          ),
          IconButton(
            iconSize: 25,
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SearchChat()));
            },
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: _navigation(index),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: SizedBox(
          height: 75,
          child: Container(
            padding: EdgeInsets.only(bottom: 5),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: index,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.white54,
              selectedItemColor: Colors.white,
              onTap: ((int x) {
                setState(() {
                  index = x;
                  _navigation(index);
                });
              }),
              items: [
                new BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message_outlined,
                    size: 23,
                  ),
                  title: Text('Chat'),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(
                    Icons.people_alt_rounded,
                    size: 23,
                  ),
                  title: Text('Teams'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _navigation(int index) {
  switch (index) {
    case 0:
      return Chat();
    case 1:
      return Teams();
  }
  return Container();
}
