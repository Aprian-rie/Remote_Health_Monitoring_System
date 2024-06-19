import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/meal_plan_model.dart';
import '../models/recipe_model.dart';
import '../utils/constants.dart';

class DietApiService {
  DietApiService._instantiate();

  static final DietApiService instance = DietApiService._instantiate();

  final String _baseUrl = 'api.spoonacular.com';
  static const String API_KEY = DIET_API_KEY;

  Future<MealPlan> generateMealPlan({required int targetCalories, required String diet}) async {
    if (diet == 'None') diet = '';
    print('Generating meal plan with targetCalories: $targetCalories, diet: $diet');

    Map<String, String> parameters = {
      'timeFrame': 'day',
      'targetCalories': targetCalories.toString(),
      'diet': diet,
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, '/recipes/mealplans/generate', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print('Response data: $data');
        MealPlan mealPlan = MealPlan.fromMap(data);
        return mealPlan;
      } else {
        throw 'Failed to generate meal plan. Status code: ${response.statusCode}';
      }
    } catch (err) {
      print('Error: $err');
      throw err.toString();
    }
  }

  Future<Recipe> fetchRecipe(String id) async {
    Map<String, String> parameters = {
      'includeNutrition': 'false',
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, '/recipes/$id/information', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        Recipe recipe = Recipe.fromMap(data);
        return recipe;
      } else {
        throw 'Failed to fetch recipe. Status code: ${response.statusCode}';
      }
    } catch (err) {
      throw err.toString();
    }
  }
}
