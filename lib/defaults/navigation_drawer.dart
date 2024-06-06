// drawer_menu.dart
import 'package:flutter/material.dart';
import 'package:remote_health/profile_page.dart';
import 'package:remote_health/profile_tab.dart';
import 'package:remote_health/reminder_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';

class DrawerMenu extends StatelessWidget {
  final BuildContext parentContext;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  DrawerMenu({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<GoogleSignInAccount?>(
        future: googleSignIn.signInSilently(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return _buildDrawerContent(context, 'User', null);
          } else {
            GoogleSignInAccount user = snapshot.data!;
            return _buildDrawerContent(context, user.displayName, user.photoUrl);
          }
        },
      ),
    );
  }

  Widget _buildDrawerContent(BuildContext context, String? name, String? photoUrl) {
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
              if (photoUrl != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                  radius: 40,
                )
              else
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 40,
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
