import 'package:remote_health/screens/channel_list_screen.dart';
import 'package:remote_health/screens/emergency_contacts_page.dart';
import 'package:remote_health/screens/exercise_page.dart';
import 'package:remote_health/screens/health_articles.dart';
import 'package:remote_health/screens/mental_health_articles_page.dart';
import 'package:remote_health/screens/search_screen_diet.dart';
import 'package:remote_health/screens/statistics_page.dart';
import 'package:remote_health/screens/video_Screen_home.dart';
import 'package:remote_health/screens/yoga_page.dart';

import '../main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HealthTipsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100)
              )
            ),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 40,
              mainAxisSpacing: 30,
              children: [
                itemDashboard(context, 'Videos', CupertinoIcons.play_rectangle, Colors.deepOrange,ChannelListScreen()),
                itemDashboard(context, 'Articles', CupertinoIcons.news, Colors.green, const HealthArticles()),
                itemDashboard(context, 'Diet Plans', CupertinoIcons.heart_circle_fill, Colors.purple,SearchScreenDiet()),
                itemDashboard(context, 'Statistics (Analytics)', CupertinoIcons.graph_circle, Colors.brown,StatisticsPage()),
                itemDashboard(context, 'Mental Health', CupertinoIcons.graph_square_fill, Colors.indigo,MentalHealthArticlesPage()),
                itemDashboard(context, 'Exercise Routines', CupertinoIcons.add_circled, Colors.teal,ExercisePage()),
                itemDashboard(context, 'Yoga Practices', CupertinoIcons.question_circle, Colors.blue,const YogaPage()),
                itemDashboard(context, 'Emergency Contacts', CupertinoIcons.phone, Colors.pinkAccent,EmergencyContactsPage()),
              ],
            ),
          )
        ],
      ),
    );
  }

  itemDashboard(BuildContext context, String title, IconData iconData, Color background, Widget targetPage) => GestureDetector(
    onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle
            ),
            child: Icon(iconData, color: Colors.white,),
          ),
          const SizedBox(height: 8,),
          Column(
            children: [
              if (title.contains(" ")) ...[
                Text(
                  title.split(" ").first,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  title.split(" ").last,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ] else ...[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ]

            ],
          ),
        ],
      ),
    ),
  );
}
