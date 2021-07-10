import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//global variable used to determine and open some specific chats
String chatto = "";

class Chatdatamanagement {
  //database referene variable

  final CollectionReference cref2 =
      FirebaseFirestore.instance.collection('chats');

  //to create a document with some chat information like email of user who sent
  //and who will receive

  createchatsection(String curruseremail, String touseremail) {
    String docid = curruseremail.substring(0, 5) + touseremail.substring(0, 5);
    Map<String, String> userdata = {
      "fromemail ": curruseremail.toString(),
      "toemail": touseremail.toString()
    };
    cref2.doc(docid).set(userdata);
  }

  //to check which document id exists (either doc id will start from senders email or vice versa)

  presentchecker(String from, String to) async {
    var doc = await cref2.doc(from.substring(0, 5) + to.substring(0, 5)).get();
    var doc2 = await cref2.doc(to.substring(0, 5) + from.substring(0, 5)).get();
    if (!(doc.exists || doc2.exists)) {
      createchatsection(from, to);
    }
  }

  final loginuser4 = FirebaseAuth.instance.currentUser!;
  int count = 0;

  //to create a unique document with main chat details like message , senders email and message counter
  //counter to orgranize the chat data when fetched from the firestore database

  createcollection(String str1, String str2, String message, int ma) {
    String clname = str1 + str2;
    count = ma + 1;
    cref2.doc(clname).collection("mainchats").add({
      "message": message,
      "from": loginuser4.email,
      "counter": count,
    });
    // count++;
  }

  //function to check the last count of the message sent between a pair of users
  //so that next message will be inserted with a counter incremented by +1

  fetchcheck(String str1, String str2, String message) async {
    List fetchc = [];
    var doc = await cref2.doc(str1 + str2).get();
    if (doc.exists) {
      await cref2
          .doc((str1 + str2).toString())
          .collection("mainchats")
          .get()
          .then((values) {
        values.docs.forEach((elements) {
          fetchc.add(elements.data());
        });
      });
      int c = 0, max = 0;
      for (int i = 0; i < fetchc.length; i++) {
        c = fetchc[i]['counter'];
        if (c >= max) {
          max = c;
        }
      }
      createcollection(str1, str2, message, max);
    } else {
      await cref2
          .doc((str2 + str1).toString())
          .collection("mainchats")
          .get()
          .then((values) {
        values.docs.forEach((elements) {
          fetchc.add(elements.data());
        });
      });
      int c = 0, max = 0;
      for (int i = 0; i < fetchc.length; i++) {
        c = fetchc[i]['counter'];
        if (c >= max) {
          max = c;
        }
      }

      //create function callback after checking the max/ last counter of the message sent/received
      //between a pair of users

      createcollection(str2, str1, message, max);
    }
  }

  deletechat(String chatemail) async {
    String docid1 =
        loginuser4.email!.substring(0, 5) + chatemail.substring(0, 5);
    String docid2 =
        chatemail.substring(0, 5) + loginuser4.email!.substring(0, 5);
    var doc = await cref2.doc(docid1).get();

    cref2.doc((doc.exists) ? docid1 : docid2).delete();
  }

  clearchat(String chatmail) async {
    String d1 = loginuser4.email!.substring(0, 5) + chatmail.substring(0, 5);
    String d2 = chatmail.substring(0, 5) + loginuser4.email!.substring(0, 5);
    var document = await cref2.doc(d1).get();
    cref2
        .doc((document.exists) ? d1 : d2)
        .collection("mainchats")
        .get()
        .then((deletevals) {
      deletevals.docs.forEach((deleteel) {
        deleteel.reference.delete();
      });
    });
  }
}
