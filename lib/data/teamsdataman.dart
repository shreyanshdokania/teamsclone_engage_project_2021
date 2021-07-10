import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeamsDataManagement {
  //firestore database collection reference variable
  final CollectionReference cref3 =
      FirebaseFirestore.instance.collection("teams");

  //current loggedin user variable for reference
  final cuser = FirebaseAuth.instance.currentUser;

  //function to return unique doc id for searching some specific data in a specific collection
  String docname(String str1, String str2) {
    return str1.substring(0, 2) + str2;
  }

  //function to check if a particular generated doc id exists
  Future<bool> presentcheck(String docname, String hostemail) async {
    var doc = await cref3.doc(docname).get();
    return (doc.exists && doc['host'] == cuser?.email) ? false : true;
  }

  //function to create a team document with required details
  //flutter toast is a toast popup to display quick and crisp information to the end user
  createteams(String teamname, String hostemail, List members) async {
    if (await presentcheck(docname(hostemail, teamname), hostemail)) {
      cref3.doc(docname(hostemail, teamname)).set({
        "host": hostemail,
        "teamname": teamname,
      });

      for (int i = 0; i < members.length; i++) {
        cref3.doc(docname(hostemail, teamname)).update({
          "membersemail": FieldValue.arrayUnion([members[i]['email']]),
        });
      }
      Fluttertoast.showToast(
        msg: "Team Created..",
        backgroundColor: Colors.grey[800],
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Team Already Available..",
        backgroundColor: Colors.grey[800],
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  List _templist1 = [];
  List _templist2 = [];
  List _listofteams = [];

  //function to return list of all the teams
  //teams which the user is a part of or have hosted one
  Future<List> getteams() async {
    List _templist = [];

    await cref3.get().then((value) {
      value.docs.forEach((element) {
        if (element['host'] == cuser?.email) {
          _listofteams.add(element.data());
        } else {
          _templist.add(element.data());
        }
      });
    });
    for (int i = 0; i < _templist.length; i++) {
      for (int j = 0; j < _templist[i]['membersemail'].length; j++) {
        // print(_templist[i]['membersemail'][j]);
        if (_templist[i]['membersemail'][j] == cuser?.email) {
          _listofteams.add(_templist[i]);
        }
      }
    }

    return _listofteams;
  }

  //function to return separated list containing a user hosted team
  //and a list containing teams information the user is a part of
  List returnseparatedlist(bool check) {
    _templist1.clear();
    _templist2.clear();
    for (int i = 0; i < _listofteams.length; i++) {
      if (_listofteams[i]['host'] == cuser?.email) {
        _templist1.add(_listofteams[i]);
      } else {
        _templist2.add(_listofteams[i]);
      }
    }

    return check ? _templist1 : _templist2;
  }
}
