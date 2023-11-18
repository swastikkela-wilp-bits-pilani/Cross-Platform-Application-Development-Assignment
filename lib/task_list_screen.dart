import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Future<List<dynamic>> _fetchTasks() async {
    final ParseResponse apiResponse = await ParseObject('Task').getAll();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!;
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  void _handleTaskUpdated() {
     setState(() {});// Refresh the task list
  }

  Future<void> _showDeleteConfirmationDialog(dynamic task) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Do you really want to delete this task?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  _deleteTask(task);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _deleteTask(dynamic task) async {
      final ParseObject taskObject = ParseObject('Task')..objectId = task['objectId'];

      final ParseResponse apiResponse = await taskObject.delete();

      if (apiResponse.success) {
        _handleTaskUpdated(); // Refresh the task list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task')),
        );
      }
    }

    void _handleTaskSaved() {
      setState(() {});// Refresh the task list
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: FutureBuilder(
        future: _fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<dynamic> tasks = snapshot.data as List<dynamic>;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return ListTile(
                  title: Text(task['title']),
                  subtitle: Text(task['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task, onTaskUpdated: _handleTaskUpdated),
                      ),
                    );
                  },
                  onLongPress: () {
                    _showDeleteConfirmationDialog(task);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to AddTaskScreen when the FloatingActionButton is pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(onTaskSaved: _handleTaskSaved),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
    );
  }
}
