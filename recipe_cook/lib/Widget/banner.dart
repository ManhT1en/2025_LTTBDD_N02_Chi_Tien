import 'package:flutter/material.dart';
import 'package:recipe_cook/Untils/constants.dart';

class BannertoExplore extends StatelessWidget {
  const BannertoExplore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: kBannerColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        clipBehavior: Clip.none, // cho phép tràn ra ngoài
        children: [
          // Text + nút bên trái
          Positioned(
            top: 20,
            left: 20,
            right: 140, // chừa chỗ cho ảnh bên phải
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nấu những món ngon nhất với công thức chuẩn tại nhà',
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 33),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Khám phá',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ảnh bên phải
          Positioned(
            top: -10, // tinh chỉnh cho giống mẫu
            bottom: -10,
            right: -20, // cho tràn ra khỏi thẻ
            child: Image.asset(
              'imgs/bannerChef.png',
              height: 200, // lớn hơn height container để lộ hết mũ + tay
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
