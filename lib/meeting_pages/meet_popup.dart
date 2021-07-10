import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teamsclone/data/inmeetchat.dart';
import 'package:teamsclone/data/postsdata.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'callscreen.dart';

String pdocid = "";
String pfrom = "";
String phostemail = "";
String pteamname = "";
List membersformailing = [];
bool sendmail = false;

Widget popup(BuildContext context) {
  final _channelController = TextEditingController(text: "");

  PostsDataManagement postobj = new PostsDataManagement();
  InmeetChatManagement meetc = new InmeetChatManagement();

  bool _validateError = false;

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }

  var date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var time = int.parse(DateFormat("kk").format(DateTime.now()));

  Future<void> onJoin() async {
    _channelController.text.isEmpty
        ? _validateError = true
        : _validateError = false;

    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      bool ch =
          await postobj.checkifmeetexists(pdocid, _channelController.text);
      if (!ch) {
        postobj.getlastcount(pdocid, _channelController.text, pfrom, phostemail,
            pteamname, true, date, time, false);
        meetc.createchatsection(1, "Chat Here", _channelController.text, true);
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CallConversationPage(
              meetid: _channelController.text,
            ),
          ),
        );
        _channelController.clear();
      } else {
        Fluttertoast.showToast(
          msg: "Meeting ID already exists!",
        );
      }
    }
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Center(
          child: Text(
            'Meeting ID',
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
                    controller: _channelController,
                    onChanged: (String str) {},
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Send email to members",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlutterSwitch(
                        activeColor: Colors.lightBlue,
                        toggleColor: Colors.white,
                        inactiveColor: Colors.grey,
                        width: 50,
                        height: 25,
                        toggleSize: 20,
                        value: sendmail,
                        borderRadius: 20,
                        padding: 5,
                        onToggle: (val) {
                          setState(() {
                            sendmail = !sendmail;
                          });
                        },
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
                            onPressed: onJoin,
                            child: Text(
                              "CREATE AND JOIN",
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
