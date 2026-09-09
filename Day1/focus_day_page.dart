import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
class FocusDayPage extends StatefulWidget
{ const FocusDayPage({super.key});
@override State<FocusDayPage> createState() => _FocusDayPageState(); }
class _FocusDayPageState extends State<FocusDayPage>
{ final List<Map<String, dynamic>> tasks =
[ {'title': 'Morning Exercise', 'completed': false},
  {'title': 'Study Flutter', 'completed': false},
  {'title': 'Work on Project', 'completed': false},
  {'title': 'Read for 30 Minutes', 'completed': false}, ];
void toggleTask(int index) { setState(() { tasks[index]['completed']
= !tasks[index]['completed']; }); }
@override Widget build(BuildContext context)
{ final completedTasks = tasks.where((task) => task['completed'] == true).length;
return Scaffold(
  appBar: AppBar(
    title: const Text('Focus Day'),
    centerTitle: true,
  ),
  body: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today’s Tasks',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('$completedTasks of ${tasks.length} tasks completed'),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(
                title: tasks[index]['title'],
                completed: tasks[index]['completed'],
                onChanged: (_) => toggleTask(index),
              );
            },
          ),
        ),
      ],
    ),
  ),
);
} }