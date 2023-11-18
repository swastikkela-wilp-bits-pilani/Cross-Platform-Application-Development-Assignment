import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class EditTaskScreen extends StatefulWidget {
  final dynamic task;
  final Function onTaskUpdated;

  EditTaskScreen({required this.task, required this.onTaskUpdated});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task['title'];
    _descriptionController.text = widget.task['description'];
  }

  void _updateTask() async {
    widget.task['title'] = _titleController.text;
    widget.task['description'] = _descriptionController.text;

    try {
      await _updateTaskInBackend(widget.task);
      widget.onTaskUpdated(); // Notify the TaskListScreen to refresh
      Navigator.pop(context); // Close the EditTaskScreen
    } catch (error) {
      // Handle error, show error message, etc.
      print('Error updating task: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task')),
      );
    }
  }

  Future<void> _updateTaskInBackend(dynamic task) async {
    final ParseObject taskObject = ParseObject('Task')..objectId = task['objectId'];

    // Update the task in the backend
    taskObject.set('title', task['title']);
    taskObject.set('description', task['description']);

    final ParseResponse apiResponse = await taskObject.update();

    if (!apiResponse.success) {
      throw Exception('Failed to update task in backend');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
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
              onPressed: _updateTask,
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}