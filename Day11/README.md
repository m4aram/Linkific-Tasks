#Day 11 - Flutter Permissions
This project demonstrates permission handling in Flutter using the permission_handler package.
##Permissions Included
* Camera
* Microphone
* Location
* Gallery / Photos
* Storage
* Contacts
##Features
* Request permissions at runtime
* Check permission status
* Request single permission
* Request multiple permissions
* Handle granted permissions
* Handle denied permissions
* Handle permanently denied permissions
* Open application settings
* Show permission rationale dialogs
##Android Configuration
Android permissions are configured in:
android/app/src/main/AndroidManifest.xml
The project includes permissions for:
* Camera
* Microphone
* Location
* Contacts
* Photos
* Storage
##iOS Configuration
iOS usage descriptions are configured in:
ios/Runner/Info.plist
The project includes usage descriptions for:
-Camera
-Microphone
-Location
-Photos
-Contacts
##Package
This project uses:
permission_handler
Documentation:
https://pub.dev/packages/permission_handler
##Testing
Each permission can be requested individually using the Request button.
The Request All Permissions button can be used to test multiple permission flows.
Permission statuses can be checked using the Check Permission Status button.
If a permission is permanently denied, the application shows a message and provides an option to open the application settings.