import 'package:flutter/material.dart';
import 'package:remote_health/defaults/recipe_card.dart';
import 'package:remote_health/screens/recipe_screen.dart';
import 'package:remote_health/services/diet_api_service.dart';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';
import '../models/meal_plan_model.dart';
import '../models/recipe_model.dart';

class MealsScreen extends StatefulWidget {
  final MealPlan mealPlan;

  MealsScreen({required this.mealPlan});

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  _buildTotalNutrientsCard() {
    return Container(
      height: 140.0,
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Total Nutrients',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Calories: ${widget.mealPlan.calories.toString()} cal',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Protein: ${widget.mealPlan.protein.toString()} g',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Fat: ${widget.mealPlan.fat.toString()} g',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Carbs: ${widget.mealPlan.carbs.toString()} g',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildMealCard(Meal meal, int index) {
    String mealType = _mealType(index);
    return GestureDetector(
      onTap: () async {
        Recipe recipe =
        await DietApiService.instance.fetchRecipe(meal.id.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeScreen(
              mealType: mealType,
              recipe: recipe,
            ),
          ),
        );
      },
      child: RecipeCard(title: mealType, thumbnailUrl: meal.imageUrl, description: meal.title,),
      // child: Container(
      //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(15.0),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black12,
      //         offset: Offset(0, 2),
      //         blurRadius: 6.0,
      //       ),
      //     ],
      //   ),
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: <Widget>[
      //       Expanded(
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(15.0),
      //           child: FutureBuilder<void>(
      //             future: _getImage(meal.imageUrl),
      //             builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
      //               if (snapshot.connectionState == ConnectionState.waiting) {
      //                 return Center(child: CircularProgressIndicator());
      //               } else if (snapshot.hasError) {
      //                 return Center(child: Text('Error loading image'));
      //               } else {
      //                 return Image.network(
      //                   meal.imageUrl,
      //                   height: 220.0,
      //                   fit: BoxFit.cover,
      //                 );
      //               }
      //             },
      //           ),
      //         ),
      //       ),
      //       SizedBox(width: 10.0),
      //       Expanded(
      //         flex: 2,
      //         child: Container(
      //           padding: EdgeInsets.all(10.0),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: <Widget>[
      //               Text(
      //                 mealType,
      //                 style: TextStyle(
      //                   fontSize: 20.0,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               SizedBox(height: 5.0),
      //               Text(
      //                 meal.title,
      //                 style: TextStyle(
      //                   fontSize: 18.0,
      //                 ),
      //                 maxLines: 2,
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> _getImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Image loaded successfully
        return;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Failed to load image');
    }
  }

  _mealType(int index) {
    switch (index % 3) {
      case 0:
        return 'Breakfast';
      case 1:
        return 'Lunch';
      case 2:
        return 'Dinner';
      default:
        return 'Meal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Meal Plan'),
      ),
      body: ListView.builder(
        itemCount: 1 + widget.mealPlan.meals.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildTotalNutrientsCard();
          }
          Meal meal = widget.mealPlan.meals[index - 1];
          return _buildMealCard(meal, index - 1);
        },
      ),
    );
  }
}
