import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        margin: EdgeInsets.only(right: 10), 
        width: 230, 
        child: Stack(
          children: [
            Container(
              width: double.infinity, 
              height: 160, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), 
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    documentSnapshot['image'] //image từ firestore
                  ), 
                ),
              ),
            ),
            SizedBox(height: 10), 
            Text(documentSnapshot['name'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Iconsax.flash_1,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}