import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task/services/theme_services.dart';
import 'package:task/ui/add_task_bar.dart';
import 'package:task/ui/theme.dart';
import '../ui/home_page.dart';

class Task {
  final String name;
  final int value;

  Task({required this.name, required this.value});
}

class StatisticsPage extends StatelessWidget {
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    int completedTasks = taskController.taskList.where((task) => task.isCompleted == 1).length;
    int totalTasks = taskController.taskList.length;
    double completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    List<Task> data = [
      Task(name: 'Выполнено', value: completedTasks),
      Task(name: 'Оставшиеся', value: totalTasks - completedTasks),
    ];

    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: _appBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Выполненные задачи: $completedTasks', style: titleStyle,),
              Text('Все задачи: $totalTasks', style: titleStyle,),
              Text('Процент выполнения: ${completionRate.toStringAsFixed(2)}', style: titleStyle),
              SizedBox(height: 20),
              Container(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<Task, String>(
                      dataSource: data,
                      xValueMapper: (Task task, _) => task.name,
                      yValueMapper: (Task task, _) => task.value,
                      color: Colors.deepPurpleAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      initialRoute: '/',
        routes: {
          '/home': (context) => HomePage(),
          '/chartPage': (context) => StatisticsPage(),
        }
    );
  }
}
   _appBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.surface,
      leading: Builder(
      builder: (BuildContext context) {
      return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (route) => false);
      },
      );
      },
      ),
      actions: [
      GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons
                .nightlight_outlined,
            size: 25,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    ],
  );
}