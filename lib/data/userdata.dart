import 'package:teamsclone/teams/posts.dart';

class UserDataManagement {
  //function to return specific user information varying according to a int check variable
  //searching by user email
  returninfo(String email, int x) {
    for (int i = 0; i < userdata.length; i++) {
      if (userdata[i]['email'] == email) {
        if (x == 0) return userdata[i]['profilepicurl'];
        if (x == 1) return userdata[i]['name'];
        if (x == 2) return userdata[i]['verification'];
      }
    }
    return "null user";
  }

  //same function searching by name of the user
  returninfobyname(String name, int x) {
    for (int i = 0; i < userdata.length; i++) {
      if (userdata[i]['name'] == name) {
        if (x == 0) return userdata[i]['profilepicurl'];
        if (x == 1) return userdata[i]['email'];
        if (x == 2) return userdata[i]['verification'];
      }
    }
    return "null user";
  }
}
