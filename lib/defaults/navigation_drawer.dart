import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:remote_health/profile_page.dart';
import 'package:remote_health/reminder_page.dart';
import 'package:remote_health/services/media_service.dart';
import 'package:remote_health/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../services/storage_service.dart';

class DrawerMenu extends StatefulWidget {
  final BuildContext parentContext;

  const DrawerMenu({super.key, required this.parentContext});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState(parentContext: parentContext);
}

class _DrawerMenuState extends State<DrawerMenu> {
  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  final BuildContext parentContext;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late StorageService _storageService;

  _DrawerMenuState({required this.parentContext});

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
  }

  Future<DocumentSnapshot> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      throw Exception("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<User?>(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return _buildDrawerContent(context, 'User', null, '');
          } else {
            User user = snapshot.data!;
            bool isGoogleSignIn = user.providerData.any((userInfo) => userInfo.providerId == 'google.com');
            if (isGoogleSignIn) {
              return FutureBuilder<GoogleSignInAccount?>(
                future: googleSignIn.signInSilently(),
                builder: (context, googleSnapshot) {
                  if (googleSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (googleSnapshot.hasError || !googleSnapshot.hasData) {
                    return _buildDrawerContent(context, 'User', null, user.uid);
                  } else {
                    GoogleSignInAccount googleUser = googleSnapshot.data!;
                    return _buildDrawerContent(context, googleUser.displayName, googleUser.photoUrl, user.uid);
                  }
                },
              );
            } else {
              return FutureBuilder<DocumentSnapshot>(
                future: _getUserData(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return _buildDrawerContent(context, 'User', null, user.uid);
                  } else {
                    var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    String name = "${userData['firstName']} ${userData['lastName']}";
                    return _buildDrawerContent(context, name, userData['photoUrl'], user.uid);
                  }
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    } else {
      throw Exception("User not logged in");
    }
  }

  Widget _buildDrawerContent(BuildContext context, String? name, String? photoUrl, String uid) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff3ABEF9), Color(0xff615EFC)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  File? file = await _mediaService.getImageFromGallery();
                  if (file != null) {
                    String? pfpURL = await _storageService.uploadUserPfp(file: file, uid: uid);
                    if (pfpURL != null) {
                      await FirebaseFirestore.instance.collection('users').doc(uid).update({
                        'photoUrl': pfpURL,
                      });
                      setState(() {
                        // Force rebuild to show the updated image
                      });
                    }
                  }
                },
                child: CircleAvatar(
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
                  radius: 40,
                ),
              ),
              SizedBox(height: 10),
              Text(
                name ?? 'User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text('Dashboard'),
          onTap: () {
            Navigator.pop(context);
            DefaultTabController.of(parentContext)?.animateTo(0);
          },
        ),
        ListTile(
          leading: Icon(Icons.face),
          title: Text('Profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            DefaultTabController.of(parentContext)?.animateTo(1);
          },
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notifications'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to Notifications page or tab
          },
        ),
        ListTile(
          leading: Icon(Icons.alarm),
          title: Text('Reminders'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReminderPage()),
            );
            // Navigate to Reminders page or tab
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () => _handleLoginOutPopup(parentContext),
        ),
      ],
    );
  }

  void _handleLoginOutPopup(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Logging Out",
      desc: "Do you want to Log out.",
      buttons: [
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.teal,
          width: 120,
        ),
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            _handleSignOut(context);
          },
          color: Colors.teal,
          width: 120,
        ),
      ],
    ).show();
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      print("Sign out error: $e");
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MyApp()),
          (Route<dynamic> route) => false,
    );
  }
}
