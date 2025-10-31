import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_cook/Provider/quantity.dart';
import 'firebase_options.dart';
import 'Views/app_main_screen.dart';
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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TeamIntroScreen(),
      ),
    );
  }
}
