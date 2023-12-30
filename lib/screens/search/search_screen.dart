
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/category.dart';
import 'package:taskmate/screens/details/details.dart';


class Search extends StatefulWidget {
  const Search({super.key}); 

  @override
  State<Search> createState() =>
      _SearchState(); 
}

class _SearchState extends State<Search> {
  List<Category> findCategory = []; // List to store filtered categories.
  final tasksList =
      Category.generateCategories(); // List of category properties.

  @override
  void initState() {
    super.initState();

    // Initialize the findCategory list with all categories.
    findCategory = categoryList.value;
  }

  void _runFilter(String enteredKeyword) {
    List<Category> result = [];

    // Reset to the original list if the search is empty.
    if (enteredKeyword.isEmpty) {
      result = categoryList.value;
    }
    // Filter based on Category properties.
    else {
      result = categoryList.value
          .where(
            (element) => element.title!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      findCategory =
          result; // Update the findCategory list with filtered categories.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar with a search input field.
      appBar: AppBar(
        title: TextField(
          onChanged: (value) =>
              _runFilter(value), // Handle text input changes for filtering.
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: 'Search...',
          ),
        ),
      ),
      body: SafeArea(
        // The main content area of the app.
        child: ValueListenableBuilder<List<Category>>(
          valueListenable: categoryList,
          builder: (context, categoryListValue, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            // List the Category items based on search results.

            child: ListView.builder(
              itemCount: findCategory.length,
              itemBuilder: (context, index) {
                final findCategoryItem = findCategory[index];
                return AnimationConfiguration.staggeredList(
                  position: 1,
                  
                  child: SlideAnimation(
                    horizontalOffset: 400,
                    duration: const Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      curve: Easing.linear,
                      duration: const Duration(milliseconds: 600),
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: () {
                            // setState(() {
                            // });
                            Get.off(
                                () => Details(
                                    categoryname: findCategoryItem.title!,),
                                transition: Transition.cupertino);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                      
                          // ListTile Decoration based on category.
                      
                          tileColor: findCategoryItem.title == 'Personal'
                              ? tasksList[0].bgColor
                              : findCategoryItem.title == 'Work'
                                  ? tasksList[1].bgColor
                                  : findCategoryItem.title == 'Health'
                                      ? tasksList[2].bgColor
                                      : findCategoryItem.title == 'Social'
                                      ? tasksList[3].bgColor : findCategoryItem.title == 'Technology'
                                      ? tasksList[4].bgColor : findCategoryItem.title == 'Education'
                                      ? tasksList[5].bgColor : findCategoryItem.title == 'Fashion'
                                      ? tasksList[6].bgColor : findCategoryItem.title == 'Finance'
                                      ? tasksList[7].bgColor : findCategoryItem.title == 'Travel'
                                      ? tasksList[8].bgColor : findCategoryItem.title == 'Food'
                                      ? tasksList[9].bgColor : findCategoryItem.title == 'Sports'
                                      ? tasksList[10].bgColor : tasksList[11].bgColor,
                      
                          // Leading Icon based on category.
                      
                          leading: findCategoryItem.title == 'Personal'
                              ? Icon(
                                  Icons.person,
                                  color: tasksList[0].iconColor,
                                )
                              : findCategoryItem.title == 'Work'
                                  ? Icon(
                                      tasksList[1].iconData,
                                      color: tasksList[1].iconColor,
                                    )
                                  : findCategoryItem.title == 'Health'
                                      ? Icon(
                                          tasksList[2].iconData,
                                          color: tasksList[2].iconColor,
                                        )
                                      : findCategoryItem.title == 'Social'
                                      ? Icon(
                                          tasksList[3].iconData,
                                          color: tasksList[3].iconColor,
                                        ) :
                                        findCategoryItem.title == 'Technology'
                                      ? Icon(
                                          tasksList[4].iconData,
                                          color: tasksList[4].iconColor,
                                        ) : 
                                        findCategoryItem.title == 'Education'
                                      ? Icon(
                                          tasksList[5].iconData,
                                          color: tasksList[5].iconColor,
                                        ) : findCategoryItem.title == 'Fashion'
                                      ? Icon(
                                          tasksList[6].iconData,
                                          color: tasksList[6].iconColor,
                                        ) : findCategoryItem.title == 'Finance'
                                      ? Icon(
                                          tasksList[7].iconData,
                                          color: tasksList[7].iconColor,
                                        ) : findCategoryItem.title == 'Travel'
                                      ? Icon(
                                          tasksList[8].iconData,
                                          color: tasksList[8].iconColor,
                                        ) : findCategoryItem.title == 'Food'
                                      ? Icon(
                                          tasksList[9].iconData,
                                          color: tasksList[9].iconColor,
                                        ) : findCategoryItem.title == 'Sports'
                                      ? Icon(
                                          tasksList[10].iconData,
                                          color: tasksList[10].iconColor,
                                        ) : Icon(tasksList[11].iconData,color : tasksList[11].iconColor,),
                      
                          // Title of the category.
                      
                          title: Text(
                            findCategoryItem.title!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                      
                          // Trailing action (Delete for 'Social' category).
                      
                          trailing: findCategoryItem.title != 'Personal' && findCategoryItem.title != 'Work' && findCategoryItem.title != 'Health'
                              ? IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deletePressed(context, findCategoryItem);
                                  },
                                )
                              : null, // Display null if not 'Social' category.
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Handle the deletion of a category.
Future<void> deletePressed(context, Category category) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content:
         Text('By deleting the ${category.title} category you\'ll lose all data stored in this category. Are you sure want to continue ?'),
      title: const Text("Confirm"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.black),
              ),
              child: const Text('No'),
            ),
            const SizedBox(
              width: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                DBHelper.deleteCategory(category.id);
                await DBHelper.clearSpecificDatabase(category.title);
                Navigator.pop(context);
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              child: const Text('Yes'),
            ),
          ],
        )
      ],
    ).animate().scaleY(duration: const Duration(milliseconds: 250)),
  );
}
