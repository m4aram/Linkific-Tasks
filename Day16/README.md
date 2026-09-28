Firebase Authentication in Flutter
Task

Implement Firebase Authentication in a Flutter application, including email/password authentication, Google Sign-In, authentication state management, and user profile display.

1. Firebase Setup
   Created a Firebase project.
   Added the Android application.
   Configured Firebase with the Flutter project.
   Added google-services.json.
   Configured Firebase using FlutterFire.
   Configured Android Firebase settings.
   Added Firebase dependencies.
   Dependencies
   firebase_core
   firebase_auth
   google_sign_in
2. Firebase Initialization

Firebase is initialized when the application starts using:

await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
3. Email & Password Authentication
   Register

Implemented user registration using:

createUserWithEmailAndPassword()
Login

Implemented user login using:

signInWithEmailAndPassword()
Logout

Implemented logout using:

signOut()
4. Error Handling

Firebase authentication errors are handled using:

FirebaseAuthException

The following cases were tested:

Invalid email
Incorrect password
Existing email
Password mismatch
5. Google Sign-In

Google authentication was implemented using:

google_sign_in
firebase_auth

The Google account is authenticated and connected with Firebase Authentication.

Google Sign-In was successfully tested on the Android emulator.

6. Authentication State

The application uses:

FirebaseAuth.instance.authStateChanges()

The application listens for authentication changes and navigates the user based on their authentication state:

If the user is authenticated → Home screen.
If the user is not authenticated → Login screen.
7. User Profile

The authenticated user's information is displayed in the Home screen.

The displayed information includes:

User name
User email
8. Testing

The following authentication flows were tested successfully:

Create account
Login with email/password
Logout
Invalid email
Incorrect password
Existing email
Password mismatch
Google Sign-In
Authentication state changes
User profile information
9. Project Structure
   lib/
   ├── main.dart
   ├── firebase_options.dart
   ├── services/
   │   └── auth_service.dart
   └── screens/
   ├── auth/
   │   ├── login_screen.dart
   │   └── register_screen.dart
   └── home_screen.dart
10. How to Run
    Install the project dependencies:
    flutter pub get
    Run the application:
    flutter run
11. Result

Firebase Authentication was successfully integrated into the Flutter application with:

Email/password authentication
Google Sign-In
Authentication state management
Logout functionality
User information display