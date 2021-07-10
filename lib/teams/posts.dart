import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teamsclone/data/postsdata.dart';
import 'package:teamsclone/data/userdata.dart';
import 'package:teamsclone/meeting_pages/join.dart';
import 'package:teamsclone/meeting_pages/meet_popup.dart';
import 'package:teamsclone/meeting_pages/meetchat.dart';
import 'package:teamsclone/meeting_pages/schedule_meet.dart';
import 'package:teamsclone/teams/about.dart';
import 'package:teamsclone/usermodel/firebaseuser.dart';

List userdata = [];

class PostsPage extends StatefulWidget {
  final String? hostemail;
  final List? members;
  final String? teamname;
  const PostsPage({Key? key, this.hostemail, this.members, this.teamname})
      : super(key: key);

  @override
  PostsPageState createState() => PostsPageState();
}

class PostsPageState extends State<PostsPage> {
  PostsDataManagement pob = new PostsDataManagement();

  UserDataManagement udata = new UserDataManagement();
  DirectMeetJoin joindirect = new DirectMeetJoin();
  InmeetChat inmeetchat = new InmeetChat();

  TeamAbout infoobj = new TeamAbout();

  final postscrollcontroller = ScrollController();

  var date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var time = int.parse(DateFormat("kk").format(DateTime.now()));

  final TextEditingController ptext = new TextEditingController();
  final curruser = FirebaseAuth.instance.currentUser!;
  bool textfield = true;
  bool postload = false;

  directjoin(String meetid, BuildContext context) {
    joindirect.onJoin(meetid, context);
    joindirect.updatearray(
        widget.hostemail!, curruser.email!, widget.teamname!, meetid);
    setState(() {
      pdocid = pob.getdocid(widget.hostemail!, widget.teamname!);
      pfrom = curruser.email!;
      phostemail = widget.hostemail!;
      pteamname = widget.teamname!;
    });
  }

  scrolltobottom() {
    if (postscrollcontroller.hasClients)
      postscrollcontroller
          .jumpTo(postscrollcontroller.position.maxScrollExtent);
  }

  Widget conditionalwidget(bool isscheduled, String dbdate, int dbtime,
      String postdata, bool ismeetid, bool chatvalid, String docid) {
    if (isscheduled) {
      if (dbdate == date &&
          dbtime <= int.parse(DateFormat("kk").format(DateTime.now())) &&
          ismeetid) {
        return SizedBox(
          height: 30,
          width: 80,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.blue,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                directjoin(postdata, context);
              },
              icon: Text(
                "JOIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      } else {
        // if (dbtime > time) {
        return SizedBox(
          height: 30,
          width: 80,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.blue,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  pdocid = pob.getdocid(widget.hostemail!, widget.teamname!);
                });
                inmeetchat.bottomchat(context, docid, postdata, ismeetid);
              },
              icon: Text(
                "CHAT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
        // }
      }
    } else {
      if (ismeetid) {
        return SizedBox(
          height: 30,
          width: 80,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.blue,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                directjoin(postdata, context);
              },
              icon: Text(
                "JOIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      } else {
        if (chatvalid) {
          return SizedBox(
            height: 30,
            width: 80,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.blue,
              ),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  setState(() {
                    pdocid = pob.getdocid(widget.hostemail!, widget.teamname!);
                  });
                  inmeetchat.bottomchat(context, docid, postdata, false);
                },
                icon: Text(
                  "CHAT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
    return Container();
  }

  Widget _poststile() {
    // if (!postload) return Container();
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("teams")
            .doc(pob.getdocid(widget.hostemail!, widget.teamname!))
            .collection("posts")
            .orderBy("count")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          WidgetsBinding.instance
              ?.addPostFrameCallback((_) => scrolltobottom());
          if (!snapshot.hasData) return Container();
          return ListView(
            controller: postscrollcontroller,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        color: Colors.grey[900],
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 0.0,
                        ),
                        child: ListTile(
                          leading: FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            heroTag: document['from'],
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => UserInfoPage(
                                    useremail: document['from'],
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                udata.returninfo(document['from'], 0),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                udata.returninfo(document['from'], 1),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: conditionalwidget(
                                    document['isscheduled'],
                                    document['date'],
                                    document['time'],
                                    document['postdata'],
                                    document['ismeetid'],
                                    document['chatvalid'],
                                    document.id),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  (document['isscheduled'])
                                      ? document['postdata'] + " (Scheduled)"
                                      : document['postdata'],
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.navigate_before,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "General",
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.teamname!,
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "(" + widget.members!.length.toString() + " guests)",
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  pdocid = pob.getdocid(widget.hostemail!, widget.teamname!);
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) => meetschedulepopup(
                      context, widget.hostemail!, widget.teamname!),
                );
              },
              iconSize: 28,
              icon: Icon(
                Icons.date_range,
              ),
            ),
            IconButton(
              onPressed: () {
                infoobj.initializebottomsheet(context, widget.members!);
              },
              iconSize: 28,
              icon: Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.lightBlue,
            indicatorWeight: 4,
            tabs: [
              Tab(
                child: Text(
                  "POSTS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Expanded(
                      child: _poststile(),
                    ),
                    Padding(
                      padding:
                          (!textfield) ? EdgeInsets.all(30) : EdgeInsets.all(0),
                      child: Align(
                        alignment: (!textfield)
                            ? Alignment.bottomRight
                            : Alignment.bottomCenter,
                        child: (!textfield)
                            ? Container(
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue,
                                  heroTag: "textfieldshowbutton",
                                  onPressed: () {
                                    setState(() {
                                      textfield = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.create_outlined,
                                  ),
                                ),
                              )
                            : Container(
                                height: 90,
                                padding: EdgeInsets.fromLTRB(10, 6, 10, 20),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 20,
                                  color: Colors.grey[800],
                                  child: ListTile(
                                    onTap: () {},
                                    leading: IconButton(
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        setState(() {
                                          pdocid = pob.getdocid(
                                              widget.hostemail!,
                                              widget.teamname!);
                                          pfrom = curruser.email!;
                                          phostemail = widget.hostemail!;
                                          pteamname = widget.teamname!;
                                          membersformailing.clear();
                                          membersformailing = widget.members!;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              popup(context),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.video_call_outlined,
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                    title: TextField(
                                      onTap: () {},
                                      controller: ptext,
                                      onChanged: (String str) {},
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Type your message....",
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        if (ptext.text.length != 0) {
                                          pob.getlastcount(
                                            pob.getdocid(widget.hostemail!,
                                                widget.teamname!),
                                            ptext.text,
                                            curruser.email!,
                                            widget.hostemail!,
                                            widget.teamname!,
                                            false,
                                            date,
                                            time,
                                            false,
                                          );
                                          setState(() {
                                            ptext.clear();
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.send_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
