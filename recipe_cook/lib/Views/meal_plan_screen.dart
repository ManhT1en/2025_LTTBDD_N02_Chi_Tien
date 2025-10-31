import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:recipe_cook/Provider/meal_plan_provider.dart';
import 'package:recipe_cook/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../Untils/constants.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  DateTime _selectedDate = DateTime.now();

  // Get list of 7 days starting from today
  List<DateTime> get weekDays {
    final today = DateTime.now();
    return List.generate(7, (index) => today.add(Duration(days: index)));
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanProvider = Provider.of<MealPlanProvider>(context);
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          localizations.translate('nav_meal_plan'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Week selector
          _buildWeekSelector(),
          const SizedBox(height: 20),
          // Meal slots for selected day
          Expanded(child: _buildMealSlots(mealPlanProvider, localizations)),
        ],
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          final day = weekDays[index];
          final isSelected = _formatDate(day) == _formatDate(_selectedDate);
          final isToday = _formatDate(day) == _formatDate(DateTime.now());

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = day;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                border: isToday && !isSelected
                    ? Border.all(color: kPrimaryColor, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(day),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('dd').format(day),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealSlots(
    MealPlanProvider mealPlanProvider,
    AppLocalizations localizations,
  ) {
    final dateKey = _formatDate(_selectedDate);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMealSlot(
          context,
          mealPlanProvider,
          localizations,
          dateKey,
          'breakfast',
          localizations.translate('breakfast'),
          Icons.wb_sunny,
        ),
        const SizedBox(height: 16),
        _buildMealSlot(
          context,
          mealPlanProvider,
          localizations,
          dateKey,
          'lunch',
          localizations.translate('lunch'),
          Icons.wb_cloudy,
        ),
        const SizedBox(height: 16),
        _buildMealSlot(
          context,
          mealPlanProvider,
          localizations,
          dateKey,
          'dinner',
          localizations.translate('dinner'),
          Icons.nightlight_round,
        ),
      ],
    );
  }

  Widget _buildMealSlot(
    BuildContext context,
    MealPlanProvider mealPlanProvider,
    AppLocalizations localizations,
    String dateKey,
    String mealType,
    String mealName,
    IconData icon,
  ) {
    final recipeId = mealPlanProvider.getMeal(dateKey, mealType);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kPrimaryColor),
              const SizedBox(width: 8),
              Text(
                mealName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          recipeId == null
              ? _buildAddMealButton(
                  context,
                  mealPlanProvider,
                  dateKey,
                  mealType,
                  localizations,
                )
              : _buildMealCard(
                  context,
                  mealPlanProvider,
                  recipeId,
                  dateKey,
                  mealType,
                  localizations,
                ),
        ],
      ),
    );
  }

  Widget _buildAddMealButton(
    BuildContext context,
    MealPlanProvider mealPlanProvider,
    String dateKey,
    String mealType,
    AppLocalizations localizations,
  ) {
    return InkWell(
      onTap: () =>
          _showRecipeSelector(context, mealPlanProvider, dateKey, mealType),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: kPrimaryColor),
            const SizedBox(width: 8),
            Text(
              localizations.translate('add_recipe'),
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    MealPlanProvider mealPlanProvider,
    String recipeId,
    String dateKey,
    String mealType,
    AppLocalizations localizations,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('Recipe-cook-app')
          .doc(recipeId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final recipe = snapshot.data!;
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe['image'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      child: Icon(
                        Icons.image_not_supported,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe['time']} ${localizations.translate('min')}',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  mealPlanProvider.removeMeal(dateKey, mealType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRecipeSelector(
    BuildContext context,
    MealPlanProvider mealPlanProvider,
    String dateKey,
    String mealType,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeSelectorSheet(
        onRecipeSelected: (recipeId) {
          mealPlanProvider.setMeal(dateKey, mealType, recipeId);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class RecipeSelectorSheet extends StatelessWidget {
  final Function(String) onRecipeSelected;

  const RecipeSelectorSheet({super.key, required this.onRecipeSelected});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.translate('select_recipe'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Recipe-cook-app')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final recipes = snapshot.data!.docs;
                final isDark = Theme.of(context).brightness == Brightness.dark;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            recipe['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade300,
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.black54,
                                ),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          recipe['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          '${recipe['time']} min • ${recipe['calo']} cal',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        onTap: () => onRecipeSelected(recipe.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
