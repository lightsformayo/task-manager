import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/services/theme_services.dart';
import 'package:task/ui/add_task_bar.dart';
import 'package:task/ui/theme.dart';
import 'package:task/ui/widgets/button.dart';
import 'package:task/ui/widgets/task_tile.dart';

import '../models/task.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: Drawer( // Add the Drawer widget
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: Text(''),
            ),
            ListTile(
              title: Text('Статистика'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, "/chartPage", (route) => false);
              },
            ),
            ListTile(
              title: Text('Выйти'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
              },
            ),
          ],
        ),
      ),
      backgroundColor: context.theme.colorScheme.surface,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          Padding(padding: EdgeInsets.only(top: 20)),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            Task task = _taskController.taskList[index];
            print(task.toJson());
            if (_checkTaskDate(task)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                            print("Щелкнуто");
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        );
      }),
    );
  }

  bool _checkTaskDate(Task task) {
    if (task.repeat == "Никогда") {
      return task.date == DateFormat.yMd().format(_selectedDate);
    } else if (task.repeat == "Ежедневно") {
      return true;
    } else if (task.repeat == "Раз в неделю") {
      return _checkWeeklyTask(task);
    } else if (task.repeat == "Раз в месяц") {
      return _checkMonthlyTask(task);
    }
    return false;
  }

  bool _checkWeeklyTask(Task task) {
    try {
      DateTime taskDate = DateFormat.yMd().parse(task.date!);
      return taskDate.weekday == _selectedDate.weekday;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool _checkMonthlyTask(Task task) {
    try {
      DateTime taskDate = DateFormat.yMd().parse(task.date!);
      return taskDate.day == _selectedDate.day;
    } catch (e) {
      print(e);
      return false;
    }
  }
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1 ?
        MediaQuery
            .of(context)
            .size
            .height * 0.24 :
        MediaQuery
            .of(context)
            .size
            .height * 0.32,
        color: Get.isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container() :
            _bottomSheetButton(label: "Завершить", onTap: () {
              _taskController.taskCompleted(task.id!);
              Get.back();
            }, clr: Colors.deepPurpleAccent, context: context),
            SizedBox(height: 10),
            _bottomSheetButton(label: "Удалить", onTap: () {
              _taskController.delete(task);
              Get.back();
            }, clr: Colors.red[400]!, context: context),
            SizedBox(height: 10),
            _bottomSheetButton(label: "Закрыть",
                onTap: () {
                  Get.back();
                },
                clr: Colors.red[400]!,
                isClose: true,
                context: context),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton(
      {required String label, required Function()? onTap, required Color clr, bool isClose = false, required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        decoration: BoxDecoration(
            color: isClose == true ? Get.isDarkMode ? Colors.grey[400] : Colors
                .grey[200] : clr,
            border: Border.all(
                width: 2, color: isClose == true ? Colors.transparent : clr),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(child: Text(label,
            style: isClose ? titleStyle : titleStyle.copyWith(
                color: Colors.white))),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.deepPurpleAccent,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(textStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(textStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(textStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMd().format(DateTime.now()),
                  style: subHeadingStyle,),
                Text("Сегодня", style: headingStyle,)
              ],
            ),
          ),
          MyButton(label: "+ Добавить", onTap: () async {
            await Get.to(() => AddTaskPage());
            _taskController.getTasks();
          }
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.surface, // Remove the existing leading widget
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
}
