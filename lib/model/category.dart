import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/constants/colors.dart';

class Category {
  int? id;
  IconData? iconData;
  String? title;
  Color? bgColor;
  Color? iconColor;
  Color? btnColor;
  bool isLast;
  Category({
    this.id,
    this.title,
    this.bgColor,
    this.iconData,
    this.btnColor,
    this.iconColor,
    this.isLast = false,
  });
  static List<Category> generateCategories() {
    return [
      Category(
        title: 'Person',
        iconData :  Icons.person,
        bgColor: kYellowLight,
        iconColor: kYellowDark,
        btnColor: kYellow,
      ),
      Category(
        title: 'Work',
        iconData :  CupertinoIcons.briefcase_fill,
       bgColor: kRedLight,
        iconColor: kRedDark,
        btnColor: kRed,
      ),
      Category(
        title: 'Health',
        iconData :  Icons.favorite,
        bgColor: kBlueLight,
        iconColor: kBlueDark,
        btnColor: kBlue,
      ),
      Category(
        title: 'Social',
        iconData :  CupertinoIcons.person_3_fill,
        bgColor: kGreenLight,
        iconColor: kGreenDark,
        btnColor: kGreen,
      ),
      Category(
     title: 'Technology',
     iconData: CupertinoIcons.device_phone_portrait,
     bgColor: kPurpleLight,
     iconColor: kPurpleDark,
     btnColor: kPurple,
),
Category(
     title: 'Education',
     iconData: CupertinoIcons.book_fill,
     bgColor: kOrangeLight,
     iconColor: kOrangeDark,
     btnColor: kOrange,
),
Category(
     title: 'Fashion',
     iconData: CupertinoIcons.bag_fill,  // You can change this icon
     bgColor: kPinkLight,
     iconColor: kPinkDark,
     btnColor: kPink,
),


Category(
    title: 'Finance',
    iconData: CupertinoIcons.creditcard_fill,
    bgColor: Color(0xFFBBDEFB),    // Light Blue
    iconColor: Color(0xFF2196F3),  // Blue
    btnColor: Color(0xFF64B5F6),   // Light
),


Category(
     title: 'Travel',
     iconData: CupertinoIcons.airplane,
     bgColor: kRedLight,
     iconColor: kRedDark,
     btnColor: kRed,
),
Category(
    title: 'Food',
    iconData : Icons.restaurant,
    bgColor: kFoodLight,    // Peach
    iconColor: kFood,  // Orange
    btnColor:kFoodDark,  
),


Category(
     title: 'Sports',
     iconData: CupertinoIcons.sportscourt_fill,
     bgColor: kIndigoLight,
     iconColor: kIndigoDark,
     btnColor: kIndigo,
),
Category(
     title: 'Home',
     iconData: CupertinoIcons.house_fill,
     bgColor: kCyanLight,
     iconColor: kCyanDark,
     btnColor: kCyan,
),
    ];
  }

   static Category fromMap(Map<String, Object?> map) {
    int id = map['id'] as int;
    String title = map['title'] as String;

    return Category(
     id : id,
     title : title,
     );
  }

}
