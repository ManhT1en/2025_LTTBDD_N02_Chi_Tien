import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_cook/Untils/constants.dart';
import 'package:recipe_cook/Provider/favorite_provider.dart';
import 'package:recipe_cook/l10n/app_localizations.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteItems = provider.favorites;
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          localizations.favoriteRecipes,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: favoriteItems.isEmpty
          ? Center(
              child: Text(
                localizations.noFavorites,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                String favorite = favoriteItems[index];
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final textColor = isDark ? Colors.white : Colors.black87;
                final subtleColor = isDark
                    ? Colors.grey[400]
                    : Colors.grey[600];

                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Recipe-cook-app')
                      .doc(favorite)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                        child: Text(
                          localizations.translate('recipe_not_exist'),
                        ),
                      );
                    }
                    var favoriteItem = snapshot.data!;
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        favoriteItem['image'],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        favoriteItem['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.flash_1,
                                            size: 16,
                                            color: subtleColor,
                                          ),
                                          Text(
                                            ' ${favoriteItem['calo']} Calo',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: subtleColor,
                                            ),
                                          ),
                                          Text(
                                            " • ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: subtleColor,
                                            ),
                                          ),
                                          Icon(
                                            Iconsax.clock,
                                            size: 16,
                                            color: subtleColor,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            ' ${favoriteItem['time']} Min',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: subtleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // cho nút xóa
                        Positioned(
                          top: 50,
                          right: 35,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                provider.toggleFavoriteStatus(snapshot.data!);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
