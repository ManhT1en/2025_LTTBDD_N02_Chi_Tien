import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_cook/Provider/favorite_provider.dart';
import 'package:recipe_cook/Untils/page_transitions.dart';
import 'package:recipe_cook/Views/recipe_detail_screen.dart';
import 'package:recipe_cook/Widget/animated_favorite_button.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?>
  documentSnapshot;
  // Optional width so the widget can adapt: horizontal lists use a fixed
  // width, grid tiles can expand to the available width.
  final double? width;
  const FoodItemsDisplay({
    super.key,
    required this.documentSnapshot,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;
    final textColor = isDark
        ? Colors.white
        : Colors.black87;
    final subtle = isDark
        ? Colors.grey[400]
        : Colors.grey[600];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          ScaleRoute(
            page: RecipeDetailScreen(
              documentSnapshot: documentSnapshot,
            ),
          ),
        );
      },
      child: Hero(
        tag: documentSnapshot['image'],
        child: Container(
          margin: EdgeInsets.only(right: 10),
          // If width is provided, use it. Otherwise default to the previous
          // behavior (230) for horizontal carousels.
          width: width ?? 230,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                      child: Image.network(
                        documentSnapshot['image'],
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (
                              context,
                              child,
                              loadingProgress,
                            ) {
                              if (loadingProgress ==
                                  null)
                                return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress
                                              .expectedTotalBytes !=
                                          null
                                      ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress
                                                .expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Icon(
                                  Icons
                                      .broken_image,
                                  size: 50,
                                  color:
                                      Colors.grey,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Image not available',
                                  style: TextStyle(
                                    color: Colors
                                        .grey,
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
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Iconsax.flash_1,
                        size: 16,
                        color: subtle,
                      ),
                      Text(
                        ' ${documentSnapshot['calo']} Calo',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                          color: subtle,
                        ),
                      ),
                      Text(
                        " • ",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                          color: subtle,
                        ),
                      ),
                      Icon(
                        Iconsax.clock,
                        size: 16,
                        color: subtle,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        ' ${documentSnapshot['time']} Min',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                          color: subtle,
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
                  backgroundColor:
                      theme.cardColor,
                  child: AnimatedFavoriteButton(
                    isFavorite: provider.isExist(
                      documentSnapshot,
                    ),
                    onTap: () {
                      provider
                          .toggleFavoriteStatus(
                            documentSnapshot,
                          );
                    },
                    activeColor: Colors.red,
                    inactiveColor:
                        theme.iconTheme.color ??
                        Colors.black,
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
