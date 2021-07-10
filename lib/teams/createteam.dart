import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teamsclone/data/teamsdataman.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({Key? key}) : super(key: key);

  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  final TextEditingController tname = new TextEditingController();

  TeamsDataManagement dob = new TeamsDataManagement();
  final CollectionReference crf =
      FirebaseFirestore.instance.collection("userinfo");

  String teamname = "";
  final loginuser = FirebaseAuth.instance.currentUser!;

  List _userdata = [];
  List _passuserdata = [];

  @override
  void initState() {
    super.initState();
    getusersdata();
  }

  bool loader = false;
  List<bool> checkbox = [];

  getusersdata() async {
    await crf.get().then((vals) {
      vals.docs.forEach((els) {
        if (els['email'] != loginuser.email) {
          setState(() {
            _userdata.add(els.data());
            checkbox.add(false);
          });
        }
      });
    });
    setState(() {
      loader = true;
    });
  }

  Widget _allusers() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 7),
      child: ListView.builder(
        itemCount: _userdata.length,
        itemBuilder: (BuildContext context, int index) {
          if (!loader) return Container();
          return Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white,
              ),
              child: CheckboxListTile(
                tileColor: Colors.grey[900],
                activeColor: Colors.lightBlue,
                title: Text(
                  _userdata[index]['name'],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                secondary: CircleAvatar(
                  backgroundImage:
                      NetworkImage(_userdata[index]['profilepicurl']),
                ),
                value: checkbox[index],
                onChanged: (bool? newval) {
                  setState(() {
                    checkbox[index] = newval!;
                    if (checkbox[index] &&
                        !_passuserdata.contains(_userdata[index])) {
                      _passuserdata.add(_userdata[index]);
                    } else if (!checkbox[index] &&
                        _passuserdata.contains(_userdata[index])) {
                      _passuserdata.remove(_userdata[index]);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        shadowColor: Colors.lightBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.navigate_before,
          ),
        ),
        title: Text(
          "Create",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 35, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(40, 20, 00, 10),
                      child: TextField(
                        controller: tname,
                        onChanged: (String str) {
                          setState(() {
                            teamname = str;
                          });
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Team name",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 30,
                    width: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.lightBlue,
                      ),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          if (tname.text.length != 0) {
                            dob.createteams(
                                teamname, loginuser.email!, _passuserdata);
                            setState(() {
                              tname.clear();
                            });
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please Enter a TeamName",
                            );
                          }
                        },
                        icon: Text(
                          "CREATE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                "Add Members",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: _allusers(),
            ),
          ],
        ),
      ),
    );
  }
}
