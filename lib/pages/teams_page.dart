import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teamsclone/data/postsdata.dart';
import 'package:teamsclone/data/teamsdataman.dart';
import 'package:teamsclone/teams/posts.dart';

class Teams extends StatefulWidget {
  const Teams({Key? key}) : super(key: key);

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  TeamsDataManagement dataobject = new TeamsDataManagement();
  PostsDataManagement pob = new PostsDataManagement();

  StreamSubscription? subs;
  bool connection = true;

  List _teamslist = [];
  List _hostedteams = [];
  List _joinedteams = [];

  @override
  void initState() {
    super.initState();
    getdata();
    getdataforuser();

    subs = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        connection = (event != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    subs?.cancel();
    super.dispose();
  }

  getdataforuser() async {
    userdata = await pob.getuserdata();
  }

  bool loader = false;

  Future<Null> getdata() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _teamslist.clear();
      _hostedteams.clear();
      _joinedteams.clear();
    });

    _teamslist = await dataobject.getteams();
    setState(() {
      _hostedteams = dataobject.returnseparatedlist(true);
      _joinedteams = dataobject.returnseparatedlist(false);
    });

    setState(() {
      loader = true;
    });

    getdataforuser();

    return null;
  }

  Widget _teamlistview() {
    if (!connection)
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/no_internett.png'),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    if (!loader)
      return Center(
        child: CircularProgressIndicator(),
      );
    return RefreshIndicator(
      color: Colors.lightBlue,
      backgroundColor: Colors.grey[900],
      onRefresh: getdata,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "HOSTED TEAMS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.grey[700],
                  thickness: 10,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5.5,
                      );
                    },
                    itemCount: _hostedteams.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FlatButton(
                        onPressed: null,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          color: Colors.grey[800],
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 10.0,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ListTile(
                              onLongPress: () {
                                Fluttertoast.showToast(
                                  msg: "General Channel",
                                );
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => PostsPage(
                                      hostemail: _hostedteams[index]['host'],
                                      members: _hostedteams[index]
                                          ['membersemail'],
                                      teamname: _hostedteams[index]['teamname'],
                                    ),
                                  ),
                                );
                              },
                              leading: Icon(
                                Icons.group,
                                color: Colors.white,
                              ),
                              title: Text(
                                _hostedteams[index]['teamname'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'General',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: Text(
                                _hostedteams[index]['membersemail']
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey[700],
                  thickness: 10,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "JOINED TEAMS",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5.5,
                      );
                    },
                    itemCount: _joinedteams.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FlatButton(
                        onPressed: null,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          color: Colors.grey[800],
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 10.0,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ListTile(
                              onLongPress: () {
                                Fluttertoast.showToast(
                                  msg: "General Channel",
                                );
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => PostsPage(
                                      hostemail: _joinedteams[index]['host'],
                                      members: _joinedteams[index]
                                          ['membersemail'],
                                      teamname: _joinedteams[index]['teamname'],
                                    ),
                                  ),
                                );
                              },
                              leading: Icon(
                                Icons.group,
                                color: Colors.white,
                              ),
                              title: Text(
                                _joinedteams[index]['teamname'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'General',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: Text(
                                _joinedteams[index]['membersemail']
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: _teamlistview(),
      ),
    );
  }
}
