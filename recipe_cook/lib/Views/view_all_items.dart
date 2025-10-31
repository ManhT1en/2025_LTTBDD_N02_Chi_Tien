import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_cook/Untils/constants.dart';
import 'package:recipe_cook/Widget/food_items_display.dart';
import 'package:recipe_cook/Widget/my_icon_button.dart';
import 'package:recipe_cook/l10n/app_localizations.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final CollectionReference completeApp = FirebaseFirestore.instance.collection(
    "Recipe-cook-app",
  );
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false, // it removes the appbar back button
        elevation: 0,
        actions: [
          SizedBox(width: 15),
          MyIconButton(
            icon: Icons.arrow_back_ios_new,
            pressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          Text(
            localizations.quickEasy,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          MyIconButton(icon: Iconsax.notification, pressed: () {}),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: completeApp.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${localizations.translate('error')}: ${snapshot.error}',
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      localizations.translate('no_items_in_category'),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return GridView.builder(
                  itemCount: docs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final DocumentSnapshot doc = docs[index];
                    return Column(
                      children: [
                        FoodItemsDisplay(documentSnapshot: doc),
                        Row(
                          children: [
                            const Icon(
                              Iconsax.star_1,
                              color: Colors.amberAccent,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              doc['rating'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('/5'),
                            const SizedBox(width: 5),
                            Text(
                              '(${doc['reviews']} Reviews)',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
