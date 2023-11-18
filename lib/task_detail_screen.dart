import 'package:flutter/material.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final dynamic task;
  final Function onTaskUpdated;

  TaskDetailScreen({required this.task, required this.onTaskUpdated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${task['title']}'),
            Text('Description: ${task['description']}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task, onTaskUpdated: onTaskUpdated),
                  ),
                );
              },
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
