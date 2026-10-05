# Flutter Package Explorer

A practical Flutter project created to explore popular Flutter packages,
understand when to use them, and implement common Flutter features through
working examples.

The project combines multiple packages in one Flutter application and
provides practical demonstrations and comparisons with common alternatives.

---

# Task Requirements

This project was created according to the following learning task:

- Explore popular Flutter packages.
- Learn the GetX framework.
- Learn and implement five recommended packages.
- Explore useful utility packages.
- Build one application using three or more packages together.
- Demonstrate the main features of each package.
- Compare packages with common alternatives.
- Document package recommendations and implementation details.

## Requirements Completion

| Requirement | Status |
|---|---|
| Watch package tutorials / research packages | Completed |
| Learn GetX | Completed |
| Learn Freezed | Completed |
| Learn GoRouter | Completed |
| Learn Dio | Completed |
| Learn Hive | Completed |
| Explore utility packages | Completed |
| Use 3+ packages in one application | Completed |
| Demonstrate each package | Completed |
| Compare packages with alternatives | Completed |
| Build GetX example | Completed |
| Build Dio HTTP example | Completed |
| Build Hive database example | Completed |
| Create package comparison documentation | Completed |
| Provide package recommendations | Completed |
| README documentation | Completed |

---

# Learning Objectives

The main learning objectives of this project were:

- Explore popular Flutter packages.
- Understand how third-party packages can simplify Flutter development.
- Learn the GetX framework for state management, dependency injection,
  and navigation.
- Learn how Freezed can simplify immutable data models.
- Learn GoRouter for declarative application navigation.
- Learn Dio for advanced HTTP communication.
- Learn Hive for local NoSQL storage.
- Explore useful utility packages.
- Compare different packages and understand when each package is appropriate.
- Build practical examples instead of only studying package documentation.

---

# Packages Covered

## 1. GetX

GetX is demonstrated for:

- State management.
- Reactive state using `.obs`.
- Reactive UI updates using `Obx`.
- Dependency injection using `Get.put()`.
- Retrieving dependencies using `Get.find()`.
- Navigation between screens.
- Returning to the previous screen.

### Example

The GetX screen contains:

- A reactive counter.
- Increment and decrement buttons.
- A selected package value.
- Reactive package selection.
- Dependency injection example.
- Navigation to a details screen.
- Back navigation.

Example reactive state:

```dart
final RxInt count = 0.obs;
