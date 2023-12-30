// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmate/model/allTasks.dart';
import 'package:taskmate/model/category.dart';
import 'package:taskmate/model/education_task.dart';
import 'package:taskmate/model/fashion_task.dart';
import 'package:taskmate/model/finance_task.dart';
import 'package:taskmate/model/food_task.dart';
import 'package:taskmate/model/health_task.dart';
import 'package:taskmate/model/home_task.dart';
import 'package:taskmate/model/personal_task.dart';
import 'package:path/path.dart';
import 'package:taskmate/model/profile.dart';
import 'package:taskmate/model/social_task.dart';
import 'package:taskmate/model/sports_task.dart';
import 'package:taskmate/model/technology_task.dart';
import 'package:taskmate/model/travel_task.dart';
import 'package:taskmate/model/work_task.dart';

// ValueNotifier for managing a list of categories
ValueNotifier<List<Category>> categoryList = ValueNotifier([]);
ValueNotifier<List<PTasksDB>> dbTasksList = ValueNotifier([]);
ValueNotifier<List<WorkTasksDB>> dbWorksList = ValueNotifier([]);
ValueNotifier<List<HealthTasksDB>> dbHealthList = ValueNotifier([]);
ValueNotifier<List<SocialTasksDB>> dbSocialList = ValueNotifier([]);
ValueNotifier<List<TechnologyTasksDB>> dbTechnologyList = ValueNotifier([]);
ValueNotifier<List<EducationTasksDB>> dbEducationList = ValueNotifier([]);
ValueNotifier<List<FashionTasksDB>> dbFashionList = ValueNotifier([]);
ValueNotifier<List<FinanceTasksDB>> dbFinanceList = ValueNotifier([]);
ValueNotifier<List<TravelTasksDB>> dbTravelList = ValueNotifier([]);
ValueNotifier<List<FoodTasksDB>> dbFoodList = ValueNotifier([]);
ValueNotifier<List<SportsTasksDB>> dbSportsList = ValueNotifier([]);
ValueNotifier<List<HomeTasksDB>> dbHomeList = ValueNotifier([]);
ValueNotifier<List<ProfileDetailsDB>> dbProfileList = ValueNotifier([]);
ValueNotifier<List<AllTasksDB>> dbAllTasksList = ValueNotifier([]);

class DBHelper {
  // A static reference to the database
  static late Database _db;

  // Initialize and open the database
  static Future<void> initializeDatabase() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create necessary tables
        _createCategoryTable(db);
        _createTaskTables(db);
        _createProfileTable(db);
      },
    );
    debugPrint('Database created...');
  }

  // Create the 'category' table
  static void _createCategoryTable(Database db) {
    db.execute('CREATE TABLE category(id INTEGER PRIMARY KEY, title TEXT)');
  }

  // Create task-related tables
  static void _createTaskTables(Database db) {
    for (String tableName in [
      'personal',
      'work',
      'health',
      'social',
      'technology',
      'education',
      'fashion',
      'finance',
      'travel',
      'food',
      'sports',
      'home',
      'alltasks',
    ]) {
      if (tableName == 'alltasks') {
        db.execute(
          'CREATE TABLE $tableName(category TEXT,tasktitle TEXT, '
          'iscompleted INTEGER, date TEXT, starttime TEXT, endtime TEXT, '
          'color INTEGER, remind INTEGER, repeat TEXT, count INTEGER)',
        );
      } else {
        db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, tasktitle TEXT, '
          'iscompleted INTEGER, date TEXT, starttime TEXT, endtime TEXT, '
          'color INTEGER, remind INTEGER, repeat TEXT, count INTEGER)',
        );
      }
    }
  }

  // Create profile Table
  static void _createProfileTable(Database db) {
    String tableName = "profile";
    db.execute(
      'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, fullname TEXT, '
      'email TEXT, phonenumber TEXT, gender TEXT, imagex TEXT)',
    );
  }

  //Read Profile Datas from Database
  static Future<void> getProfile() async {
    final result = await _db.rawQuery('SELECT * FROM profile');
    debugPrint('Profile Data : $result');
    dbProfileList.value.clear();
    for (var map in result) {
      final profile = ProfileDetailsDB.fromMap(map);
      dbProfileList.value.add(profile);
    }
    //Notify Listeners after updating values
    dbProfileList.notifyListeners();
  }

  // Read Categories from the Database
  static Future<void> getCategory() async {
    final result = await _db.rawQuery('SELECT * FROM category');
    debugPrint("CATEGORY DATA: $result");
    categoryList.value.clear();
    for (var map in result) {
      final category = Category.fromMap(map);
      categoryList.value.add(category);
    }
    // Notify listeners that the category list has changed
    categoryList.notifyListeners();
  }

  // Insert a new category into the Database
  static Future<void> insertToCategory(Category categoryData) async {
    try {
      await _db.rawInsert(
        'INSERT INTO category(title) VALUES(?)',
        [categoryData.title],
      );
      // Update the category list after insertion
      getCategory();
    } catch (e) {
      debugPrint('Error inserting data: $e');
    }
  }

  // Delete a Category from the Database
  static Future<void> deleteCategory(id) async {
    await _db.delete('category', where: 'id=?', whereArgs: [id]);
    // Update the category list after deletion
    getCategory();
  }

