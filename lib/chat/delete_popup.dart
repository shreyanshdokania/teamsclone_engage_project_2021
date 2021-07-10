import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamsclone/data/chatdataman.dart';
import 'package:teamsclone/pages/chat_page.dart';

class DeleteChat {
  Chatdatamanagement deleteobj = new Chatdatamanagement();

  Container _bottomnavigatiomenu(
      BuildContext context, String chatemail, String option) {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: Icon(
              Icons.delete_outline_outlined,
              size: 32,
              color: Colors.grey[500],
            ),
            title: Text(
              (option == "Delete") ? "Delete Chat" : "Clear Chats",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17.5,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    delete_popup(context, chatemail, option),
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(
              Icons.cancel_outlined,
              size: 32,
              color: Colors.red,
            ),
            title: Text(
              "Cancel",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17.5,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void showbottombuilder(
      BuildContext context, String chatemail, String optionstring) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            ),
          ),
          height: 120,
          child: _bottomnavigatiomenu(context, chatemail, optionstring),
        );
      },
    );
  }

  Widget delete_popup(BuildContext context, String chatemail, String decider) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Center(
            child: Text(
              (decider == "Delete")
                  ? 'This chat will be deleted'
                  : 'All chats from this window will be cleared',
              maxLines: 5,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
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
                    Row(
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: ButtonTheme(
                                height: 45,
                                minWidth: 100,
                                buttonColor: Colors.lightBlue,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "No",
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
                        Spacer(),
                        Container(
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: ButtonTheme(
                                height: 45,
                                minWidth: 100,
                                buttonColor: Colors.lightBlue,
                                child: TextButton(
                                  onPressed: () {
                                    if (decider == "Delete") {
                                      deleteobj.deletechat(chatemail);
                                      setState(() {
                                        filterdata.remove(chatemail);
                                      });
                                    } else {
                                      deleteobj.clearchat(chatemail);
                                    }
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Yes",
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
