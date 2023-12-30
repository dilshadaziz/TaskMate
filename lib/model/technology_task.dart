class TechnologyTasksDB {
  int? id;
  String? taskTitle;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  int? count;

  TechnologyTasksDB({
    this.id,
    this.taskTitle,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
    this.count,
  });

  static TechnologyTasksDB fromMap(Map<String, Object?> map) {
    int id = map['id'] as int;
    String taskTitle = map['tasktitle'] as String;
    int isCompleted = map['iscompleted'] as int;
    String date = map['date'] as String;
    String startTime = map['starttime'] as String;
    String endTime = map['endtime'] as String;
    int color = map['color'] as int;
    int remind = map['remind'] as int;
    String repeat = map['repeat'] as String;
    int count = map['count'] as int ;

    return TechnologyTasksDB(
     id: id,
     taskTitle: taskTitle,
     isCompleted: isCompleted,
     date: date,
     startTime: startTime,
     endTime: endTime,
     color: color,
     remind: remind,
     repeat: repeat,
     count: count,
     );
  }
}