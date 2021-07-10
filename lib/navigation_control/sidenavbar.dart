import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:teamsclone/authentication/google_signin.dart';
import 'package:teamsclone/usermodel/firebaseuser.dart';
import 'package:url_launcher/url_launcher.dart';

class Sidenavbar extends StatefulWidget {
  const Sidenavbar({Key? key}) : super(key: key);

  @override
  _SidenavbarState createState() => _SidenavbarState();
}

class _SidenavbarState extends State<Sidenavbar> {
  final loginuser = FirebaseAuth.instance.currentUser!;

  launchurl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "could not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          height: 400,
          width: 400,
          padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
          color: Colors.grey[900],
          child: ListView(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => UserInfoPage(
                        useremail: loginuser.email,
                      ),
                    ),
                  );
                },
                dense: true,
                leading: CircleAvatar(
                  maxRadius: 25,
                  backgroundImage: NetworkImage(
                    loginuser.photoURL!,
                  ),
                ),
                title: Text(
                  "  ${loginuser.email!}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Whats New',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        launchurl(
                            'https://support.microsoft.com/en-us/office/what-s-new-in-microsoft-teams-d7092a6d-c896-424c-b362-a472d5f105de');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      leading: Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                      onTap: () {
                        final provider = Provider.of<Googlesigninprov>(context,
                            listen: false);
                        provider.logoutofapp();
                      },
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
