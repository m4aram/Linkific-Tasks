import 'package:flutter/material.dart';

class StackScreen extends StatelessWidget
{ const StackScreen({super.key});
@override Widget build(BuildContext context)
{ return Scaffold(
  appBar: AppBar( title: const Text('Stack Profile'), ),
  body: Padding( padding: const EdgeInsets.all(16), child: Column(
    children: [ SizedBox( height: 300, width: double.infinity, child:
    Stack( fit: StackFit.expand, alignment: Alignment.center, children:
    [ Container( decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),
      color: Colors.white, ), ),
  const CircleAvatar(
    radius: 55,
    child: Icon(
      Icons.person,
      size: 60,
    ),
  ),

  Positioned(
    top: 15,
    right: 15,
    child: IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.favorite,
        color: Colors.red,
      ),
    ),
  ),

  Positioned(
    bottom: 15,
    left: 15,
    right: 15,
    child: Container(
      padding: const EdgeInsets.all(10),
      child: const Text(
        'Flutter Developer',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
],
),
),

  const SizedBox(height: 20),

  Row(
    children: [
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Profile Layout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'This layout demonstrates Stack, Positioned, Alignment and Flexible widgets.',
            ),
          ],
        ),
      ),

      Flexible(
        child: Icon(
          Icons.flutter_dash,
          size: 50,
        ),
      ),
    ],
  ),
],
),
),
);
} }