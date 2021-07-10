import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamsclone/authentication/google_signin.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => new _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController text1 = new TextEditingController();
  final TextEditingController text2 = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/welcome.png',
              height: 300,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Please login to Continue!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50.0,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => disclaimer(context),
                  );
                },
                child: Container(
                  width: 230,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlue,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Google Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget disclaimer(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.grey[900],
    title: Center(
      child: Text(
        'Notice',
        style: TextStyle(
          color: Colors.white,
          fontSize: 23,
        ),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              Text(
                'The Google SignIn will only store your information like profile picture, name and email!',
                textAlign: TextAlign.center,
                maxLines: 10,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 50.0,
                child: GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: ButtonTheme(
                      height: 45,
                      minWidth: 100,
                      buttonColor: Colors.lightBlue,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        onPressed: () {
                          final provider = Provider.of<Googlesigninprov>(
                            context,
                            listen: false,
                          );
                          provider.glogin();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "CONTINUE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 2.0,
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
  );
}
