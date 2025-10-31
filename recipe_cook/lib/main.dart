import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:recipe_cook/Provider/quantity.dart';
import 'package:recipe_cook/Provider/theme_provider.dart';
import 'package:recipe_cook/Provider/language_provider.dart';
import 'package:recipe_cook/Provider/meal_plan_provider.dart';
import 'package:recipe_cook/l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'Views/team_intro_screen.dart';
import 'Provider/favorite_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // cho san pham yeu thich
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        // cho so luong nguyen lieu
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
        // cho dark mode
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // cho ngon ngu
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        // cho meal plan
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            locale: languageProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
            home: const TeamIntroScreen(),
          );
        },
      ),
    );
  }
}
