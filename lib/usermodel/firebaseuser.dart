import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:teamsclone/data/userdata.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoPage extends StatefulWidget {
  final String? useremail;
  const UserInfoPage({Key? key, this.useremail}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  UserDataManagement userob = new UserDataManagement();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        shadowColor: Colors.lightBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.navigate_before,
          ),
        ),
        centerTitle: true,
        title: Text(
          userob.returninfo(widget.useremail!, 1),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    userob.returninfo(widget.useremail!, 0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  userob.returninfo(widget.useremail!, 1),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  userob.returninfo(widget.useremail!, 2)
                      ? Icons.verified_outlined
                      : Icons.cancel_outlined,
                  color: userob.returninfo(widget.useremail!, 2)
                      ? Colors.green
                      : Colors.red,
                  size: 25,
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: widget.useremail!,
                          style: new TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                'mailto:${widget.useremail}?',
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
