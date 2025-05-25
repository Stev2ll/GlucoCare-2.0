import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodApiService {
  final String baseUrl = 'https://es.openfoodfacts.org/cgi/search.pl';

  Future<List<FoodItem>> fetchFoodItems(String query) async {
    final response = await http.get(Uri.parse('$baseUrl?search_terms=$query&search_simple=1&action=process&json=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<FoodItem> foodItems = (data['products'] as List)
          .map((item) => FoodItem.fromJson(item))
          .toList();
      return foodItems;
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load food items');
    }
  }
}

class FoodItem {
  final String name;
  final String carbs;
  final String calories;

  FoodItem({required this.name, required this.carbs, required this.calories});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['product_name'] ?? 'No name',
      carbs: json['nutriments']['carbohydrates_100g']?.toString() ?? 'No data',
      calories: json['nutriments']['energy-kcal_100g']?.toString() ?? '0', // Ajusta según la API
    );
  }

  String? get caloriesPer100g => null;

  String? get carbsPer100g => null;

  get glycemicIndex => null;

  Map<String, dynamic> toJson() => {
    'name': name,
    'carbs': carbs,
    'calories': calories,
  };
}