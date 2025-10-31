import 'package:flutter/material.dart';
import 'package:recipe_cook/Untils/constants.dart';
import 'package:recipe_cook/Untils/page_transitions.dart';
import 'package:recipe_cook/Views/app_main_screen.dart';
import 'package:recipe_cook/l10n/app_localizations.dart';

class TeamIntroScreen extends StatelessWidget {
  const TeamIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Title
              Text(
                localizations.translate('team_members'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Team Members List
              Expanded(
                child: ListView(
                  children: [
                    _buildTeamMember(
                      name: 'Hoàng Thị Linh Chi',
                      studentId: 'MSSV: 22010099',
                    ),
                    const SizedBox(height: 20),
                    _buildTeamMember(
                      name: 'Nguyễn Mạnh Tiến',
                      studentId: 'MSSV: 22010151',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      FadeRoute(page: const AppMainScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    localizations.translate('continue_app'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember({required String name, required String studentId}) {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(height: 3),
                    Text(
                      studentId,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
