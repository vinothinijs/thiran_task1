import 'package:flutter/material.dart';
import 'package:flutter_email/DatabaseHelper.dart';
import 'package:flutter_email/EmailService.dart';
import 'package:flutter_email/transactions_model.dart';
import 'package:path/path.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatched() {
  Workmanager().executeTask((task, inputData) {
    List<Transactions> errorRecords =
        DatabaseHelper.instance.getErrorRecords() as List<Transactions>;
    EmailService.SendEmailTask(errorRecords);
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatched, isInDebugMode: true);
  Workmanager().registerPeriodicTask("1", "dailyTask",
      frequency: const Duration(days: 1),
      initialDelay: const Duration(seconds: 10));

  //insert data in database
  insertData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schuduled Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Schuduled Task'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Click the button to send a email:'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Call the email service when the button is clicked
                List<Transactions> errorRecords =
                    await DatabaseHelper.instance.getErrorRecords();
                EmailService.SendEmail(errorRecords, context);
              },
              child: const Text('Send Email Now'),
            ),
          ],
        ),
      ),
    );
  }
}

//database operations
void insertData() {
  List<dynamic> jsonString = [
    {
      "TransID": 1,
      "TransDesc": "UpdateTask",
      "TransStatus": "Success",
      "TransDateTime": "12-05-2022 10:00"
    },
    {
      "TransID": 2,
      "TransDesc": "UpdateStatus",
      "TransStatus": "Pending",
      "TransDateTime": "12-05-2022 11:00"
    },
    {
      "TransID": 3,
      "TransDesc": "UpdatePerson",
      "TransStatus": "Error",
      "TransDateTime": "12-05-2022 11:02"
    },
    {
      "TransID": 4,
      "TransDesc": "UpdateTask",
      "TransStatus": "Success",
      "TransDateTime": "12-05-2022 10:00"
    },
    {
      "TransID": 5,
      "TransDesc": "UpdateStatus",
      "TransStatus": "Pending",
      "TransDateTime": "12-05-2022 11:00"
    }
  ];

  for (var jsonvalue in jsonString) {
    Transactions transaction = Transactions(
        TransID: jsonvalue['TransID'],
        TransDesc: jsonvalue['TransDesc'],
        TransStatus: jsonvalue['TransStatus'],
        TransDateTime: jsonvalue['TransDateTime']);
    DatabaseHelper.instance.insertProduct(transaction);
  }
}
