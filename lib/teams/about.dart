import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamsclone/data/userdata.dart';
import 'package:teamsclone/usermodel/firebaseuser.dart';

class TeamAbout {
  UserDataManagement info = new UserDataManagement();

  initializebottomsheet(context, List members) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 30),
          color: Colors.grey[900],
          height: 300,
          // color: Colors.grey[900],
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  "Members",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                height: 200,
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        heroTag: members[index].toString(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => UserInfoPage(
                                useremail: members[index],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            info.returninfo(members[index], 0),
                          ),
                        ),
                      ),
                      title: Text(
                        info.returninfo(members[index], 1),
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      subtitle: Text(
                        members[index],
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
