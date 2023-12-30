import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskmate/model/allCategories.dart';
import 'package:taskmate/model/category.dart';
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
import 'package:taskmate/screens/alltasksList.dart/all_tasks_list.dart';
import 'package:taskmate/screens/details/details.dart';
import 'package:taskmate/screens/home/profile/profile.dart';
import 'package:taskmate/screens/home/widgets/categoryListpage.dart';
import 'package:taskmate/screens/search/search_screen.dart';
import 'package:taskmate/screens/home/widgets/go_premium.dart';
import 'package:taskmate/screens/home/widgets/tasks.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:taskmate/services/notify_helper.dart';


class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

final tasksList = Category.generateCategories();

final categories = allCategories.generateCategories();

      @override
      void initState() {
        super.initState();
      }

  @override
  Widget build(BuildContext context) {
    DBHelper.getCategory(); // Retrieve category data from the database.
    DBHelper.getPersonal(); // Retrieve personal task list data from the database.
    DBHelper.getWorks(); // Retrieve work task list data from the database.
    DBHelper.getHealth(); // Retrieve health task list data from the database.
    DBHelper.getSocial(); // Retrieve social task list data from the database.
    DBHelper.getTechnology(); // Retrieve social task list data from the database.
    DBHelper.getEducation(); // Retrieve social task list data from the database.
    DBHelper.getFashion(); // Retrieve social task list data from the database.
    DBHelper.getFinance(); // Retrieve social task list data from the database.
    DBHelper.getTravel(); // Retrieve social task list data from the database.
    DBHelper.getFood(); // Retrieve social task list data from the database.
    DBHelper.getSports(); // Retrieve social task list data from the database.
    DBHelper.getHome(); // Retrieve social task list data from the database.
    DBHelper.getProfile();
    DBHelper.getAllTasks();
    return Scaffold(
      // App Bar for the top of the screen.
      appBar: _buildappBar(),
      body: SafeArea(
        // The main content area of the app.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GoPremium(), // Widget for going premium.
        
            Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                'Categories',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Tasks(), // Display tasks in an expandable widget.
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          _buildCurvedBottomNavigationBar(), // Bottom navigation bar.
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: _floatingActionButton(), // Floating action button.
    );
  }

// Widget to build the app bar.
  _buildappBar(){
    return AppBar(
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: InkWell(
                onTap: () {
                  Get.to(()=>const Profile());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/profile.jpeg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text('Hello, Welcome!'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
              onPressed: () {
                Get.to(() => const Search(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 300));
              },
              icon: const Icon(Icons.search),
              iconSize: 30,
            ),
          )
        ],
      );
  }

// Widget to build the curved bottom navigation bar.
  Widget _buildCurvedBottomNavigationBar() {
    return CurvedNavigationBar(
      items: [
        const Icon(
          Icons.home_rounded,
          color: Colors.white
        ),
        IconButton(
          enableFeedback: false,
          focusColor: Colors.white,
          splashRadius: 10,
          visualDensity: null,
          onPressed: (){
            Get.to(()=> const AllTasksList());
          },
          icon: const Icon(
          CupertinoIcons.square_list),
          color: Colors.black,
        ),
        IconButton(
          enableFeedback: false,
          focusColor: Colors.white,
          splashRadius: 10,
          visualDensity: null,
          onPressed: (){
            Get.to(()=>const Profile());
          },
          icon: const Icon(
          Icons.person),
          color: Colors.black,
        ),
        
      ],
      
      animationCurve: Curves.easeInOutQuart,
      height: 60,
      color: Colors.transparent,
      buttonBackgroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      letIndexChange: (value) =>false,
      index: 0,
    );
  }

// Create the floating action button.
  _floatingActionButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.black,
      onPressed: () {
        _showBottomSheet(
            context,); // Show a bottom sheet when the button is pressed.
      },
      child: const Icon(
        Icons.add,
        size: 35,
        color: Colors.white,
      ),
    );
  }

// Handle adding a new category.
Future<void> addCategoryClicked(context) async {
  final categoryData4 = Category(
    title: 'Social',
  );
  await DBHelper.insertToCategory(categoryData4);
  Navigator.pop(context);
}

// Show a bottom sheet for selecting a category.
_showBottomSheet(context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select a Category',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: categoryList,
            builder: (context, value, child) {
              return Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height/2.1,),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.builder(
                  // shrinkWrap: true,
                  itemCount: value.length < 12 ? value.length + 1 : value.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    if (index > value.length - 1) {
                      return _buildAddCategory(
                          context); // Build the "Add" category item.
                    } else {
                      return _buildCategory(context, value[index], index);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

// Build the category item.
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
        }
  );
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
        Get.off(
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

