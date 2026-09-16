#Flutter Theming App
##Overview
This project focuses on Flutter theming, Material 3, custom color palettes, light and dark modes, theme switching, and persistent theme preferences.
The application demonstrates how to create a consistent UI by defining themes centrally and accessing them throughout the application.
##ThemeData
The application uses ThemeData to define the overall appearance of the application.
The themes include:
* Primary and secondary colors
* Color scheme
* Typography
* AppBar styling
* Button themes
* Card styling
* Input field styling
* Switch styling
* Divider styling
##Custom Color Palette
The project includes a custom color palette with different color roles.
###Brand Colors
-Brand Primary
-Brand Secondary
###Semantic Colors
-Success
-Warning
-Error
###Surface Colors
-Light Surface
-Dark Surface
###Text Colors
-Light Text
-Dark Text
These colors are defined centrally in AppTheme to maintain consistent styling.
##Light Theme
The application provides a custom light theme using ThemeData.
Material 3 is enabled using:
useMaterial3: true
The light theme includes a custom ColorScheme, typography, buttons, cards, input fields, switches, AppBar, and dividers.
##Dark Theme
The application also provides a custom dark theme using ThemeData.
-The dark theme uses:
-Dark brightness
-Dark surface colors
-Light text colors
-Material 3 color scheme
-Consistent component styling
##ThemeMode
The application supports three theme modes:
-System
-Light
-Dark
ThemeMode.system allows the application to follow the device's system theme.
The selected mode is connected to MaterialApp through the themeMode property.
##Theme Switcher
The application includes a theme switcher that allows the user to:
-Toggle between light and dark mode
-Select System mode
-Select Light mode
-Select Dark mode
The theme switcher is implemented as a reusable widget in:
lib/widgets/theme_switcher.dart
##Theme Persistence
The application uses SharedPreferences to persist the selected theme mode.
The selected value is saved locally and loaded when the application starts again.
Supported saved values are:
-System
-Light
-Dark
This allows the user's theme preference to remain available after restarting the application.
##Material 3
Material 3 is enabled using:
useMaterial3: true
The project uses Material 3 concepts including:
-ColorScheme
-Color roles
-Surface colors
-Surface tint
-Material component themes
The application uses ColorScheme.fromSeed() to generate the application's color scheme from the primary brand color.
##Theme.of(context)
The application uses Theme.of(context) to access the current theme.
For example:
-Theme.of(context).colorScheme
-Theme.of(context).textTheme
This allows widgets to use the current theme's colors and text styles instead of defining separate styles repeatedly.
##Component Theming
The project defines common component styles inside ThemeData.
The themed components include:
-AppBar
-ElevatedButton
-FilledButton
-OutlinedButton
-Card
-TextField
-Switch
-Divider
This helps maintain consistent styling throughout the application.
##Project Structure
  lib/
  ├── main.dart
  ├── theme/
  │   ├── app_theme.dart
  │   └── theme_provider.dart
  ├── screens/
  │   └── home_screen.dart
  └── widgets/
    └── theme_switcher.dart
