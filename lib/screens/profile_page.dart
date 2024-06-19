import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:remote_health/models/user_profile.dart';
import 'package:remote_health/services/database_service.dart';
import 'package:remote_health/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DatabaseService _databaseService;
  final GetIt _getIt = GetIt.instance;
  UserProfile? _userProfile;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users2')
          .doc(user.uid)
          .get();
      setState(() {
        _userProfile =
            UserProfile.fromJson(docSnapshot.data() as Map<String, dynamic>);
      });
      // Load profile photo URL
      _loadProfilePhoto(user.uid);
    }
  }

  Future<void> _loadProfilePhoto(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        setState(() {
          _photoUrl = doc['photoUrl'] as String?;
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: _userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _photoUrl != null
                          ? NetworkImage(_photoUrl!)
                          : NetworkImage(PLACEHOLDER_PFP),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text('First Name: ${_userProfile!.firstName}',
                      style: const TextStyle(fontSize: 20.0)),
                  const SizedBox(height: 10.0),
                  Text('Last Name: ${_userProfile!.lastName}',
                      style: const TextStyle(fontSize: 20.0)),
                  const SizedBox(height: 10.0),
                  Text('UID: ${_userProfile!.uid}',
                      style: const TextStyle(fontSize: 20.0)),
                ],
              ),
            ),
    );
  }
}
