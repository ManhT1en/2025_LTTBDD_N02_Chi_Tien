import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Home Screen
      'what_cook_today': 'What do you want to cook today?',
      'search_placeholder': 'What do you want to eat today?',
      'categories': 'Categories',
      'quick_easy': 'Quick & Easy',
      'view_all': 'View All',
      'banner_text': 'Cook the best dishes with great recipes at home',
      'explore': 'Explore',

      // Categories
      'all': 'All',
      'breakfast': 'Breakfast',
      'lunch': 'Lunch',
      'dinner': 'Dinner',

      // Food Item
      'calo': 'Calo',
      'min': 'Min',

      // Settings
      'settings': 'Settings',
      'appearance': 'Appearance',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'vietnamese': 'Vietnamese',
      'english': 'English',
      'about': 'About',
      'version': 'Version',
      'team': 'Team',

      // Team
      'team_members': 'Team Members',
      'continue_app': 'Continue to App',

      // Favorite
      'favorite_recipes': 'Favorite Recipes',
      'no_favorites': 'No favorite recipes',
      'recipe_not_exist': 'Recipe does not exist',

      // Recipe Detail
      'ingredients': 'Ingredients',
      'instructions': 'Instructions',
      'start_cooking': 'Start Cooking',
      'add_to_favorite': 'Add to Favorite',
      'how_many_servings': 'How many servings?',

      // Meal Plan
      'add_recipe': 'Add Recipe',
      'select_recipe': 'Select a Recipe',

      // Import
      'importing_data': 'Importing data...',
      'import_success': 'Import successful!',
      'import_data': 'Import Data',

      // Common
      'loading': 'Loading...',
      'error': 'Error',
      'error_loading_data': 'Error loading data',
      'no_items_in_category': 'No items in this category',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',

      // Bottom Navigation
      'nav_home': 'Home',
      'nav_favorite': 'Favorite',
      'nav_meal_plan': 'Meal Plan',
      'nav_settings': 'Settings',
    },
    'vi': {
      // Home Screen
      'what_cook_today': 'Hôm nay bạn muốn nấu gì?',
      'search_placeholder': 'Bạn muốn ăn gì hôm nay?',
      'categories': 'Danh Mục',
      'quick_easy': 'Nhanh và Dễ',
      'view_all': 'Xem tất cả',
      'banner_text': 'Nấu những món ngon nhất với công thức chuẩn tại nhà',
      'explore': 'Khám phá',

      // Categories
      'all': 'Tất cả',
      'breakfast': 'Bữa Sáng',
      'lunch': 'Bữa Trưa',
      'dinner': 'Bữa Tối',

      // Food Item
      'calo': 'Calo',
      'min': 'Phút',

      // Settings
      'settings': 'Cài Đặt',
      'appearance': 'Giao Diện',
      'dark_mode': 'Chế Độ Tối',
      'language': 'Ngôn Ngữ',
      'vietnamese': 'Tiếng Việt',
      'english': 'Tiếng Anh',
      'about': 'Thông Tin',
      'version': 'Phiên Bản',
      'team': 'Nhóm',

      // Team
      'team_members': 'Thành Viên Nhóm',
      'continue_app': 'Tiếp Tục Ứng Dụng',

      // Favorite
      'favorite_recipes': 'Món Ăn Yêu Thích',
      'no_favorites': 'Không có món ăn yêu thích',
      'recipe_not_exist': 'Món ăn không tồn tại',

      // Recipe Detail
      'ingredients': 'Nguyên Liệu',
      'instructions': 'Hướng Dẫn',
      'start_cooking': 'Bắt Đầu Nấu',
      'add_to_favorite': 'Thêm Vào Yêu Thích',
      'how_many_servings': 'Dành cho mấy người ăn?',

      // Meal Plan
      'add_recipe': 'Thêm Món Ăn',
      'select_recipe': 'Chọn Món Ăn',

      // Import
      'importing_data': 'Đang import dữ liệu...',
      'import_success': 'Import dữ liệu thành công!',
      'import_data': 'Import Dữ Liệu',

      // Common
      'loading': 'Đang tải...',
      'error': 'Lỗi',
      'error_loading_data': 'Lỗi tải dữ liệu',
      'no_items_in_category': 'Không có món ăn nào trong mục này',
      'ok': 'OK',
      'cancel': 'Hủy',
      'save': 'Lưu',
      'delete': 'Xóa',

      // Bottom Navigation
      'nav_home': 'Trang Chủ',
      'nav_favorite': 'Yêu Thích',
      'nav_meal_plan': 'Kế Hoạch',
      'nav_settings': 'Cài Đặt',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Convenience getters for common translations
  String get whatCookToday => translate('what_cook_today');
  String get searchPlaceholder => translate('search_placeholder');
  String get categories => translate('categories');
  String get quickEasy => translate('quick_easy');
  String get viewAll => translate('view_all');
  String get settings => translate('settings');
  String get darkMode => translate('dark_mode');
  String get language => translate('language');
  String get vietnamese => translate('vietnamese');
  String get english => translate('english');
  String get favoriteRecipes => translate('favorite_recipes');
  String get noFavorites => translate('no_favorites');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
