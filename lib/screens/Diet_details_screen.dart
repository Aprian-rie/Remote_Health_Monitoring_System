import 'package:flutter/material.dart';
import 'package:remote_health/utils/app_colors.dart';
import 'package:remote_health/utils/constants.dart';

class DietDetailsScreen extends StatelessWidget {
  final Map<String, String> dietDetails = {
    'None': 'No specific dietary restrictions.',
    'Gluten Free': gluten_free,
    'Ketogenic': ketogenic,
    'Lacto-Vegetarian': lacto_Vegetarian,
    'Ovo-Vegetarian': ovo_Vegetarian,
    'Vegan': vegan,
    'Pescetarian': pescetarian,
    'Paleo': paleo,
    'Primal': primal,
    'Whole30': whole30
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Diet ",
              style: TextStyle(
                  color: AppColors.primaryColor1,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Details",
              style: TextStyle(
                  color: AppColors.primaryColor2,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: dietDetails.length,
          itemBuilder: (context, index) {
            String diet = dietDetails.keys.elementAt(index);
            return Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            diet,
                            style: TextStyle(
                              color: AppColors.primaryColor1,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryColor2,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        dietDetails[diet]!,
                        style: TextStyle(
                          color: AppColors.primaryColor2,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
