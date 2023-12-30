import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/constants/colors.dart';

class allCategories {
  int? id;
  IconData? iconData;
  String? title;
  Color? bgColor;
  Color? iconColor;
  Color? btnColor;
  allCategories({
    this.id,
    this.title,
    this.bgColor,
    this.iconData,
    this.btnColor,
    this.iconColor,
  });
  static List<allCategories> generateCategories() {
    return [
      allCategories(
        title: 'Social',
        iconData :  CupertinoIcons.person_3_fill,
        bgColor: kGreenLight,
        iconColor: kGreenDark,
        btnColor: kGreen,
      ),
      allCategories(
     title: 'Technology',
     iconData: CupertinoIcons.device_phone_portrait,
     bgColor: kPurpleLight,
     iconColor: kPurpleDark,
     btnColor: kPurple,
),
allCategories(
     title: 'Education',
     iconData: CupertinoIcons.book_fill,
     bgColor: kOrangeLight,
     iconColor: kOrangeDark,
     btnColor: kOrange,
),
allCategories(
     title: 'Fashion',
     iconData: CupertinoIcons.bag_fill,  // You can change this icon
     bgColor: kPinkLight,
     iconColor: kPinkDark,
     btnColor: kPink,
),


allCategories(
    title: 'Finance',
    iconData: CupertinoIcons.creditcard_fill,
    bgColor: Color(0xFFBBDEFB),    // Light Blue
    iconColor: Color(0xFF2196F3),  // Blue
    btnColor: Color(0xFF64B5F6),   // Light
),


allCategories(
     title: 'Travel',
     iconData: CupertinoIcons.airplane,
     bgColor: kRedLight,
     iconColor: kRedDark,
     btnColor: kRed,
),
allCategories(
    title: 'Food',
    iconData : Icons.restaurant,
    bgColor: kFoodLight,    // Peach
    iconColor: kFood,  // Orange
    btnColor:kFoodDark,  
),


allCategories(
     title: 'Sports',
     iconData: CupertinoIcons.sportscourt_fill,
     bgColor: kIndigoLight,
     iconColor: kIndigoDark,
     btnColor: kIndigo,
),
allCategories(
     title: 'Home',
     iconData: CupertinoIcons.house_fill,
     bgColor: kCyanLight,
     iconColor: kCyanDark,
     btnColor: kCyan,
),

    ];
  }

  //  static allCategories fromMap(Map<String, Object?> map) {
  //   int id = map['id'] as int;
  //   String title = map['title'] as String;

  //   return allCategories(
  //    id : id,
  //    title : title,
  //    );
  // }

}
