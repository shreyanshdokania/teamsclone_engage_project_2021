import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamsclone/meeting_pages/meet_popup.dart';

class InmeetChatManagement {
  //database collection reference variable
  final CollectionReference cref =
      FirebaseFirestore.instance.collection("teams");

  //current logged in user reference variable to verifications and checks
  final user = FirebaseAuth.instance.currentUser!;

  //function to return the uniqure document id that is to be used for referencing
  String getdocid(String host, String teamname) {
    return host.substring(0, 2) + teamname;
  }

  //function to push inmeet chat data in a particular collection with a unique document reference
  createchatsection(int count, String message, String meetid, bool behav) {
    // print(pdocid);
    cref
        .doc(pdocid)
        .collection("posts")
        .where("ismeetid", isEqualTo: behav)
        .where("postdata", isEqualTo: meetid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print("point");
        cref
            .doc(pdocid)
            .collection("posts")
            .doc(element.id)
            .collection("inmeetchat")
            .add({
          "counter": count,
          "from": user.email,
          "message": message,
        });
      });
    });
  }

  //function used to fetch auto generated firebase doc ids within a collection
  //these doc ids are complex strings

  Future<String> returndocid(String meetid) async {
    String ans = "";
    await cref
        .doc(pdocid)
        .collection("posts")
        .where("ismeetid", isEqualTo: true)
        .where("postdata", isEqualTo: meetid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // print(element.id);
        ans = element.id;
      });
    });
    return ans;
  }

  //function to get the count number / index of the last message shared in the group chat
  //indexing done with 1

  getlastcount(String meetid, String message, bool behav) async {
    int count = 0;
    bool check = false;

    // print(behav);
    // print(meetid);
    print("hre");

    await cref
        .doc(pdocid)
        .collection("posts")
        .where("ismeetid", isEqualTo: behav)
        .where("postdata", isEqualTo: meetid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        cref
            .doc(pdocid)
            .collection("posts")
            .doc(element.id)
            .collection("inmeetchat")
            .orderBy("counter", descending: true)
            .get()
            .then((vals) {
          vals.docs.forEach((ele) {
            count = ele['counter'];
            if (!check) createchatsection(count + 1, message, meetid, behav);
            check = true;
          });
        });
      });
    });
  }
}
