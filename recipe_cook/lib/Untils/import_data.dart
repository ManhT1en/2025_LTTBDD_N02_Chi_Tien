import 'package:cloud_firestore/cloud_firestore.dart';

class ImportData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> importFoodData() async {
    try {
      // Sample food data - Only 6 items for testing
      List<Map<String, dynamic>> foodItems = [
        {
          "name": "Pancakes",
          "category": "Breakfast",
          "calo": "250",
          "time": 15,
          "rating": 4.7,
          "reviews": 45,
          "image":
              "https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=500",
          "ingredientsName": ["Flour", "Milk", "Eggs", "Sugar"],
          "ingredientsAmount": ["200", "250", "2", "30"],
          "ingredientsImage": [
            "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=200",
            "https://images.unsplash.com/photo-1550583724-b2692b85b150?w=200",
            "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=200",
            "https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=200",
          ],
        },
        {
          "name": "Caesar Salad",
          "category": "Lunch",
          "calo": "180",
          "time": 12,
          "rating": 4.3,
          "reviews": 32,
          "image":
              "https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500",
          "ingredientsName": ["Lettuce", "Chicken", "Parmesan", "Dressing"],
          "ingredientsAmount": ["150", "100", "30", "50"],
          "ingredientsImage": [
            "https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=200",
            "https://images.unsplash.com/photo-1587593810167-a84920ea0781?w=200",
            "https://images.unsplash.com/photo-1618164436241-4473940d1f5c?w=200",
            "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?w=200",
          ],
        },
        {
          "name": "Spaghetti Carbonara",
          "category": "Dinner",
          "calo": "450",
          "time": 25,
          "rating": 4.8,
          "reviews": 67,
          "image":
              "https://images.unsplash.com/photo-1612874742237-6526221588e3?w=500",
          "ingredientsName": ["Spaghetti", "Bacon", "Eggs", "Parmesan"],
          "ingredientsAmount": ["200", "100", "3", "50"],
          "ingredientsImage": [
            "https://images.unsplash.com/photo-1551462147-37bd2b379b01?w=200",
            "https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=200",
            "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=200",
            "https://images.unsplash.com/photo-1618164436241-4473940d1f5c?w=200",
          ],
        },
        {
          "name": "Avocado Toast",
          "category": "Breakfast",
          "calo": "280",
          "time": 8,
          "rating": 4.5,
          "reviews": 36,
          "image":
              "https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=500",
          "ingredientsName": ["Avocado", "Bread", "Eggs", "Salt"],
          "ingredientsAmount": ["100", "200", "100", "5"],
          "ingredientsImage": [
            "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200",
            "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200",
            "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=200",
            "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?w=200",
          ],
        },
        {
          "name": "Burger Deluxe",
          "category": "Lunch",
          "calo": "520",
          "time": 18,
          "rating": 4.7,
          "reviews": 92,
          "image":
              "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500",
          "ingredientsName": ["Beef", "Bun", "Cheese", "Lettuce"],
          "ingredientsAmount": ["150", "1", "50", "30"],
          "ingredientsImage": [
            "https://images.unsplash.com/photo-1588347818036-8fc2d0b4bf2a?w=200",
            "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200",
            "https://images.unsplash.com/photo-1618164436241-4473940d1f5c?w=200",
            "https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=200",
          ],
        },
        {
          "name": "Pizza Margherita",
          "category": "Dinner",
          "calo": "480",
          "time": 35,
          "rating": 4.8,
          "reviews": 143,
          "image":
              "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500",
          "ingredientsName": ["Dough", "Tomato Sauce", "Mozzarella", "Basil"],
          "ingredientsAmount": ["250", "100", "150", "10"],
          "ingredientsImage": [
            "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=200",
            "https://images.unsplash.com/photo-1546548970-71785318a17b?w=200",
            "https://images.unsplash.com/photo-1618164436241-4473940d1f5c?w=200",
            "https://images.unsplash.com/photo-1628773822990-202d28662004?w=200",
          ],
        },
      ];

      // Import each item
      int successCount = 0;
      int errorCount = 0;

      for (var item in foodItems) {
        try {
          await _firestore.collection('Recipe-cook-app').add(item);
          successCount++;
          print('✅ Đã thêm: ${item['name']}');
        } catch (e) {
          errorCount++;
          print('❌ Lỗi khi thêm ${item['name']}: $e');
        }
      }

      print('\n📊 Kết quả import:');
      print('✅ Thành công: $successCount món');
      print('❌ Lỗi: $errorCount món');
      print('📦 Tổng cộng: ${foodItems.length} món');
    } catch (e) {
      print('❌ Lỗi tổng thể: $e');
    }
  }
}
