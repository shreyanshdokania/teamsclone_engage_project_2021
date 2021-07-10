import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamsclone/teams/posts.dart';

class Searchdatabase {
  //firestore database collection reference variable
  final CollectionReference cref =
      FirebaseFirestore.instance.collection('userinfo');

  //function to search for user by the reference string entered
  //sends and shows response/result in realtime

  searchuser(String uname) {
    List searchresult = [];

    for (int i = 0; i < userdata.length; i++) {
      if (userdata[i]['name']
              .toString()
              .substring(0, uname.length)
              .toLowerCase() ==
          uname.toLowerCase()) {
        searchresult.add(userdata[i]);
      }
    }

    return searchresult;
  }
}
