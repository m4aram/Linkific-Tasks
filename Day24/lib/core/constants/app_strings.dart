/// Every user-facing string lives here (one place to review or translate).
abstract final class AppStrings {
  // General
  static const String loading = 'Loading';
  static const String retry = 'Try again';
  static const String cancel = 'Cancel';
  static const String errorTitle = 'Something went wrong';

  // Errors
  static const String errorUnexpected =
      'Something went wrong. Please try again.';
  static const String errorNoInternet =
      'No internet connection. Check your network and try again.';
  static const String errorTimeout =
      'The server took too long to respond. Please try again.';
  static const String errorServer =
      'The server is having problems. Please try again later.';
  static const String errorInsecure =
      'A secure connection could not be established.';
  static const String errorSessionExpired =
      'Your session has expired. Please sign in again.';
  static const String errorCancelled = 'The request was cancelled.';
  static const String errorFavorite = 'Could not update your favourites.';
  static const String errorFavoritesLoad = 'Could not load your favourites.';

  // Auth
  static const String loginTitle = 'Welcome back';
  static const String loginSubtitle = 'Sign in to browse the catalogue';
  static const String username = 'Username';
  static const String usernameHint = 'e.g. emilys';
  static const String password = 'Password';
  static const String signIn = 'Sign in';
  static const String showPassword = 'Show password';
  static const String hidePassword = 'Hide password';
  static const String demoHint = 'Demo account: emilys / emilyspass';
  static const String logoLabel = 'ShopLite logo';
  static const String usernameRequired = 'Enter your username';
  static const String usernameInvalid =
      'Use 3-30 letters, numbers, dots, dashes or underscores';
  static const String passwordRequired = 'Enter your password';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String passwordTooLong =
      'Password must be at most 64 characters';

  // Navigation
  static const String tabProducts = 'Products';
  static const String tabFavorites = 'Favourites';
  static const String tabProfile = 'Profile';

  // Products
  static const String productsTitle = 'Products';
  static const String searchHint = 'Search products';
  static const String clearSearch = 'Clear search';
  static const String noProductsTitle = 'No products found';
  static const String noProductsMessage = 'Try a different search term.';
  static const String endOfList = 'You have reached the end';
  static const String productDetails = 'Product details';
  static const String description = 'Description';
  static const String inStock = 'In stock';
  static const String outOfStock = 'Out of stock';
  static const String addFavorite = 'Add to favourites';
  static const String removeFavorite = 'Remove from favourites';

  // Favourites
  static const String favoritesTitle = 'Favourites';
  static const String noFavoritesTitle = 'No favourites yet';
  static const String noFavoritesMessage =
      'Tap the heart on a product to save it here.';

  // Profile
  static const String profileTitle = 'Profile';
  static const String guest = 'ShopLite user';
  static const String profileOffline =
      'Profile details are unavailable offline.';
  static const String version = 'Version';
  static const String dataSource = 'Data source';
  static const String logout = 'Log out';
  static const String logoutConfirmTitle = 'Log out?';
  static const String logoutConfirmMessage =
      'You will need to sign in again to use the app.';
}
