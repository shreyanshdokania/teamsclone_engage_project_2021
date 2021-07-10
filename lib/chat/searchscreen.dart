import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teamsclone/chat/chatscreen.dart';
import 'package:teamsclone/data/chatdataman.dart';
import 'package:teamsclone/data/searchdata.dart';
import 'package:teamsclone/usermodel/firebaseuser.dart';

class SearchChat extends StatefulWidget {
  const SearchChat({Key? key}) : super(key: key);

  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  final TextEditingController stext = new TextEditingController();

  final loginuser2 = FirebaseAuth.instance.currentUser!;
  bool searchcheck = false;

  Searchdatabase sear = new Searchdatabase();
  Chatdatamanagement chatman = new Chatdatamanagement();

  List searchdata = [];
  getsearchdata(String st) {
    searchdata = sear.searchuser(st);
  }

  Widget _searchresult() {
    if (searchdata.length == 0) {
      if (searchcheck) {
        return Container(
          alignment: Alignment.topCenter,
          child: CircularProgressIndicator(),
        );
      } else {
        return Container();
      }
    } else {
      return ListView.builder(
        itemCount: searchdata.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 6, 10, 0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 20,
              color: Colors.grey[900],
              child: ListTile(
                leading: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  heroTag: searchdata[index]['email'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => UserInfoPage(
                          useremail: searchdata[index]['email'],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 21,
                    backgroundImage: NetworkImage(
                      searchdata[index]['profilepicurl'],
                    ),
                  ),
                ),
                title: Text(
                  searchdata[index]['name'],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  searchdata[index]['email'],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    chatman.presentchecker(loginuser2.email.toString(),
                        searchdata[index]['email']);
                    setState(() {
                      chatto = searchdata[index]['email'];
                      getonpressemail = searchdata[index]['email'];
                    });
                    Fluttertoast.showToast(
                        msg: "Go Back to the Chats Page and Continue!");
                  },
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        shadowColor: Colors.lightBlue,
        title: Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: stext,
                      onChanged: (String str) {
                        getsearchdata(str);
                        if (str.length != 0) {
                          setState(() {
                            searchcheck = true;
                          });
                        } else {
                          setState(() {
                            searchcheck = false;
                          });
                        }
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "username",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _searchresult(),
            ),
          ],
        ),
      ),
    );
  }
}
