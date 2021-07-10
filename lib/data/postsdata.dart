import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:teamsclone/meeting_pages/meet_popup.dart';

class PostsDataManagement {
  //firestore database collection referencce variable
  final CollectionReference cref =
      FirebaseFirestore.instance.collection("teams");

  //function to create a document with the necessary information required
  //has all the data to check whether a meeting is active or not
  //check whether a meeting is scheduled or not

  createpost(
      String postmsg,
      String fromemail,
      String hostemail,
      String teamname,
      int count,
      bool ismeetid,
      String date,
      int time,
      bool isscheduled) {
    cref.doc(getdocid(hostemail, teamname)).collection("posts").add({
      "from": fromemail,
      "postdata": postmsg,
      "count": count,
      "ismeetid": ismeetid,
      "chatvalid": ismeetid,
      "isscheduled": isscheduled,
      "date": date,
      "time": time,
    });

    if (ismeetid) updatemembersarray(hostemail, fromemail, teamname, postmsg);

    if (ismeetid && sendmail) sendemailnotif(postmsg, fromemail);
  }

  //function used to update the array of the members who joined a particular meeting
  updatemembersarray(
      String hostemail, String fromemail, String teamname, String meetid) {
    cref
        .doc(getdocid(hostemail, teamname))
        .collection("posts")
        .where("postdata", isEqualTo: meetid)
        .where("ismeetid", isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        cref
            .doc(getdocid(hostemail, teamname))
            .collection("posts")
            .doc(element.id)
            .update({
          "inmeet": FieldValue.arrayUnion([fromemail]),
        });
      });
    });
  }

  //function to get the index of last message communicated in the post tab of a particular team
  getlastcount(
      String docid,
      String postmsg,
      String fromemail,
      String hostemail,
      String teamname,
      bool ismeetid,
      String date,
      int time,
      bool isscheduled) async {
    int count = 0;
    await cref
        .doc(docid)
        .collection("posts")
        .orderBy("count")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        count = element['count'];
      });
    });

    createpost(postmsg, fromemail, hostemail, teamname, count + 1, ismeetid,
        date, time, isscheduled);
  }

  //function to return a unique doc id to be used for referencing at different locations
  String getdocid(String hostemail, String teamname) {
    return hostemail.substring(0, 2) + teamname;
  }

  //function to check if the same meeting exists which the user is trying to create
  //handling edge cases to avoid crash or data mismatch

  Future<bool> checkifmeetexists(String docid, String postmsg) async {
    bool check = false;

    await cref
        .doc(docid)
        .collection("posts")
        .where("postdata", isEqualTo: postmsg)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element['ismeetid']) {
          check = true;
        }
      });
    });

    return check;
  }

  //function to fetch and return some particular user's data
  Future<List> getuserdata() async {
    List _alluserdata = [];
    await FirebaseFirestore.instance.collection("userinfo").get().then((value) {
      value.docs.forEach((element) {
        _alluserdata.add(element.data());
      });
    });
    return _alluserdata;
  }

  //function to update the meet status to false signifying if the meeting still exists or is closed by the host
  updatemeetstatus(
      String meetid, String docid, String hostemail, String from) async {
    print("obcall");
    await cref
        .doc(docid)
        .collection("posts")
        .where("from", isEqualTo: from)
        .where("postdata", isEqualTo: meetid)
        .get()
        .then((vals) {
      vals.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("teams")
            .doc(docid)
            .collection("posts")
            .doc(element.id)
            .update({'ismeetid': false});
      });
    });
  }

  //function to send emails to the members of a particular team notifying about a particular meet
  void sendemailnotif(String meetid, String hostemail) async {
    String username = 'sd6778120@gmail.com';
    String password = 'X4PNS3TxSmG!TP-';

    print("coming here");

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.addAll(membersformailing)
      //  ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'MEETING ID . JOIN PLEASE 😀 ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<p>Meet ID : $meetid</p><p>Host : $hostemail</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
