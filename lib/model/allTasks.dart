class AllTasksDB {
  String? category;
  String? taskTitle;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  int? count;

  AllTasksDB({
    this.category,
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

   factory AllTasksDB.fromMap(Map<String, dynamic> map) {
    String category = map['category'] as String;
    String taskTitle = map['tasktitle'] as String;
    int isCompleted = map['iscompleted'] as int;
    String date = map['date'] as String;
    String startTime = map['starttime'] as String;
    String endTime = map['endtime'] as String;
    int color = map['color'] as int;
    int remind = map['remind'] as int;
    String repeat = map['repeat'] as String;
    int count = map['count'] as int ;

    return AllTasksDB(
      category: category,
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