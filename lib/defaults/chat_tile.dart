import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';
import '../utils/constants.dart';

class ChatTile extends StatelessWidget {
  final String userId;
  final UserProfile userProfile;
  final Function onTap;


  const ChatTile({Key? key, required this.userId, required this.userProfile, required this.onTap})
      : super(key: key);

  Future<String?> _getUserProfilePhotoUrl(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return doc['photoUrl'] as String?;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserProfilePhotoUrl(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: CircleAvatar(child: CircularProgressIndicator()),
            title: Text('Loading...'),
          );
        } else {
          String? photoUrl = snapshot.data;
          return ListTile(
            onTap: (){
              onTap();
            },
            dense: false,
            leading: CircleAvatar(
              radius: 30.0,
            backgroundImage: photoUrl != null
                ? NetworkImage(photoUrl)
                : NetworkImage(PLACEHOLDER_PFP),
          ),
            title: Text('${userProfile.firstName} ${userProfile.lastName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ) ,), // Replace with actual user name if available
          );
        }
      },
    );
  }
}
