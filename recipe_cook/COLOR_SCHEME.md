# Recipe Cook App - Color Scheme Documentation

## Unified Color Constants

All colors in the app are now centralized in `lib/Untils/constants.dart` for consistency and easy maintenance.

### Primary Colors

- **kPrimaryColor** = `Color(0xFFF54748)` - Main red accent color
  - Used for: buttons, active states, selected items, icons, borders
  
- **kSecondaryColor** = `Color(0xFFFF6B6B)` - Light red
  - Used for: secondary accents, hover states
  
- **kBannerColor** = `Color(0xff579f8c)` - Teal green
  - Used for: home banner background

### Background Colors

- **kBackgroundColor** = `Color(0xFFF5F5F5)` - Light gray
  - Used for: light mode scaffold background
  
- **kDarkBackground** = `Color(0xFF121212)` - Dark gray
  - Used for: dark mode scaffold background
  
- **kDarkSurface** = `Color(0xFF1E1E1E)` - Medium dark gray
  - Used for: dark mode cards and surfaces

## Where Colors Are Applied

### Theme Provider (`lib/Provider/theme_provider.dart`)
- Light theme uses: kPrimaryColor, kSecondaryColor, kBackgroundColor
- Dark theme uses: kPrimaryColor, kSecondaryColor, kDarkBackground, kDarkSurface

### Settings Screen (`lib/Views/settings_screen.dart`)
- Switch active color: kPrimaryColor
- Section header icons: kPrimaryColor
- Setting card icons and backgrounds: kPrimaryColor with opacity
- Language selection: kPrimaryColor

### Meal Plan Screen (`lib/Views/meal_plan_screen.dart`)
- Selected date background: kPrimaryColor
- Date border for today: kPrimaryColor
- Meal type icons: kPrimaryColor
- Add recipe button: kPrimaryColor

### Banner Widget (`lib/Widget/banner.dart`)
- Background: kBannerColor

## Migration Notes

### Deprecated Colors (for backward compatibility)
- `kbackgroundcolor` → Use `kBackgroundColor` instead
- `kprimaryColor` → Use `kPrimaryColor` instead

These deprecated colors are marked with `@Deprecated()` annotation and should not be used in new code.

## Benefits of Unified Color Scheme

1. **Consistency**: Same colors used throughout the app
2. **Maintainability**: Change colors in one place (constants.dart)
3. **Theme Support**: Seamless integration with light/dark modes
4. **Type Safety**: Using const Color objects prevents typos
5. **Code Readability**: Named constants are more descriptive than hex codes

## How to Use

```dart
// Import the constants file
import '../Untils/constants.dart';

// Use the color constants
Container(
  color: kPrimaryColor,
  child: Icon(Icons.add, color: kPrimaryColor),
)

// With opacity
Container(
  color: kPrimaryColor.withOpacity(0.1),
)
```

## Future Improvements

Consider adding more semantic color names:
- `kErrorColor` - for error states
- `kSuccessColor` - for success messages
- `kWarningColor` - for warnings
- `kTextPrimary` - primary text color
- `kTextSecondary` - secondary text color
