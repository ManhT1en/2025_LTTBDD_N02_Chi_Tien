import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_cook/Provider/favorite_provider.dart';
import 'package:recipe_cook/Untils/page_transitions.dart';
import 'package:recipe_cook/Views/recipe_detail_screen.dart';
import 'package:recipe_cook/Widget/animated_favorite_button.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          ScaleRoute(
            page: RecipeDetailScreen(documentSnapshot: documentSnapshot),
          ),
        );
      },
      child: Hero(
        tag: documentSnapshot['image'],
        child: Container(
          margin: EdgeInsets.only(right: 10),
          width: 230,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        documentSnapshot['image'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Image not available',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    documentSnapshot['name'],
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Iconsax.flash_1, size: 16, color: Colors.grey),
                      Text(
                        ' ${documentSnapshot['calo']} Calo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        " • ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Icon(Iconsax.clock, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        ' ${documentSnapshot['time']} Min',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // for favorite button with animation
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: AnimatedFavoriteButton(
                    isFavorite: provider.isExist(documentSnapshot),
                    onTap: () {
                      provider.toggleFavoriteStatus(documentSnapshot);
                    },
                    activeColor: Colors.red,
                    inactiveColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
