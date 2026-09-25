# Flutter SharedPreferences day14

This project demonstrates how to use **SharedPreferences in Flutter** to store simple data and persist user preferences locally.

## 1. What is SharedPreferences?

**SharedPreferences** is a local key-value storage solution in Flutter. It is used to save simple data such as **app settings and user preferences** locally on the device.

## 2. Supported Data Types

SharedPreferences supports the following data types:

* String
* Int
* Bool
* Double
* StringList

In this project, examples include:

* Username
* Age
* Rating
* Login state
* Theme preference
* Language preference
* Notification settings
* Tags

## 3. Getting SharedPreferences

The application gets the SharedPreferences instance using:

```dart
SharedPreferences.getInstance()
```

This allows the application to **read and write stored preferences**.

## 4. Storing Data

The project uses the following methods to store data:

```dart
setString()
setInt()
setBool()
setDouble()
setStringList()
```

Each value is stored using a **unique key**.

## 5. Retrieving Data

The project uses the following methods to retrieve stored data:

```dart
getString()
getInt()
getBool()
getDouble()
getStringList()
```

Default values can be provided when a preference does not exist.

The application also handles **nullable values** when retrieving stored data.

## 6. Removing Data

A single stored preference can be removed using:

```dart
remove(key)
```

This removes only the selected key without affecting other stored preferences.

## 7. Clearing Data

All stored preferences can be removed using:

```dart
clear()
```

In this application, the **Clear Preferences** option resets all saved settings.

## 8. Common Use Cases

SharedPreferences can be used for:

* Remembering login state
* Saving theme preferences
* Saving language preferences
* Saving notification settings
* Storing user settings
* Detecting the first application launch

## 9. Settings Screen

The application includes a settings screen with the following options:

* Light/Dark theme
* Language selection
* Notification settings
* Login state
* Clear preferences

These settings remain saved even after **restarting the application**.

## 10. First Launch

The application includes a **first-launch preference** that can be used to determine whether the application is being opened for the first time.

The default value is:

```dart
true
```

when the preference has not been stored yet.

## 11. SharedPreferences vs Database

**SharedPreferences** is suitable for:

* Simple key-value data
* User preferences
* Application settings

A **database** is more suitable for:

* Large amounts of structured data
* Relationships between data
* Complex queries

## 12. Persistence

The stored preferences remain available after closing and reopening the application because they are saved **locally on the device using SharedPreferences**.

Therefore, SharedPreferences is useful for maintaining application settings and simple user preferences across application sessions.
