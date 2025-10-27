import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_cook/Untils/constants.dart';
import 'package:recipe_cook/Untils/import_data.dart';
import 'package:recipe_cook/Views/view_all_items.dart';
import 'package:recipe_cook/Widget/banner.dart';
import 'package:recipe_cook/Widget/food_items_display.dart';
import 'package:recipe_cook/Widget/my_icon_button.dart';
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
  final CollectionReference categoriesItems = 
      FirebaseFirestore.instance.collection("App-Category");
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
      backgroundColor: kbackgroundcolor,
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Categories",
                        style: TextStyle(
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
                          return Wrap(
                            spacing: 10,
                            children: docs.map((doc) {
                              final isSelected = category == doc['name'];
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
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    doc['name'],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
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
                        const Text(
                          "Nhanh và Dễ",
                          style: TextStyle(
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
                          child: const Text(
                            "Xem tất cả",
                            style: TextStyle(
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
                            Text('Đang import dữ liệu...'),
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
                    content: Text('✅ Import dữ liệu thành công!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              icon: Icon(Icons.upload),
              label: Text('Import Data'),
              backgroundColor: kprimaryColor,
            )
          : null,
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
      stream: selectedRecipes.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải dữ liệu'));
        }
        final List<DocumentSnapshot> recipes = snapshot.data?.docs ?? [];
        if (recipes.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text('Không có món ăn nào trong mục này')),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(Iconsax.search_normal),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: "bạn muốn ăn gì hôm nay?",
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
    return Row(
      children: [
        const Text(
          "Hôm nay bạn muốn nấu gì",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const Spacer(),
        MyIconButton(icon: Iconsax.notification, pressed: () {}),
      ],
    );
  }
}
