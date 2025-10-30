import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_cook/Provider/favorite_provider.dart';
import 'package:recipe_cook/Untils/constants.dart';
import 'package:recipe_cook/Widget/my_icon_button.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?>
  documentSnapshot;
  const RecipeDetailScreen({
    super.key,
    required this.documentSnapshot,
  });

  @override
  State<RecipeDetailScreen> createState() =>
      _RecipeDetailScreenState();
}

class _RecipeDetailScreenState
    extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerDocked,
      floatingActionButton:
          startCookingAndFavoriteButton(provider),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // for image
                Hero(
                  tag: widget
                      .documentSnapshot['image'],
                  child: Container(
                    height:
                        MediaQuery.of(
                          context,
                        ).size.height /
                        2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget
                              .documentSnapshot['image'],
                        ),
                      ),
                    ),
                  ),
                ),
                // for back button
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      MyIconButton(
                        icon:
                            Icons.arrow_back_ios,
                        pressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      MyIconButton(
                        icon:
                            Iconsax.notification,
                        pressed: () {},
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(
                    context,
                  ).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                            20,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            // for drag handle
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget
                        .documentSnapshot['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Iconsax.flash_1,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        ' ${widget.documentSnapshot['calo'].toString()} Calo',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        " • ",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Icon(
                        Iconsax.clock,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        ' ${widget.documentSnapshot['time'].toString()} Min',
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // cho rating
                  Row(
                    children: [
                      const Icon(
                        Iconsax.star_1,
                        color: Colors.amberAccent,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget
                            .documentSnapshot['rating']
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const Text('/5'),
                      const SizedBox(width: 5),
                      Text(
                        '(${widget.documentSnapshot['reviews'].toString()} Reviews)',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thành Phần",
                          style : TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                        Text(
                          "Dành cho mấy người ăn? ", 
                          style: TextStyle(
                            fontSize: 14, 
                            color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget startCookingAndFavoriteButton(
    FavoriteProvider provider,
  ) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 10,
              ),
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: Text(
              "Bắt đầu nấu ăn",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
            ),
            onPressed: () {
              provider.toggleFavoriteStatus(
                widget.documentSnapshot,
              );
            },
            icon: Icon(
              provider.isExist(
                    widget.documentSnapshot,
                  )
                  ? Iconsax.heart5
                  : Iconsax.heart,
              color:
                  provider.isExist(
                    widget.documentSnapshot,
                  )
                  ? Colors.red
                  : Colors.black,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
