import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/allCategories.dart';
import 'package:taskmate/model/category.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:taskmate/model/education_task.dart';
import 'package:taskmate/model/fashion_task.dart';
import 'package:taskmate/model/finance_task.dart';
import 'package:taskmate/model/food_task.dart';
import 'package:taskmate/model/health_task.dart';
import 'package:taskmate/model/home_task.dart';
import 'package:taskmate/model/personal_task.dart';
import 'package:taskmate/model/social_task.dart';
import 'package:taskmate/model/sports_task.dart';
import 'package:taskmate/model/technology_task.dart';
import 'package:taskmate/model/travel_task.dart';
import 'package:taskmate/model/work_task.dart';
import 'package:taskmate/screens/details/details.dart';
import 'package:taskmate/screens/home/widgets/categoryListpage.dart';

class Tasks extends StatelessWidget {
  Tasks({super.key});

  // Initialize tasksList with categories
  final tasksList = Category.generateCategories();

  final categories = allCategories.generateCategories();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: categoryList, // Listen to changes in categoryList
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),

          // Category GridView List
          child: GridView.builder(
            itemCount: value.length != 12 ? value.length + 1 : value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              if (index > value.length - 1) {
                return _buildAddCategory(context); // Add Category Card
              } else {
                return _buildCategory(context, value[index], index);
              }
            },
          ),
        );
      },
    );
  }

  // Build individual category cards
  Widget _buildCategory(BuildContext context, Category category, index) {
    return ValueListenableBuilder(
        valueListenable: category.title == 'Personal'
            ? dbTasksList
            : category.title == 'Work'
                ? dbWorksList
                : category.title == 'Health'
                    ? dbHealthList
                    : category.title == 'Social'
                        ? dbSocialList
                        : category.title == 'Technology'
                            ? dbTechnologyList
                            : category.title == 'Education'
                                ? dbEducationList
                                : category.title == 'Fashion'
                                    ? dbFashionList
                                    : category.title == 'Finance'
                                        ? dbFinanceList
                                        : category.title == 'Travel'
                                            ? dbTravelList
                                            : category.title == 'Food'
                                                ? dbFoodList
                                                : category.title == 'Sports'
                                                    ? dbSportsList
                                                    : dbHomeList,
        builder: (context, List<Object> value, child) {
          List<PTasksDB> personal = value.cast<PTasksDB>();
          List<WorkTasksDB> work = value.cast<WorkTasksDB>();
          List<HealthTasksDB> health = value.cast<HealthTasksDB>();
          List<SocialTasksDB> social = value.cast<SocialTasksDB>();
          List<TechnologyTasksDB> technology = value.cast<TechnologyTasksDB>();
          List<EducationTasksDB> education = value.cast<EducationTasksDB>();
          List<FashionTasksDB> fashion = value.cast<FashionTasksDB>();
          List<FinanceTasksDB> finance = value.cast<FinanceTasksDB>();
          List<TravelTasksDB> travel = value.cast<TravelTasksDB>();
          List<FoodTasksDB> food = value.cast<FoodTasksDB>();
          List<SportsTasksDB> sports = value.cast<SportsTasksDB>();
          List<HomeTasksDB> home = value.cast<HomeTasksDB>();
          return GestureDetector(
            onTap: () {
              // Navigate to ShowTaskList with the selected category
              Get.to(
                () => Details(
                  categoryname: category.title!,
                ),
                transition: Transition.cupertino,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _backgroundColors(category),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Social Category has an extra delete button
                  index >= 3
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              _icon(category),
                              color: _iconColor(category),
                              size: 35,
                            ),
                            GestureDetector(
                              onTap: () => deletePressed(context, category),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        )
                      : Icon(
                          index == 0
                              ? Icons.person
                              : index == 1
                                  ? CupertinoIcons.briefcase_fill
                                  : Icons.favorite,
                          color: tasksList[index].iconColor,
                          size: 35,
                        ),
                  Text(
                    category.title!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // Display left and done status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCategoryStatus(
                          context,
                          _leftStatusBackgroundColor(category),
                          _leftStatusTextColor(category),
                          _leftStatusText(
                            category,
                            personal,
                            work,
                            health,
                            social,
                            technology,
                            education,
                            fashion,
                            finance,
                            travel,
                            food,
                            sports,
                            home,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      _buildCategoryStatus(
                        context,
                        Colors.white,
                        _doneStatusTextColor(category),
                        _doneStatusText(
                          category,
                          personal,
                          work,
                          health,
                          social,
                          technology,
                          education,
                          fashion,
                          finance,
                          travel,
                          food,
                          sports,
                          home,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  // Build status indicator for each category
  Widget _buildCategoryStatus(
      context, Color bgColor, Color txColor, String text) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 30,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: txColor),
        ),
      ),
    );
  }

  // Add New Category card with DottedBorder
  Widget _buildAddCategory(context) {
    return GestureDetector(
      onTap: () async {
        Get.to(
            transition: Transition.circularReveal,
            () => CategoryListPage(categories: categories));
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        dashPattern: const [10, 10],
        color: Colors.grey,
        strokeWidth: 2,
        child: const Center(
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Handle deleting a category
  Future<void> deletePressed(context, Category category) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('By deleting the ${category.title} category you\'ll lose all data stored in this category. Are you sure want to continue ?'),
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
                  Get.back();
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
        ],
      ).animate().flip(duration: const Duration(milliseconds: 300)),
    );
  }

  _backgroundColors(Category category) {
    return category.title! == 'Personal'
        ? tasksList[0].bgColor
        : category.title! == 'Work'
            ? tasksList[1].bgColor
            : category.title! == 'Health'
                ? tasksList[2].bgColor
                : category.title! == 'Social'
                    ? tasksList[3].bgColor
                    : category.title! == 'Technology'
                        ? tasksList[4].bgColor
                        : category.title! == 'Education'
                            ? tasksList[5].bgColor
                            : category.title! == 'Fashion'
                                ? tasksList[6].bgColor
                                : category.title! == 'Finance'
                                    ? tasksList[7].bgColor
                                    : category.title! == 'Travel'
                                        ? tasksList[8].bgColor
                                        : category.title! == 'Food'
                                            ? tasksList[9].bgColor
                                            : category.title! == 'Sports'
                                                ? tasksList[10].bgColor
                                                : tasksList[11].bgColor;
  }

  _iconColor(Category category) {
    return category.title! == 'Personal'
        ? tasksList[0].iconColor
        : category.title! == 'Work'
            ? tasksList[1].iconColor
            : category.title! == 'Health'
                ? tasksList[2].iconColor
                : category.title! == 'Social'
                    ? tasksList[3].iconColor
                    : category.title! == 'Technology'
                        ? tasksList[4].iconColor
                        : category.title! == 'Education'
                            ? tasksList[5].iconColor
                            : category.title! == 'Fashion'
                                ? tasksList[6].iconColor
                                : category.title! == 'Finance'
                                    ? tasksList[7].iconColor
                                    : category.title! == 'Travel'
                                        ? tasksList[8].iconColor
                                        : category.title! == 'Food'
                                            ? tasksList[9].iconColor
                                            : category.title! == 'Sports'
                                                ? tasksList[10].iconColor
                                                : tasksList[11].iconColor;
  }

  _icon(Category category) {
    return category.title! == 'Personal'
        ? tasksList[0].iconData
        : category.title! == 'Work'
            ? tasksList[1].iconData
            : category.title! == 'Health'
                ? tasksList[2].iconData
                : category.title! == 'Social'
                    ? tasksList[3].iconData
                    : category.title! == 'Technology'
                        ? tasksList[4].iconData
                        : category.title! == 'Education'
                            ? tasksList[5].iconData
                            : category.title! == 'Fashion'
                                ? tasksList[6].iconData
                                : category.title! == 'Finance'
                                    ? tasksList[7].iconData
                                    : category.title! == 'Travel'
                                        ? tasksList[8].iconData
                                        : category.title! == 'Food'
                                            ? tasksList[9].iconData
                                            : category.title! == 'Sports'
                                                ? tasksList[10].iconData
                                                : tasksList[11].iconData;
  }

  _leftStatusBackgroundColor(Category category) {
    return category.title == 'Personal'
        ? tasksList[0].btnColor!
        : category.title == 'Work'
            ? tasksList[1].btnColor!
            : category.title == 'Health'
                ? tasksList[2].btnColor!
                : category.title == 'Social'
                    ? tasksList[3].btnColor!
                    : category.title == 'Technology'
                        ? tasksList[4].btnColor!
                        : category.title == 'Education'
                            ? tasksList[5].btnColor!
                            : category.title == 'Fashion'
                                ? tasksList[6].btnColor!
                                : category.title == 'Finance'
                                    ? tasksList[7].btnColor!
                                    : category.title == 'Travel'
                                        ? tasksList[8].btnColor!
                                        : category.title == 'Food'
                                            ? tasksList[9].btnColor!
                                            : category.title == 'Sports'
                                                ? tasksList[10].btnColor!
                                                : tasksList[11].btnColor!;
  }

  _leftStatusTextColor(Category category) {
    return category.title == 'Personal'
        ? tasksList[0].iconColor!
        : category.title == 'Work'
            ? tasksList[1].iconColor!
            : category.title == 'Health'
                ? tasksList[2].iconColor!
                : category.title == 'Social'
                    ? tasksList[3].iconColor!
                    : category.title == 'Technology'
                        ? tasksList[4].iconColor!
                        : category.title == 'Education'
                            ? tasksList[5].iconColor!
                            : category.title == 'Fashion'
                                ? tasksList[6].iconColor!
                                : category.title == 'Finance'
                                    ? tasksList[7].iconColor!
                                    : category.title == 'Travel'
                                        ? tasksList[8].iconColor!
                                        : category.title == 'Food'
                                            ? tasksList[9].iconColor!
                                            : category.title == 'Sports'
                                                ? tasksList[10].iconColor!
                                                : tasksList[11].iconColor!;
  }

  _leftStatusText(
    Category category,
    List<PTasksDB> personal,
    List<WorkTasksDB> work,
    List<HealthTasksDB> health,
    List<SocialTasksDB> social,
    List<TechnologyTasksDB> technology,
    List<EducationTasksDB> education,
    List<FashionTasksDB> fashion,
    List<FinanceTasksDB> finance,
    List<TravelTasksDB> travel,
    List<FoodTasksDB> food,
    List<SportsTasksDB> sports,
    List<HomeTasksDB> home,
  ) {
    return category.title == 'Personal'
        ? personal.isEmpty
            ? '${personal.length} left'
            : '${(personal.length) - (personal[0].count!)} left'
        : category.title == 'Work'
            ? work.isEmpty
                ? '${work.length} left'
                : '${(work.length) - (work[0].count!)} left'
            : category.title == 'Health'
                ? health.isEmpty
                    ? '${health.length} left'
                    : '${(health.length) - (health[0].count!)} left'
                : category.title == 'Social'
                    ? social.isEmpty
                        ? '${social.length} left'
                        : '${(social.length) - (social[0].count!)} left'
                    : category.title == 'Technology'
                        ? technology.isEmpty
                            ? '${technology.length} left'
                            : '${(technology.length) - (technology[0].count!)} left'
                        : category.title == 'Education'
                            ? education.isEmpty
                                ? '${education.length} left'
                                : '${(education.length) - (education[0].count!)} left'
                            : category.title == 'Fashion'
                                ? fashion.isEmpty
                                    ? '${fashion.length} left'
                                    : '${(fashion.length) - (fashion[0].count!)} left'
                                : category.title == 'Finance'
                                    ? finance.isEmpty
                                        ? '${finance.length} left'
                                        : '${(finance.length) - (finance[0].count!)} left'
                                    : category.title == 'Travel'
                                        ? travel.isEmpty
                                            ? '${travel.length} left'
                                            : '${(travel.length) - (travel[0].count!)} left'
                                        : category.title == 'Food'
                                            ? food.isEmpty
                                                ? '${food.length} left'
                                                : '${(food.length) - (food[0].count!)} left'
                                            : category.title == 'Sports'
                                                ? sports.isEmpty
                                                    ? '${sports.length} left'
                                                    : '${(sports.length) - (sports[0].count!)} left'
                                                : home.isEmpty
                                                    ? '${home.length} left'
                                                    : '${(home.length) - (home[0].count!)} left';
  }

  _doneStatusTextColor(Category category) {
    return category.title == 'Personal'
        ? tasksList[0].iconColor!
        : category.title == 'Work'
            ? tasksList[1].iconColor!
            : category.title == 'Health'
                ? tasksList[2].iconColor!
                : category.title == 'Social'
                    ? tasksList[3].iconColor!
                    : category.title == 'Technology'
                        ? tasksList[4].iconColor!
                        : category.title == 'Education'
                            ? tasksList[5].iconColor!
                            : category.title == 'Fashion'
                                ? tasksList[6].iconColor!
                                : category.title == 'Finance'
                                    ? tasksList[7].iconColor!
                                    : category.title == 'Travel'
                                        ? tasksList[8].iconColor!
                                        : category.title == 'Food'
                                            ? tasksList[9].iconColor!
                                            : category.title == 'Sports'
                                                ? tasksList[10].iconColor!
                                                : tasksList[11].iconColor!;
  }

  _doneStatusText(
    Category category,
    List<PTasksDB> personal,
    List<WorkTasksDB> work,
    List<HealthTasksDB> health,
    List<SocialTasksDB> social,
    List<TechnologyTasksDB> technology,
    List<EducationTasksDB> education,
    List<FashionTasksDB> fashion,
    List<FinanceTasksDB> finance,
    List<TravelTasksDB> travel,
    List<FoodTasksDB> food,
    List<SportsTasksDB> sports,
    List<HomeTasksDB> home,
  ) {
    return category.title == 'Personal'
        ? personal.isEmpty
            ? '0 done'
            : '${personal[0].count!} done'
        : category.title == 'Work'
            ? work.isEmpty
                ? '0 done'
                : '${work[0].count!} done'
            : category.title == 'Health'
                ? health.isEmpty
                    ? '0 done'
                    : '${health[0].count!} done'
                : category.title == 'Social'
                    ? social.isEmpty
                        ? '0 done'
                        : '${social[0].count!} done'
                    : category.title == 'Technology'
                        ? technology.isEmpty
                            ? '0 done'
                            : '${technology[0].count!} done'
                        : category.title == 'Education'
                            ? education.isEmpty
                                ? '0 done'
                                : '${education[0].count!} done'
                            : category.title == 'Fashion'
                                ? fashion.isEmpty
                                    ? '0 done'
                                    : '${fashion[0].count!} done'
                                : category.title == 'Finance'
                                    ? finance.isEmpty
                                        ? '0 done'
                                        : '${finance[0].count!} done'
                                    : category.title == 'Travel'
                                        ? travel.isEmpty
                                            ? '0 done'
                                            : '${travel[0].count!} done'
                                        : category.title == 'Food'
                                            ? food.isEmpty
                                                ? '0 done'
                                                : '${food[0].count!} done'
                                            : category.title == 'Sports'
                                                ? sports.isEmpty
                                                    ? '0 done'
                                                    : '${sports[0].count!} done'
                                                : home.isEmpty
                                                    ? '0 done'
                                                    : '${home[0].count!} done';
  }
}
