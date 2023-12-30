
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/allCategories.dart';
import 'package:taskmate/model/category.dart';


class CategoryListPage extends StatelessWidget {
  final List<allCategories> categories;

  const CategoryListPage({super.key, required this.categories});

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: 1,
            child: ScaleAnimation(
              duration: const Duration(milliseconds: 500),
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  tileColor: categories[index].bgColor,
                  leading: Icon(categories[index].iconData,color: categories[index].iconColor,),
                  title: Text(categories[index].title!),
                  onTap: () {
                    showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'New Category',
                    style: TextStyle(fontSize: 21),
                  ),
                  content: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            categories[index].iconData,
                            color: categories[index].iconColor,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            categories[index].title!,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.white),
                            foregroundColor: MaterialStatePropertyAll(Colors.black),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.black),
                            foregroundColor: MaterialStatePropertyAll(Colors.white),
                          ),
                          onPressed: () async{
                            addCategoryClicked(context,categories[index],ctx);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ).animate().scaleX(duration: const Duration(milliseconds: 250)),
                      );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Future<void> addCategoryClicked(context,category,ctx) async {
    
    final categoryData4 = Category(
      title: category.title,
    );
    await DBHelper.insertToCategory(categoryData4);

    Navigator.pop(context);
    Navigator.pop(ctx);
  }
}
