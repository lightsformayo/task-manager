import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task/controllers/task_controller.dart';
import 'package:task/ui/theme.dart';
import 'package:task/ui/widgets/button.dart';
import 'package:task/ui/widgets/input_field.dart';

import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String endTime = " ";
  String startTime = " ";
  String _formatedTime = " ";
  String _selectedRepeat = "Никогда";
  List<String>repeatList = [
    "Никогда",
    "Ежедневно",
    "Раз в неделю",
    "Раз в месяц",
  ];
  int _selectedColor=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Добавить задачу", style: headingStyle,),
              MyInputField(title: "Название", hint: "Ввведите название задачи", controller: _titleController),
              MyInputField(title: "Задача", hint: "Введите задачу", controller: _noteController),
              MyInputField(
                title: "Дата", hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );
                    if (date != null)
                      setState(() {
                        _selectedDate = date;
                      });
                  },
                ),),
              Row(
                children: [
                  Expanded(child: MyInputField(title: "Начало", hint: startTime,
                      widget: IconButton(icon: Icon(
                        Icons.access_time_rounded, color: Colors.grey,),
                        onPressed: () {_getTimeFromUser(isStartTime: true);},
                      ))),
                  SizedBox(width: 12),
                  Expanded(child: MyInputField(title: "Конец", hint: endTime,
                    widget: IconButton(icon: Icon(
                      Icons.access_time_rounded, color: Colors.grey,),
                      onPressed: () {_getTimeFromUser(isStartTime: false);},
                    ),))
                ],
              ),
              MyInputField(
                title: "Повторение",
                hint: _selectedRepeat,
                widget: DropdownButton<String>(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.grey)),
                    );
                  }).toList(),
                ),
              ),
                  SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Создать задачу", onTap: ()=>_validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  _validateDate(){
    if (_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();
    }else if(_titleController.text.isEmpty||_noteController.text.isEmpty){
      Get.snackbar("Заполните поля", "Все поля пустые!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.redAccent,
      icon: Icon(Icons.warning_amber_outlined, color: Colors.redAccent)
      );
    }
  }
  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task:Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: startTime,
          endTime: endTime,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        ),
    );
    print("Мой id это "+"$value");
  }
_colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Цвет", style: titleStyle),
        SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: (){
                setState(() {
                  _selectedColor=index;
                  print("$index");
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index==0?Colors.deepPurpleAccent:index==1?Colors.indigo:Colors.blueGrey,
                  child: _selectedColor==index?Icon(Icons.done, color: Colors.white, size: 16):Container(),
                ),
              ),
            );
          }
          ),
        ),
      ],
    );
}

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.surface,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios_new),
      ),
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
   final pickedTime = await showTimePicker(
     initialEntryMode: TimePickerEntryMode.input,
     context: context,
     initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );
   _formatedTime = pickedTime!.hour.toString() + ':' + pickedTime.minute.toString();
   if (isStartTime == true){
     setState(() {
       startTime= _formatedTime;
       print(startTime.toString());
     });
   }
   else if(isStartTime == false){
     setState(() {
       endTime=_formatedTime;
       print(endTime.toString());
     });
   }
  }
}

