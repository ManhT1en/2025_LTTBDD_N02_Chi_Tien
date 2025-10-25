import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_cook/Untils/constants.dart';
import 'package:recipe_cook/Widget/banner.dart';
import 'package:recipe_cook/Widget/my_icon_button.dart';


class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});
  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundcolor,
      body: SafeArea(
        child: SingleChildScrollView(      
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    headerParts(),
                    mySearchBar(),
                    //for banner
                    BannertoExplore()
                  ],
                ),
              )
            ],
          ),

      )),
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
                        hintStyle: TextStyle(color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                          
                      )
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
                      MyIconButton(
                        icon: Iconsax.notification, 
                        pressed: (){},),
                    ],
                  );
  }
}