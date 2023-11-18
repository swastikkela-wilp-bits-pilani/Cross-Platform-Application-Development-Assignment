import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class AddTaskScreen extends StatefulWidget {

  final Function onTaskSaved; // Declare the callback here
  AddTaskScreen({required this.onTaskSaved});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask() async {
    final ParseObject taskObject = ParseObject('Task')
      ..set('title', _titleController.text)
      ..set('description', _descriptionController.text);

    final ParseResponse apiResponse = await taskObject.save();

    if (apiResponse.success) {
      Navigator.pop(context); // Navigate back to the task list screen
      widget.onTaskSaved(); // Notify the TaskListScreen to refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save task')),
      );
    }
  }
}
