import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:remote_health/screens/chat_page.dart';
import 'package:remote_health/screens/home_page.dart';
import 'package:remote_health/screens/profile_page.dart';
import 'defaults/navigation_drawer.dart';
import 'screens/health_tips_page.dart';


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
  late Animation<double> o2Animation;
  late Animation<double> bloodpressureAnimation;

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

    o2Animation = Tween<double>(begin: 0, end: 0).animate(progressController)..addListener(() {
      setState(() {});
    });

    bloodpressureAnimation = Tween<double>(begin: 0, end: 0).animate(progressController)..addListener(() {
      setState(() {});
    });

    databaseReference.child('ESP').onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        double temp = _parseDouble(snapshot.child('Temperature').value);
        double bpm = _parseDouble(snapshot.child('Heart_rate').value);
        double bloodpressure = _parseDouble(snapshot.child('bp_d').value);
        double o2conc = _parseDouble(snapshot.child('Temp_F').value);

        setState(() {
          tempAnimation = Tween<double>(begin: tempAnimation.value, end: temp).animate(progressController)..addListener(() {
            setState(() {});
          });

          bpmAnimation = Tween<double>(begin: bpmAnimation.value, end: bpm).animate(progressController)..addListener(() {
            setState(() {});
          });

          bloodpressureAnimation = Tween<double>(begin: bloodpressureAnimation.value, end: bloodpressure).animate(progressController)..addListener(() {
            setState(() {});
          });

          o2Animation = Tween<double>(begin: o2Animation.value, end: o2conc).animate(progressController)..addListener(() {
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
            'Remote Health',
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
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.tips_and_updates), text: 'H Tips'),
              Tab(icon: Icon(Icons.face_retouching_natural_rounded), text: 'Profile'),
              Tab(icon: Icon(Icons.mail), text: 'Messages'),
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
              o2Animation: o2Animation,
              bloodpressureAnimation: bloodpressureAnimation,
            ),
            HealthTipsTab(),
            ProfilePage(),
            ChatPage(),
          ],
        ),
      ),
    );
  }
}
