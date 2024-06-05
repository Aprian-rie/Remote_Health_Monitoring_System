import 'package:flutter/material.dart';
import 'profile_tab.dart'; // Import the ProfileTab widget

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        // Reusing the app bar from the Dashboard
        // You can customize this app bar as needed
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // Add any actions if needed
        ],
      ),
      body: ProfileTab(), // Use ProfileTab directly as the body of the page
    );
  }
}
