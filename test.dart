// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:taskmate/db/db_helper.dart';
// void main(List<String> args) {
//   var words = ["are","amy","u"], left = 0, right = 2,count=0;
//   List<String> vowels =['a','e','i','o','u'];
//     for(int i=0;i<words.length;i++){
//         String check = words[i];
//         if(vowels.contains(check[0])&&vowels.contains(check[check.length-1])){
//           count++;
//         }
//     }
//     print(count);
//     late Database _db;
// createDb()async{
//   _db = await openDatabase('db.db',version: 1,onCreate: (db, version) async{
//     db.execute('CREATE TABLE db(id INTEGER PRIMARY KEY,name TEXT, number INTEGER)');
//   },);

//   final result = await _db.rawQuery('SELECT name FROM db WHERE id = 1');
//   for(var map in result){
//     final profile = Profile.fromMap(map);
//     dbProfile.value.add(profile);

//   }
//   dbProfileList.notifyListeners();
// try {
//   await _db.rawInsert("INSERT INTO db (name,number) VALUES(?,?)",[12,12]);
  
// } catch (e) {
//   debugPrint('$e');
// }
// await _db.rawUpdate('UPDATE db SET name = ?, number = ? WHERE name = ?',['name',12,'me']);
// await _db.rawDelete("DELETE FROM db WHERE id = ?",[1]);
// }

// }
    