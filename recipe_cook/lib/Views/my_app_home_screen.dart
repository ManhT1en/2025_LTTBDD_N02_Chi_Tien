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
  State<MyAppHomeScreen> createState() =>
      _MyAppHomeScreenState();
}

class _MyAppHomeScreenState
    extends State<MyAppHomeScreen> {
  String category = "All";
  bool _showImportButton =
      false; // nút dùng để import data

  // cho category
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection(
        "App-Category",
      );
  // Hiển thị tất cả các món
  Query get filteredRecipes => FirebaseFirestore
      .instance
      .collection("Recipe-cook-app")
      .where('category', isEqualTo: category);
  Query get allRecipes => FirebaseFirestore
      .instance
      .collection("Recipe-cook-app");
  Query get selectedRecipes => category == "All"
      ? allRecipes
      : filteredRecipes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    headerParts(),
                    mySearchBar(),
                    //for banner
                    const BannertoExplore(),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                      child: Text(
                        AppLocalizations.of(
                          context,
                        ).categories,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    // Hiển thị danh sách category: 1 hàng, co giãn đều theo màn hình
                    StreamBuilder<QuerySnapshot>(
                      stream: categoriesItems
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child:
                                CircularProgressIndicator(),
                          );
                        }
                        final docs =
                            snapshot.data!.docs;
                        final localizations =
                            AppLocalizations.of(
                              context,
                            );

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            const spacing = 12.0;
                            final count =
                                docs.length == 0
                                ? 1
                                : docs.length;
                            // chia đều bề rộng cho mỗi ô
                            final itemWidth =
                                (constraints
                                        .maxWidth -
                                    spacing *
                                        (count -
                                            1)) /
                                count;

                            return SizedBox(
                              height: 48,
                              child: Row(
                                children: [
                                  for (
                                    int i = 0;
                                    i < docs.length;
                                    i++
                                  ) ...[
                                    SizedBox(
                                      width:
                                          itemWidth,
                                      height: 48,
                                      child: _CategoryItem(
                                        name:
                                            docs[i]['name']
                                                as String,
                                        isSelected:
                                            category ==
                                            docs[i]['name'],
                                        translate:
                                            (
                                              key,
                                            ) => localizations.translate(
                                              key,
                                            ),
                                        onTap: () => setState(
                                          () => category =
                                              docs[i]['name'],
                                        ),
                                      ),
                                    ),
                                    if (i !=
                                        docs.length -
                                            1)
                                      const SizedBox(
                                        width:
                                            spacing,
                                      ),
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          ).quickEasy,
                          style: const TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.1,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ViewAllItems(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(
                              context,
                            ).viewAll,
                            style: const TextStyle(
                              color: kBannerColor,
                              fontWeight:
                                  FontWeight.w600,
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
                final localizations =
                    AppLocalizations.of(context);
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(
                          20,
                        ),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              localizations
                                  .translate(
                                    'importing_data',
                                  ),
                            ),
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ ${localizations.translate('import_success')}',
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(
                      seconds: 3,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.upload),
              label: Text(
                AppLocalizations.of(
                  context,
                ).translate('import_data'),
              ),
              backgroundColor: kprimaryColor,
            )
          : null,
    );
  }

  StreamBuilder<QuerySnapshot<Object?>>
  selectedCategory() {
    final localizations = AppLocalizations.of(
      context,
    );
    return StreamBuilder(
      stream: selectedRecipes.snapshots(),
      builder:
          (
            context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child:
                    CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  localizations.translate(
                    'error_loading_data',
                  ),
                ),
              );
            }
            final List<DocumentSnapshot> recipes =
                snapshot.data?.docs ?? [];
            if (recipes.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Center(
                  child: Text(
                    localizations.translate(
                      'no_items_in_category',
                    ),
                  ),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.only(
                top: 5,
                bottom: 15,
              ),
              child: SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal,
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return FoodItemsDisplay(
                      documentSnapshot:
                          recipes[index],
                    );
                  },
                ),
              ),
            );
          },
    );
  }

  Padding mySearchBar() {
    final localizations = AppLocalizations.of(
      context,
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        style: TextStyle(
          color: Theme.of(
            context,
          ).textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          filled: true,
          prefixIcon: Icon(
            Iconsax.search_normal,
            color: Theme.of(
              context,
            ).iconTheme.color,
          ),
          fillColor: Theme.of(context).cardColor,
          border: InputBorder.none,
          hintText:
              localizations.searchPlaceholder,
          hintStyle: TextStyle(
            color: Theme.of(context).hintColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Row headerParts() {
    final localizations = AppLocalizations.of(
      context,
    );
    return Row(
      children: [
        Expanded(
          child: Text(
            localizations.whatCookToday,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        const ThemeSwitcher(), // Dark mode toggle
        const SizedBox(width: 8),
        MyIconButton(
          icon: Iconsax.notification,
          pressed: () {},
        ),
      ],
    );
  }
}

// Widget phụ cho item (giữ style đồng nhất)
class _CategoryItem extends StatelessWidget {
  final String name;
  final bool isSelected;
  final void Function() onTap;
  final String Function(String) translate;
  const _CategoryItem({
    required this.name,
    required this.isSelected,
    required this.onTap,
    required this.translate,
  });

  String _translated(String n) {
    switch (n.toLowerCase()) {
      case 'all':
        return translate('all');
      case 'breakfast':
        return translate('breakfast');
      case 'lunch':
        return translate('lunch');
      case 'dinner':
        return translate('dinner');
      default:
        return n;
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtColor = isSelected
        ? Colors.white
        : Theme.of(
            context,
          ).textTheme.bodyLarge?.color;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor
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
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _translated(name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: txtColor,
            ),
          ),
        ),
      ),
    );
  }
}
