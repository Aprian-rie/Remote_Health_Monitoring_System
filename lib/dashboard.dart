// dashboard.dart
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'defaults/navigation_drawer.dart';
import 'home_page.dart';
import 'health_tips_page.dart';
import 'profile_tab.dart';
import 'chat_page.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.ref();

  late AnimationController progressController;
  late Animation<double> tempAnimation;
  late Animation<double> bpmAnimation;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    );

    tempAnimation = Tween<double>(begin: 0, end: 0).animate(progressController)..addListener(() {
      setState(() {});
    });

    bpmAnimation = Tween<double>(begin: 0, end: 0).animate(progressController)..addListener(() {
      setState(() {});
    });

    databaseReference.child('ESP').onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        double temp = _parseDouble(snapshot.child('Temperature').value);
        double bpm = _parseDouble(snapshot.child('Heart_rate').value);

        setState(() {
          tempAnimation = Tween<double>(begin: tempAnimation.value, end: temp).animate(progressController)..addListener(() {
            setState(() {});
          });

          bpmAnimation = Tween<double>(begin: bpmAnimation.value, end: bpm).animate(progressController)..addListener(() {
            setState(() {});
          });

          progressController.forward(from: 0);
          isLoading = false;
        });
      }
    });
  }

  double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      throw Exception('Value is neither int nor double: $value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.reorder),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3ABEF9), Color(0xff615EFC)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.tips_and_updates), text: 'Health Tips'),
              Tab(icon: Icon(Icons.face_retouching_natural_rounded), text: 'Profile'),
              Tab(icon: Icon(Icons.mail), text: 'Chat'),
            ],
          ),
          elevation: 20,
        ),
        drawer: DrawerMenu(parentContext: context),
        body: TabBarView(
          children: [
            HomeTab(
              isLoading: isLoading,
              tempAnimation: tempAnimation,
              bpmAnimation: bpmAnimation,
            ),
            HealthTipsTab(),
            ProfileTab(),
            ChatTab(),
          ],
        ),
      ),
    );
  }
}
