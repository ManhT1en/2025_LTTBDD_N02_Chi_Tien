import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_cook/Untils/constants.dart';
import 'package:recipe_cook/Untils/import_data.dart';
import 'package:recipe_cook/Views/view_all_items.dart';
import 'package:recipe_cook/Widget/banner.dart';
import 'package:recipe_cook/Widget/food_items_display.dart';
import 'package:recipe_cook/Widget/my_icon_button.dart';
import 'package:recipe_cook/Widget/theme_switcher.dart';
import 'package:recipe_cook/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  String category = "All";
  bool _showImportButton = false; // nút dùng để import data

  // cho category
  final CollectionReference categoriesItems = FirebaseFirestore.instance
      .collection("App-Category");
  // Hiển thị tất cả các món
  Query get filteredRecipes => FirebaseFirestore.instance
      .collection("Recipe-cook-app")
      .where('category', isEqualTo: category);
  Query get allRecipes =>
      FirebaseFirestore.instance.collection("Recipe-cook-app");
  Query get selectedRecipes => category == "All" ? allRecipes : filteredRecipes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerParts(),
                    mySearchBar(),
                    //for banner
                    const BannertoExplore(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        AppLocalizations.of(context).categories,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Hiển thị danh sách category từ Firestore
                    StreamBuilder<QuerySnapshot>(
                      stream: categoriesItems.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final docs = snapshot.data!.docs;
                          final localizations = AppLocalizations.of(context);
                          return Wrap(
                            spacing: 10,
                            children: docs.map((doc) {
                              final isSelected = category == doc['name'];
                              final categoryName = doc['name'] as String;
                              // Translate category name
                              String translatedName;
                              switch (categoryName.toLowerCase()) {
                                case 'all':
                                  translatedName = localizations.translate(
                                    'all',
                                  );
                                  break;
                                case 'breakfast':
                                  translatedName = localizations.translate(
                                    'breakfast',
                                  );
                                  break;
                                case 'lunch':
                                  translatedName = localizations.translate(
                                    'lunch',
                                  );
                                  break;
                                case 'dinner':
                                  translatedName = localizations.translate(
                                    'dinner',
                                  );
                                  break;
                                default:
                                  translatedName = categoryName;
                              }
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    category = doc['name'];
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? kprimaryColor
                                        : Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    translatedName,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).quickEasy,
                          style: const TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ViewAllItems(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context).viewAll,
                            style: const TextStyle(
                              color: kBannerColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //for category
                    selectedCategory(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showImportButton
          ? FloatingActionButton.extended(
              onPressed: () async {
                final localizations = AppLocalizations.of(context);
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(localizations.translate('importing_data')),
                          ],
                        ),
                      ),
                    ),
                  ),
                );

                // Import data
                await ImportData.importFoodData();

                // Close loading dialog
                Navigator.pop(context);

                // Hide the import button after successful import
                setState(() {
                  _showImportButton = false;
                });

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ ${localizations.translate('import_success')}',
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              icon: Icon(Icons.upload),
              label: Text(
                AppLocalizations.of(context).translate('import_data'),
              ),
              backgroundColor: kprimaryColor,
            )
          : null,
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    final localizations = AppLocalizations.of(context);
    return StreamBuilder(
      stream: selectedRecipes.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(localizations.translate('error_loading_data')),
          );
        }
        final List<DocumentSnapshot> recipes = snapshot.data?.docs ?? [];
        if (recipes.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(localizations.translate('no_items_in_category')),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(top: 5, bottom: 15),
          child: SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return FoodItemsDisplay(documentSnapshot: recipes[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Padding mySearchBar() {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(Iconsax.search_normal),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: localizations.searchPlaceholder,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Row headerParts() {
    final localizations = AppLocalizations.of(context);
    return Row(
      children: [
        Text(
          localizations.whatCookToday,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const Spacer(),
        const ThemeSwitcher(), // Dark mode toggle
        const SizedBox(width: 8),
        MyIconButton(icon: Iconsax.notification, pressed: () {}),
      ],
    );
  }
}
