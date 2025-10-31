import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MealPlanProvider extends ChangeNotifier {
  // Map structure: { "2024-01-15": { "breakfast": "recipeId1", "lunch": "recipeId2", "dinner": "recipeId3" } }
  Map<String, Map<String, String>> _mealPlan = {};

  Map<String, Map<String, String>> get mealPlan => _mealPlan;

  MealPlanProvider() {
    _loadMealPlan();
  }

  // Load meal plan from SharedPreferences
  Future<void> _loadMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final String? mealPlanString = prefs.getString('meal_plan');
    if (mealPlanString != null) {
      final Map<String, dynamic> decoded = json.decode(mealPlanString);
      _mealPlan = decoded.map(
        (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
      );
      notifyListeners();
    }
  }

  // Save meal plan to SharedPreferences
  Future<void> _saveMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_mealPlan);
    await prefs.setString('meal_plan', encoded);
  }

  // Add or update a meal for a specific date and meal type
  Future<void> setMeal(String date, String mealType, String recipeId) async {
    if (!_mealPlan.containsKey(date)) {
      _mealPlan[date] = {};
    }
    _mealPlan[date]![mealType] = recipeId;
    await _saveMealPlan();
    notifyListeners();
  }

  // Remove a meal from a specific date and meal type
  Future<void> removeMeal(String date, String mealType) async {
    if (_mealPlan.containsKey(date)) {
      _mealPlan[date]!.remove(mealType);
      if (_mealPlan[date]!.isEmpty) {
        _mealPlan.remove(date);
      }
      await _saveMealPlan();
      notifyListeners();
    }
  }

  // Get meal for a specific date and meal type
  String? getMeal(String date, String mealType) {
    return _mealPlan[date]?[mealType];
  }

  // Check if a meal exists for a date and meal type
  bool hasMeal(String date, String mealType) {
    return _mealPlan[date]?.containsKey(mealType) ?? false;
  }

  // Clear all meal plans
  Future<void> clearAllMeals() async {
    _mealPlan.clear();
    await _saveMealPlan();
    notifyListeners();
  }
}
