import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/theme_provider.dart';
import '../Provider/language_provider.dart';
import '../l10n/app_localizations.dart';
import 'team_intro_screen.dart';
import '../Untils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          localizations.settings,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSectionHeader(
            context,
            localizations.translate('appearance'),
            Icons.palette_outlined,
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            context,
            icon: Icons.dark_mode_outlined,
            title: localizations.darkMode,
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),

          // Language Section
          _buildSectionHeader(
            context,
            localizations.language,
            Icons.language_outlined,
          ),
          const SizedBox(height: 12),
          _buildLanguageOptions(context, languageProvider, localizations),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(
            context,
            localizations.translate('about'),
            Icons.info_outline,
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            context,
            icon: Icons.people_outline,
            title: localizations.translate('team'),
            subtitle: 'Hoàng Thị Linh Chi (22010099)',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TeamIntroScreen()),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            context,
            icon: Icons.info_outline,
            title: localizations.translate('version'),
            subtitle: '1.0.0',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 20, color: kPrimaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: kPrimaryColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageOptions(
    BuildContext context,
    LanguageProvider languageProvider,
    AppLocalizations localizations,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          _buildLanguageOption(
            context,
            title: localizations.vietnamese,
            subtitle: 'Tiếng Việt',
            isSelected: languageProvider.isVietnamese,
            onTap: () {
              languageProvider.changeLanguage(const Locale('vi', 'VN'));
            },
          ),
          Divider(
            height: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[200],
          ),
          _buildLanguageOption(
            context,
            title: localizations.english,
            subtitle: 'English',
            isSelected: languageProvider.isEnglish,
            onTap: () {
              languageProvider.changeLanguage(const Locale('en', 'US'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor.withOpacity(0.1)
              : (isDark ? Colors.grey[800] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.language,
          color: isSelected ? kPrimaryColor : Colors.grey,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? kPrimaryColor
              : (isDark ? Colors.white : Colors.black87),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: kPrimaryColor)
          : null,
      onTap: onTap,
    );
  }
}