// ------- CATEGORY TABLE SESSION IS ENDED ------- //

// Read Peronal Tasks from the Database
    static Future<void> getPersonal() async {
      final result = await _db.rawQuery('SELECT * FROM personal');
      debugPrint("TASKS DATA: $result");
      dbTasksList.value.clear();
      for (var map in result) {
        final tasks = PTasksDB.fromMap(map);
        dbTasksList.value.add(tasks);
      }
      // Notify listeners that the tasks list has changed
      dbTasksList.notifyListeners();

      await getAllTasks();
    }

// Read work tasks from the Database
  static Future<void> getWorks() async {
    final result = await _db.rawQuery('SELECT * FROM work');
    debugPrint("work DATA: $result");
    dbWorksList.value.clear();
    for (var map in result) {
      final tasks = WorkTasksDB.fromMap(map);
      dbWorksList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbWorksList.notifyListeners();

    await getAllTasks();
  }

// Read Health Tasks from the Database
  static Future<void> getHealth() async {
    final result = await _db.rawQuery('SELECT * FROM health');
    debugPrint("TASKS DATA: $result");
    dbHealthList.value.clear();
    for (var map in result) {
      final tasks = HealthTasksDB.fromMap(map);
      dbHealthList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbHealthList.notifyListeners();

    await getAllTasks();
  }

// Read Social Tasks from the Database
  static Future<void> getSocial() async {
    final result = await _db.rawQuery('SELECT * FROM social');
    debugPrint("SOCIAL TASKS DATA: $result");
    dbSocialList.value.clear();
    for (var map in result) {
      final tasks = SocialTasksDB.fromMap(map);
      dbSocialList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbSocialList.notifyListeners();

    await getAllTasks();
  }

  // Insert a new Personal Task into the Database
  static Future<void> insertToPersonal(PTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO personal(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);

      //     await _db.rawInsert(
      //   'INSERT OR REPLACE INTO alltasks(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) FROM work'
      // );
      // Update the personal task list after insertion
      getPersonal();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  static Future<void> insertToWorkTask(WorkTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO work(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);

      // Update the tasks list after insertion
      getWorks();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

// Insert a new Personal Task into the Database
  static Future<void> insertToHealth(HealthTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO health(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the personal task list after insertion
      getHealth();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

// Insert a new Personal Task into the Database
  static Future<void> insertToSocial(SocialTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO social(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the personal task list after insertion
      getSocial();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Delete a Task from the Database
  static Future<void> deletePersonal(id) async {
    await _db.delete('personal', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getPersonal();
  }

// Delete a Work from the Database
  static Future<void> deleteWork(id) async {
    await _db.delete('work', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getWorks();
  }

// Delete a Work from the Database
  static Future<void> deleteHealth(id) async {
    await _db.delete('health', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getHealth();
  }

// Delete a Work from the Database
  static Future<void> deleteSocial(id) async {
    await _db.delete('social', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getSocial();
  }

// Update Personal task from Database
  static Future<void> updatePersonalTask(PTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE personal SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getPersonal();
  }

// Update Personal task from Database
  static Future<void> updateWorkTask(WorkTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE work SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getWorks();
  }

// Update Personal task from Database
  static Future<void> updateHealthTask(HealthTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE health SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getHealth();
  }

// Update Personal task from Database
  static Future<void> updateSocialTask(SocialTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE social SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getSocial();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedPersonalTasks(id) async {
    await _db
        .rawUpdate('UPDATE personal SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getPersonal();
  }

  // Update isCompleted to TRUE in WORK
  static Future<void> updateCompletedWorkTasks(id) async {
    await _db.rawUpdate('UPDATE work SET iscompleted=? WHERE id=?', [1, id]);
    // Update the work list after changing
    getWorks();
  }

  // Update isCompleted to TRUE in WORK
  static Future<void> updateCompletedHealthTasks(id) async {
    await _db.rawUpdate('UPDATE health SET iscompleted=? WHERE id=?', [1, id]);
    // Update the work list after changing
    getHealth();
  }

  // Update isCompleted to TRUE in WORK
  static Future<void> updateCompletedSocialTasks(id) async {
    await _db.rawUpdate('UPDATE social SET iscompleted=? WHERE id=?', [1, id]);
    // Update the work list after changing
    getSocial();
  }

  // static Future<void> clearSocial() async {
  //   await _db.delete('social');
  //   getSocial();
  // }

  // Clear the entire Database
  static Future<void> clearDatabase() async {
    await deleteDatabase("my_database.db");
  }

  static Future<void> completedCountIncrement(String categoryname) async {
    switch (categoryname) {
      case 'Personal':
        await _db.rawUpdate('UPDATE personal SET count = count + 1');
        getPersonal();
        break;
      case 'Work':
        await _db.rawUpdate('UPDATE work SET count = count +1');
        getWorks();
        break;
      case 'Health':
        await _db.rawUpdate('UPDATE health SET count = count +1');
        getHealth();
        break;
      case 'Social':
        await _db.rawUpdate('UPDATE social SET count = count +1');
        getSocial();
        break;
      case 'Technology':
        await _db.rawUpdate('UPDATE technology SET count = count +1');
        getTechnology();
        break;
      case 'Education':
        await _db.rawUpdate('UPDATE education SET count = count +1');
        getEducation();
        break;
      case 'Fashion':
        await _db.rawUpdate('UPDATE fashion SET count = count +1');
        getFashion();
        break;
      case 'Finance':
        await _db.rawUpdate('UPDATE finance SET count = count +1');
        getFinance();
        break;
      case 'Travel':
        await _db.rawUpdate('UPDATE travel SET count = count +1');
        getTravel();
        break;
      case 'Food':
        await _db.rawUpdate('UPDATE food SET count = count +1');
        getFood();
        break;
      case 'Sports':
        await _db.rawUpdate('UPDATE sports SET count = count +1');
        getSports();
        break;
      case 'Home':
        await _db.rawUpdate('UPDATE home SET count = count +1');
        getHome();
        break;
      default:
    }
  }

  static Future<void> completedCountDecrement(String categoryname) async {
    switch (categoryname) {
      case 'Personal':
        await _db.rawUpdate('UPDATE personal SET count = count -1');
        getPersonal();
        break;
      case 'Work':
        await _db.rawUpdate('UPDATE work SET count = count -1');
        getWorks();
        break;
      case 'Health':
        await _db.rawUpdate('UPDATE health SET count = count -1');
        getHealth();
        break;
      case 'Social':
        await _db.rawUpdate('UPDATE social SET count = count -1');
        getSocial();
        break;
      case 'Technology':
        await _db.rawUpdate('UPDATE technology SET count = count -1');
        getTechnology();
        break;
      case 'Education':
        await _db.rawUpdate('UPDATE education SET count = count -1');
        getEducation();
        break;
      case 'Fashion':
        await _db.rawUpdate('UPDATE fashion SET count = count -1');
        getFashion();
        break;
      case 'Finance':
        await _db.rawUpdate('UPDATE finance SET count = count -1');
        getFinance();
        break;
      case 'Travel':
        await _db.rawUpdate('UPDATE travel SET count = count -1');
        getTravel();
        break;
      case 'Food':
        await _db.rawUpdate('UPDATE food SET count = count -1');
        getFood();
        break;
      case 'Sports':
        await _db.rawUpdate('UPDATE sports SET count = count -1');
        getSports();
        break;
      case 'Home':
        await _db.rawUpdate('UPDATE home SET count = count -1');
        getHome();
        break;
      default:
    }
  }

  static Future<void> insertToProfile() async {
    await _db.rawInsert(
        'INSERT INTO profile(fullname,email,phonenumber,gender,imagex) VALUES("null","null","null","null", "null")');
    getProfile();
  }

  static Future<void> updateProfile(ProfileDetailsDB profileData) async {
    await _db.rawUpdate(
        "UPDATE profile SET fullname = ?, email = ?, phonenumber = ?, gender = ?, imagex = ?",
        [
          profileData.fullName,
          profileData.eMail,
          profileData.phoneNumber,
          profileData.gender,
          profileData.imagex
        ]);
    getProfile();
  }

  static Future<void> getTechnology() async {
    final result = await _db.rawQuery('SELECT * FROM technology');
    debugPrint("Technology TASKS DATA: $result");
    dbTechnologyList.value.clear();
    for (var map in result) {
      final tasks = TechnologyTasksDB.fromMap(map);
      dbTechnologyList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbTechnologyList.notifyListeners();

    await getAllTasks();
  }

  static Future<void> insertToTechnology(TechnologyTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO technology(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the technology task list after insertion
      getTechnology();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Update Technology task from Database
  static Future<void> updateTechnologyTask(TechnologyTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE technology SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getTechnology();
  }

// Delete a Work from the Database
  static Future<void> deleteTechnology(id) async {
    await _db.delete('technology', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getTechnology();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedTechnologyTasks(id) async {
    await _db
        .rawUpdate('UPDATE technology SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getTechnology();
  }

  static Future<void> getEducation() async {
    final result = await _db.rawQuery('SELECT * FROM education');
    debugPrint("Education TASKS DATA: $result");
    dbEducationList.value.clear();
    for (var map in result) {
      final tasks = EducationTasksDB.fromMap(map);
      dbEducationList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbEducationList.notifyListeners();

    await getAllTasks();
  }

  static Future<void> insertToEducation(EducationTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO education(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the technology task list after insertion
      getEducation();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Update Technology task from Database
  static Future<void> updateEducationTask(EducationTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE education SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getEducation();
  }

  // Delete a Work from the Database
  static Future<void> deleteEducation(id) async {
    await _db.delete('education', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getEducation();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedEducationTasks(id) async {
    await _db
        .rawUpdate('UPDATE education SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getEducation();
  }

  static Future<void> getFashion() async {
    final result = await _db.rawQuery('SELECT * FROM fashion');
    debugPrint("Fashion TASKS DATA: $result");
    dbFashionList.value.clear();
    for (var map in result) {
      final tasks = FashionTasksDB.fromMap(map);
      dbFashionList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbFashionList.notifyListeners();

    await getAllTasks();
  }

  static Future<void> insertToFashion(FashionTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO fashion(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the technology task list after insertion
      getFashion();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Update Technology task from Database
  static Future<void> updateFashionTask(FashionTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE fashion SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getFashion();
  }

  // Delete a Work from the Database
  static Future<void> deleteFashion(id) async {
    await _db.delete('fashion', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getFashion();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedFashionTasks(id) async {
    await _db.rawUpdate('UPDATE fashion SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getFashion();
  }

  static Future<void> getFinance() async {
    final result = await _db.rawQuery('SELECT * FROM finance');
    debugPrint("Finance TASKS DATA: $result");
    dbFinanceList.value.clear();
    for (var map in result) {
      final tasks = FinanceTasksDB.fromMap(map);
      dbFinanceList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbFinanceList.notifyListeners();

    await getAllTasks();
  }

  static Future<void> insertToFinance(FinanceTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO finance(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the technology task list after insertion
      getFinance();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Update Technology task from Database
  static Future<void> updateFinanceTask(FinanceTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE finance SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getFinance();
  }

  // Delete a Work from the Database
  static Future<void> deleteFinance(id) async {
    await _db.delete('finance', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getFinance();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedFinanceTasks(id) async {
    await _db.rawUpdate('UPDATE finance SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getFinance();
  }

  static Future<void> getTravel() async {
    final result = await _db.rawQuery('SELECT * FROM travel');
    debugPrint("Travel TASKS DATA: $result");
    dbTravelList.value.clear();
    for (var map in result) {
      final tasks = TravelTasksDB.fromMap(map);
      dbTravelList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbTravelList.notifyListeners();

    await getAllTasks();
  }

  static Future<void> insertToTravel(TravelTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO travel(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the technology task list after insertion
      getTravel();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Update Technology task from Database
  static Future<void> updateTravelTask(TravelTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE travel SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getTravel();
  }

// Delete a Work from the Database
  static Future<void> deleteTravel(id) async {
    await _db.delete('travel', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getTravel();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedTravelTasks(id) async {
    await _db.rawUpdate('UPDATE travel SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getTravel();
  }

  static Future<void> getFood() async {
    final result = await _db.rawQuery('SELECT * FROM food');
    debugPrint("Food TASKS DATA: $result");
    dbFoodList.value.clear();
    for (var map in result) {
      final tasks = FoodTasksDB.fromMap(map);
      dbFoodList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbFoodList.notifyListeners();

    await getAllTasks();
  }

  static Future<void> insertToFood(FoodTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO food(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the technology task list after insertion
      getFood();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Update Technology task from Database
  static Future<void> updateFoodTask(FoodTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE food SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getFood();
  }

  // Delete a Work from the Database
  static Future<void> deleteFood(id) async {
    await _db.delete('food', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getFood();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedFoodTasks(id) async {
    await _db.rawUpdate('UPDATE food SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getFood();
  }

  static Future<void> getSports() async {
    final result = await _db.rawQuery('SELECT * FROM sports');
    debugPrint("Sports TASKS DATA: $result");
    dbSportsList.value.clear();
    for (var map in result) {
      final tasks = SportsTasksDB.fromMap(map);
      dbSportsList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbSportsList.notifyListeners();

    await getAllTasks();
  }

  static Future<void> insertToSports(SportsTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO sports(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the technology task list after insertion
      getSports();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Update Technology task from Database
  static Future<void> updateSportsTask(SportsTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE sports SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getSports();
  }

  // Delete a Work from the Database
  static Future<void> deleteSports(id) async {
    await _db.delete('sports', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getSports();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedSportsTasks(id) async {
    await _db.rawUpdate('UPDATE sports SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getSports();
  }

  static Future<void> getHome() async {
    final result = await _db.rawQuery('SELECT * FROM home');
    debugPrint("Home TASKS DATA: $result");
    dbHomeList.value.clear();
    for (var map in result) {
      final tasks = HomeTasksDB.fromMap(map);
      dbHomeList.value.add(tasks);
    }
    // Notify listeners that the tasks list has changed
    dbHomeList.notifyListeners();

    await getAllTasks();
  }

  static Future<void> insertToHome(HomeTasksDB taskData) async {
    try {
      await _db.rawInsert(
          'INSERT INTO home(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat,count) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
            taskData.count,
          ]);
      // Update the technology task list after insertion
      getHome();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }
  }

  // Update Technology task from Database
  static Future<void> updateHomeTask(HomeTasksDB taskData) async {
    await _db.rawUpdate(
        'UPDATE home SET tasktitle = ?, date = ?, starttime = ?, endtime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?',
        [
          taskData.taskTitle,
          taskData.date,
          taskData.startTime,
          taskData.endTime,
          taskData.remind,
          taskData.repeat,
          taskData.color,
          taskData.id,
        ]);
    getHome();
  }

  // Delete a Work from the Database
  static Future<void> deleteHome(id) async {
    await _db.delete('home', where: 'id=?', whereArgs: [id]);
    // Update the tasks list after deletion
    getHome();
  }

  // Update isCompleted to TRUE in PERSONAL
  static Future<void> updateCompletedHomeTasks(id) async {
    await _db.rawUpdate('UPDATE home SET iscompleted=? WHERE id=?', [1, id]);
    // Update the tasks list after changing
    getHome();
  }

  static Future<void> clearSpecificDatabase(categoryname) async {
    switch (categoryname) {
      case 'Social':
        await _db.delete('social');
        getSocial();
        debugPrint('Social Database Cleared');
        break;
      case 'Technology':
        await _db.delete('technology');
        getTechnology();
        debugPrint('Technology Database Cleared');
        break;
      case 'Education':
        await _db.delete('education');
        getEducation();
        debugPrint('Education Database Cleared');
        break;
      case 'Fashion':
        await _db.delete('fashion');
        getFashion();
        debugPrint('Fashion Database Cleared');
        break;
      case 'Finance':
        await _db.delete('finance');
        getFinance();
        debugPrint('Finance Database Cleared');
        break;
      case 'Travel':
        await _db.delete('travel');
        getTravel();
        debugPrint('Travel Database Cleared');
        break;
      case 'Food':
        await _db.delete('food');
        getFood();
        debugPrint('Food Database Cleared');
        break;
      case 'Sports':
        await _db.delete('sports');
        getSports();
        debugPrint('Sports Database Cleared');
        break;
      case 'Home':
        await _db.delete('home');
        getHome();
        debugPrint('Home Database Cleared');
        break;
      default:
        print('No Category');
        break;
    }
  }

  static Future<void> getAllTasks() async {
    
    try {
      await _db.rawQuery('DELETE FROM alltasks');
      debugPrint("All existing data removed from alltasks table");

      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM personal',['personal']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM work',['work']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM health',['health']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM social',['social']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM technology',['technology']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM education',['education']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM fashion',['fashion']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM finance',['finance']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM travel',['travel']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM food',['food']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM sports',['sports']);
      await _db.rawQuery(
          'INSERT INTO alltasks SELECT ?, tasktitle, iscompleted, date, starttime, endtime, color,remind, repeat,count FROM home',['home']);

      debugPrint("Data replaced in alltasks successfully");
    } catch (e) {
      debugPrint("Error inserting data into alltasks: $e");
    }
    final result2 = await _db.rawQuery('SELECT * FROM alltasks');
    debugPrint("all TASKS DATA: $result2");
    dbAllTasksList.value.clear();
    for (var map in result2) {
      final tasks = AllTasksDB.fromMap(map);
      dbAllTasksList.value.add(tasks);
    }
    dbAllTasksList.notifyListeners();
  }
}