import 'dart:core';

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.repeat,
  });

 Task.fromJson(Map<String, dynamic> json){
  id = json['id'];
  title = json['title'];
  note = json['note'];
  isCompleted = json['isCompleted'];
  date = json['date'];
  startTime = json['startTime'];
  endTime = json['endTime'];
  color = json['color'];
  repeat = json['repeat'];
}


  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['repeat'] = this.repeat;
    return data;
  }
}