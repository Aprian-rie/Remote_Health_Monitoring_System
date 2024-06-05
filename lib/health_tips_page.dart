import 'main.dart';
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
                itemDashboard(context, 'Videos', CupertinoIcons.play_rectangle, Colors.deepOrange),
                itemDashboard(context, 'Articles', CupertinoIcons.graph_circle, Colors.green),
                itemDashboard(context, 'Diet Plans', CupertinoIcons.person_2, Colors.purple),
                itemDashboard(context, 'Statistics (Analytics)', CupertinoIcons.chat_bubble_2, Colors.brown),
                itemDashboard(context, 'Mental Health', CupertinoIcons.money_dollar_circle, Colors.indigo),
                itemDashboard(context, 'Exercise Routines', CupertinoIcons.add_circled, Colors.teal),
                itemDashboard(context, 'Yoga Practices', CupertinoIcons.question_circle, Colors.blue),
                itemDashboard(context, 'Emergency Contacts', CupertinoIcons.phone, Colors.pinkAccent),
              ],
            ),
          )
        ],
      ),
    );
  }

  itemDashboard(BuildContext context, String title, IconData iconData, Color background) => Container(
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
  );
}
