import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'task_list_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    final keyApplicationId = 'kPM4qzplwdVf9TQsTfzgCmNxU3u9IqIK3TPkipKM';
    final keyClientKey = 'GEb3TwGTny84MzEBzShS7NebaA5RroCjhVMDtxqc';
    final keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(), // Set the initial screen of your app here
    );
  }
}
