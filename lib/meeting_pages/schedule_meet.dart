import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:teamsclone/data/inmeetchat.dart';
import 'package:teamsclone/data/postsdata.dart';

Widget meetschedulepopup(
    BuildContext context, String hostemail, String teamname) {
  List timings = new List.generate(24, (index) => index + 1);

  PostsDataManagement postobj = new PostsDataManagement();
  final meetidcontroller = TextEditingController();
  String timing = "";

  final loginuser = FirebaseAuth.instance.currentUser!;
  InmeetChatManagement meetchat = new InmeetChatManagement();

  validateandschedule() {
    if (timing.length != 0 && meetidcontroller.text.length != 0) {
      print(DateFormat("yyyy-MM-dd").format(DateTime.now()));
      // print(DateFormat("kk").format(DateTime.now()));
      var date = DateFormat("yyyy-MM-dd").format(DateTime.now());
      var time = int.parse(timing);
      postobj.getlastcount(
        postobj.getdocid(hostemail, teamname),
        meetidcontroller.text,
        loginuser.email!,
        hostemail,
        teamname,
        true,
        date,
        time,
        true,
      );
      meetchat.createchatsection(1, "Chat Here", meetidcontroller.text, true);
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Missing Scheduled");
    } else {
      Fluttertoast.showToast(msg: "Missing Details");
    }
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Center(
          child: Text(
            'Schedule Meeting',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Meeting ID..',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    controller: meetidcontroller,
                    onChanged: (String str) {},
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Select Time",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Spacer(),
                      DropdownButton(
                        // value: "",
                        isDense: true,
                        dropdownColor: Colors.grey[900],
                        hint: Text(
                          (timing.length == 0) ? "--" : timing,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (changedval) {
                          setState(() {
                            timing = changedval.toString();
                          });
                          print(timing);
                        },
                        items: timings.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: ButtonTheme(
                          height: 45,
                          minWidth: 100,
                          buttonColor: Colors.lightBlue,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30),
                            ),
                            onPressed: () {
                              validateandschedule();
                            },
                            child: Text(
                              "SCHEDULE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
