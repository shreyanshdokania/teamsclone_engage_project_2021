import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teamsclone/data/inmeetchat.dart';
import 'package:teamsclone/data/postsdata.dart';
import 'package:teamsclone/meeting_pages/callscreen.dart';

class DirectMeetJoin {
  PostsDataManagement pob = new PostsDataManagement();
  InmeetChatManagement meetchat = new InmeetChatManagement();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> onJoin(String id, BuildContext context) async {
    if (id.isNotEmpty) {
      await _handleCameraAndMic(
        Permission.camera,
      );
      await _handleCameraAndMic(
        Permission.microphone,
      );
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CallConversationPage(
            meetid: id,
          ),
        ),
      );
    }
  }

  updatearray(
      String hostemail, String fromemail, String teamname, String meetid) {
    pob.updatemembersarray(hostemail, fromemail, teamname, meetid);
  }
}
