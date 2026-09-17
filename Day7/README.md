Day 7 – Flutter State Management

This project demonstrates Flutter state management using StatefulWidget and setState() to build interactive user interfaces.

Learning Objectives

● Understand state in Flutter
● Understand local and app-wide state concepts
● Understand ephemeral state
● Know when to use setState()
● Handle user interactions
● Build interactive UIs

State Concepts Covered

What is State?

State is information that can change while the application is running and can affect the UI.

Local State

Local state belongs to a specific widget or screen, such as:

● Counter value
● Todo completion state
● Form state
● Calculator display
● Quiz score

Ephemeral State

Ephemeral state is short-lived UI state that can be managed locally inside a StatefulWidget.

setState()

setState() tells Flutter that state has changed and the widget should rebuild.

StatefulWidget

The project demonstrates:

● StatefulWidget
● createState()
● State lifecycle
● initState()
● build()
● dispose()
● didUpdateWidget()

User Interactions

● Button clicks
● Text input changes
● Toggle switches
● List item interactions
● Form submission
● Search and filtering
● Calculator operations
● Quiz answer selection

Form State Management

● TextEditingController
● FocusNode
● Focus management
● Form and GlobalKey<FormState>
● Form validation
● Submit handling
● Switch state
● State changes

List State Management

● Add items
● Read/display items
● Update items
● Delete items
● Toggle completed state
● Search
● Filter

5 Interactive Applications

1. Counter App

● Increment
● Decrement
● Reset
● State updates using setState()

2. Todo List

● Add tasks
● Display tasks
● Edit tasks
● Delete tasks
● Toggle completed state
● Search tasks
● Filter: All, Pending, Completed
● CRUD operations

3. Interactive Form

● Name input
● Email input
● TextEditingController
● FocusNode
● Focus movement
● Validation
● Submit handling
● Notification toggle
● Submitted result

4. Calculator App

● Number input
● Decimal input
● Addition
● Subtraction
● Multiplication
● Division
● Clear
● Division-by-zero handling
● Interactive UI using setState()

5. Quiz App

● Multiple questions
● Answer selection
● Answer result
● Score tracking
● Next question
● Final score
● Restart quiz

State Lifecycle

initState()

Used to initialize state and resources when the State object is created.

build()

Builds the widget UI based on the current state.

didUpdateWidget()

Demonstrated in the TodoItem widget to respond when widget configuration changes.

dispose()

Used to clean up resources such as TextEditingController and FocusNode.

Project Structure

lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── counter_screen.dart
│   ├── todo_screen.dart
│   ├── form_screen.dart
│   ├── calculator_screen.dart
│   └── quiz_screen.dart
└── widgets/
├── todo_item.dart
├── custom_text_field.dart
└── answer_button.dart

Technologies

● Flutter
● Dart
● StatefulWidget
● setState
● Material 3
● Android Emulator
● Android Studio
● Visual Studio Code

Running the Project

flutter pub get
flutter run

Day 7 Deliverables

● 4+ interactive Flutter apps
● Counter with setState()
● Todo List with CRUD
● Form with state management
● Calculator App
● Quiz with score
● README explaining state concepts