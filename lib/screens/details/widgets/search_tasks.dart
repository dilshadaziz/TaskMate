import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskmate/constants/colors.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/allTasks.dart';
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
import 'package:taskmate/screens/details/details.dart';
import 'package:taskmate/screens/details/widgets/edit_task.dart';

class SearchTasks extends StatefulWidget {
  final String categoryname;
  final selectedDate;
  const SearchTasks(
      {required this.categoryname, required this.selectedDate, super.key});

  @override
  State<SearchTasks> createState() => _SearchState();
}

class _SearchState extends State<SearchTasks> {
  // Lists to store tasks for each category
  List<PTasksDB> findPersonalTasks = [];
  List<WorkTasksDB> findWorkTasks = [];
  List<HealthTasksDB> findHealthTasks = [];
  List<SocialTasksDB> findSocialTasks = [];
  List<TechnologyTasksDB> findTechnologyTasks = [];
  List<EducationTasksDB> findEducationTasks = [];
  List<FashionTasksDB> findFashionTasks = [];
  List<FinanceTasksDB> findFinanceTasks = [];
  List<TravelTasksDB> findTravelTasks = [];
  List<FoodTasksDB> findFoodTasks = [];
  List<SportsTasksDB> findSportsTasks = [];
  List<HomeTasksDB> findHomeTasks = [];
  List<AllTasksDB> findAllTasks = [];
  @override
  void initState() {
    super.initState();

    // Initialize the findCategory list with all categories.

    findPersonalTasks = dbTasksList.value;
    findWorkTasks = dbWorksList.value;
    findHealthTasks = dbHealthList.value;
    findSocialTasks = dbSocialList.value;
    findTechnologyTasks = dbTechnologyList.value;
    findEducationTasks = dbEducationList.value;
    findFashionTasks = dbFashionList.value;
    findFinanceTasks = dbFinanceList.value;
    findTravelTasks = dbTravelList.value;
    findFoodTasks = dbFoodList.value;
    findSportsTasks = dbSportsList.value;
    findHomeTasks = dbHomeList.value;
    findAllTasks = dbAllTasksList.value;
  }

// Method to filter tasks based on the entered keyword
  void _runFilter(String enteredKeyword) {
    List<Object> result = [];

    // Reset to the original list if the search is empty.
    if (enteredKeyword.isEmpty) {
      if (widget.categoryname == 'Personal') {
        result = dbTasksList.value;
      } else if (widget.categoryname == 'Work') {
        result = dbWorksList.value;
      } else if (widget.categoryname == 'Health') {
        result = dbHealthList.value;
      } else if (widget.categoryname == 'Social') {
        result = dbSocialList.value;
      } else if (widget.categoryname == 'Technology') {
        result = dbTechnologyList.value;
      } else if (widget.categoryname == 'Education') {
        result = dbEducationList.value;
      } else if (widget.categoryname == 'Fashion') {
        result = dbFashionList.value;
      } else if (widget.categoryname == 'Finance') {
        result = dbFinanceList.value;
      } else if (widget.categoryname == 'Travel') {
        result = dbTravelList.value;
      } else if (widget.categoryname == 'Food') {
        result = dbFoodList.value;
      } else if (widget.categoryname == 'Sports') {
        result = dbSportsList.value;
      } else if (widget.categoryname == 'Home') {
        result = dbHomeList.value;
      }
      else{
        result = dbAllTasksList.value;
      }
    }
    // Filter based on Category properties.
    else {
      if (widget.categoryname == 'Personal') {
        result = dbTasksList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Work') {
        result = dbWorksList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Health') {
        result = dbHealthList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Social') {
        result = dbSocialList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Technology') {
        result = dbTechnologyList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Education') {
        result = dbEducationList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Fashion') {
        result = dbFashionList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Finance') {
        result = dbFinanceList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Travel') {
        result = dbTravelList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Food') {
        result = dbFoodList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Sports') {
        result = dbSportsList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      } else if (widget.categoryname == 'Home'){
        result = dbHomeList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      }
       else{
        result = dbAllTasksList.value
            .where(
              (element) => element.taskTitle!.toLowerCase().contains(
                    enteredKeyword.toLowerCase(),
                  ),
            )
            .toList();
      }
    }
    setState(() {
      if (widget.categoryname == 'Personal') {
        findPersonalTasks = result.cast<PTasksDB>();
      } else if (widget.categoryname == 'Work') {
        findWorkTasks = result.cast<WorkTasksDB>();
      } else if (widget.categoryname == 'Health') {
        findHealthTasks = result.cast<HealthTasksDB>();
      } else if (widget.categoryname == 'Social') {
        findSocialTasks = result.cast<SocialTasksDB>();
      } else if (widget.categoryname == 'Technology') {
        findTechnologyTasks = result.cast<TechnologyTasksDB>();
      } else if (widget.categoryname == 'Education') {
        findEducationTasks = result.cast<EducationTasksDB>();
      } else if (widget.categoryname == 'Fashion') {
        findFashionTasks = result.cast<FashionTasksDB>();
      } else if (widget.categoryname == 'Finance') {
        findFinanceTasks = result.cast<FinanceTasksDB>();
      } else if (widget.categoryname == 'Travel') {
        findTravelTasks = result.cast<TravelTasksDB>();
      } else if (widget.categoryname == 'Food') {
        findFoodTasks = result.cast<FoodTasksDB>();
      } else if (widget.categoryname == 'Sports') {
        findSportsTasks = result.cast<SportsTasksDB>();
      } else if(widget.categoryname == 'Home'){
        findHomeTasks = result.cast<HomeTasksDB>();
      }
      else{
        findAllTasks = result.cast<AllTasksDB>();
      }
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
        child: ValueListenableBuilder<List<PTasksDB>>(
          valueListenable: dbTasksList,
          builder: (context, personalTasks, child) =>

              // List the items based on search results.

              Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: widget.categoryname == 'Personal'
                  ? findPersonalTasks.length
                  : widget.categoryname == 'Work'
                      ? findWorkTasks.length
                      : widget.categoryname == 'Health'
                          ? findHealthTasks.length
                          : widget.categoryname == 'Social'
                              ? findSocialTasks.length
                              : widget.categoryname == 'Technology'
                                  ? findTechnologyTasks.length
                                  : widget.categoryname == 'Education'
                                      ? findEducationTasks.length
                                      : widget.categoryname == 'Fashion'
                                          ? findFashionTasks.length
                                          : widget.categoryname == 'Finance'
                                              ? findFinanceTasks.length
                                              : widget.categoryname == 'Travel'
                                                  ? findTravelTasks.length
                                                  : widget.categoryname ==
                                                          'Food'
                                                      ? findFoodTasks.length
                                                      : widget.categoryname ==
                                                              'Sports'
                                                          ? findSportsTasks
                                                              .length
                                                          : widget.categoryname == 'Home' ? findHomeTasks
                                                              .length : findAllTasks.length,
              itemBuilder: (context, index) {
                late final PTasksDB findPersonalTaskItem;
                late final WorkTasksDB findWorkTaskItem ;
                late final HealthTasksDB findHealthTaskItem;
                late final SocialTasksDB findSocialTaskItem;
                late final TechnologyTasksDB findTechnologyTaskitem;
                late final EducationTasksDB findEducationTaskItem;
                late final FashionTasksDB findFashionTaskItem;
                late final FinanceTasksDB findFinanceTaskItem;
                late final TravelTasksDB findTravelTaskItem;
                late final FoodTasksDB findFoodTaskItem;
                late final SportsTasksDB findSportsTaskItem;
                late final HomeTasksDB findHomeTaskItem;
                late final AllTasksDB findAllTaskItem;

                if (widget.categoryname == 'Personal') {
                  findPersonalTaskItem = findPersonalTasks[index];
                } if (widget.categoryname == 'Work') {
                  findWorkTaskItem = findWorkTasks[index];
                }
                if (widget.categoryname == 'Health') {
                  findHealthTaskItem = findHealthTasks[index];
                  
                }
                if (widget.categoryname == 'Social') {
                  findSocialTaskItem = findSocialTasks[index];
                  
                }
                if (widget.categoryname == 'Technology') {
                  findTechnologyTaskitem = findTechnologyTasks[index];
                  
                }
                if (widget.categoryname == 'Education') {
                  findEducationTaskItem = findEducationTasks[index];
                  
                }
                if (widget.categoryname == 'Fashion') {
                  findFashionTaskItem = findFashionTasks[index];
                  
                }
                if (widget.categoryname == 'Finance') {
                  findFinanceTaskItem = findFinanceTasks[index];
                  
                }
                if (widget.categoryname == 'Travel') {
                  findTravelTaskItem = findTravelTasks[index];
                  
                }
                if (widget.categoryname == 'Food') {
                  findFoodTaskItem = findFoodTasks[index];
                  
                }
                if (widget.categoryname == 'Sports') {
                  findSportsTaskItem = findSportsTasks[index];
                  
                } if(widget.categoryname == 'Home') {
                  findHomeTaskItem = findHomeTasks[index];
                  
                }
                if (widget.categoryname == 'AllTasks') {
                  findAllTaskItem = findAllTasks[index];
                }

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => widget.categoryname == 'Personal'
                        ? _showBottomSheet(context, findPersonalTaskItem)
                        : widget.categoryname == 'Work'
                            ? _showBottomSheetWork(context, findWorkTaskItem)
                            : widget.categoryname == 'Health'
                                ? _showBottomSheetHealth(
                                    context, findHealthTaskItem)
                                : widget.categoryname == 'Social'
                                    ? _showBottomSheetSocial(
                                        context, findSocialTaskItem)
                                    : widget.categoryname == 'Technology'
                                        ? _showBottomSheetTechnology(
                                            context, findTechnologyTaskitem)
                                        : widget.categoryname == 'Education'
                                            ? _showBottomSheetEducation(
                                                context, findEducationTaskItem)
                                            : widget.categoryname == 'Fashion'
                                                ? _showBottomSheetFashion(
                                                    context,
                                                    findFashionTaskItem)
                                                : widget.categoryname ==
                                                        'Finance'
                                                    ? _showBottomSheetFinance(
                                                        context,
                                                        findFinanceTaskItem)
                                                    : widget.categoryname ==
                                                            'Travel'
                                                        ? _showBottomSheetTravel(
                                                            context,
                                                            findTravelTaskItem)
                                                        : widget.categoryname ==
                                                                'Food'
                                                            ? _showBottomSheetFood(
                                                                context,
                                                                findFoodTaskItem)
                                                            : widget.categoryname ==
                                                                    'Sports'
                                                                ? _showBottomSheetSports(
                                                                    context,
                                                                    findSportsTaskItem)
                                                                : widget.categoryname == 'Home' ? _showBottomSheetHome(
                                                                    context,
                                                                    findHomeTaskItem): _goToSpecifiedCategory(context,findAllTaskItem),
                    child: Container(
                      decoration: BoxDecoration(
                          color: 
                          widget.categoryname == 'Personal'
        ? findPersonalTaskItem.color == 0
            ? kYellowLight
            : findPersonalTaskItem.color == 1
                ? kBlueLight
                : kRedLight
        : widget.categoryname == 'Work'
            ? findWorkTaskItem.color == 0
                ? kYellowLight
                : findWorkTaskItem.color == 1
                    ? kBlueLight
                    : kRedLight
            : widget.categoryname == 'Health'
                ? findHealthTaskItem.color == 0
                    ? kYellowLight
                    : findHealthTaskItem.color == 1
                        ? kBlueLight
                        : kRedLight
                : widget.categoryname == 'Social'
                    ? findSocialTaskItem.color == 0
                        ? kYellowLight
                        : findSocialTaskItem.color == 1
                            ? kBlueLight
                            : kRedLight
                    : widget.categoryname == 'Technology'
                        ? findTechnologyTaskitem.color == 0
                            ? kYellowLight
                            : findTechnologyTaskitem.color == 1
                                ? kBlueLight
                                : kRedLight
                        : widget.categoryname == 'Education'
                            ? findEducationTaskItem.color == 0
                                ? kYellowLight
                                : findEducationTaskItem.color == 1
                                    ? kBlueLight
                                    : kRedLight
                            : widget.categoryname == 'Fashion'
                                ? findFashionTaskItem.color == 0
                                    ? kYellowLight
                                    : findFashionTaskItem.color == 1
                                        ? kBlueLight
                                        : kRedLight
                                : widget.categoryname == 'Finance'
                                    ? findFinanceTaskItem.color == 0
                                        ? kYellowLight
                                        : findFinanceTaskItem.color == 1
                                            ? kBlueLight
                                            : kRedLight
                                    : widget.categoryname == 'Travel'
                                        ? findTravelTaskItem.color == 0
                                            ? kYellowLight
                                            : findTravelTaskItem.color == 1
                                                ? kBlueLight
                                                : kRedLight
                                        : widget.categoryname == 'Food'
                                            ? findFoodTaskItem.color == 0
                                                ? kYellowLight
                                                : findFoodTaskItem.color == 1
                                                    ? kBlueLight
                                                    : kRedLight
                                            : widget.categoryname == 'Sports'
                                                ? findSportsTaskItem.color == 0
                                                    ? kYellowLight
                                                    : findSportsTaskItem.color == 1
                                                        ? kBlueLight
                                                        : kRedLight
                                                : widget.categoryname == 'Home' ? findHomeTaskItem.color == 0
                                                    ? kYellowLight
                                                    : findHomeTaskItem.color == 1
                                                        ? kBlueLight
                                                        : kRedLight
                                                : findAllTaskItem.color == 0
                                                    ? kYellowLight
                                                    : findAllTaskItem.color == 1
                                                        ? kBlueLight
                                                        : kRedLight,
                          
                          
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      padding: const EdgeInsets.all(15),
                      // margin: const EdgeInsets.only(
                      //     left: 15, right: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.categoryname == 'Personal'
                                    ? '${findPersonalTaskItem.taskTitle}'
                                    : widget.categoryname == 'Work'
                                        ? '${findWorkTaskItem.taskTitle}'
                                        : widget.categoryname == 'Health'
                                            ? '${findHealthTaskItem.taskTitle}'
                                            : widget.categoryname == 'Social'
                                                ? '${findSocialTaskItem.taskTitle}'
                                                : widget.categoryname ==
                                                        'Technology'
                                                    ? '${findTechnologyTaskitem.taskTitle}'
                                                    : widget.categoryname ==
                                                            'Education'
                                                        ? '${findEducationTaskItem.taskTitle}'
                                                        : widget.categoryname ==
                                                                'Fashion'
                                                            ? '${findFashionTaskItem.taskTitle}'
                                                            : widget.categoryname ==
                                                                    'Finance'
                                                                ? '${findFinanceTaskItem.taskTitle}'
                                                                : widget.categoryname ==
                                                                        'Travel'
                                                                    ? '${findTravelTaskItem.taskTitle}'
                                                                    : widget.categoryname ==
                                                                            'Food'
                                                                        ? '${findFoodTaskItem.taskTitle}'
                                                                        : widget.categoryname ==
                                                                                'Sports'
                                                                            ? '${findSportsTaskItem.taskTitle}'
                                                                            : widget.categoryname == 'Home' ? '${findHomeTaskItem.taskTitle}' : '${findAllTaskItem.taskTitle}',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey.shade500,
                                    size: MediaQuery.sizeOf(context).height *
                                        0.025,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                      // widget.catIndex == 0
                                      //     ? '${findPersonalTaskItem.startTime} - ${findPersonalTaskItem.endTime}'
                                      //     : widget.catIndex == 1
                                      //         ? '${findWorkTaskItem.startTime} - ${findWorkTaskItem.endTime}'
                                      //         : widget.catIndex == 2
                                      //             ? '${findHealthTaskItem.startTime} - ${findHealthTaskItem.endTime}'
                                      //             : '${findSocialTaskItem.startTime} - ${findSocialTaskItem.endTime}',
                                      widget.categoryname == 'Personal'
                                          ? '${findPersonalTaskItem.startTime} - ${findPersonalTaskItem.endTime}'
                                          : widget.categoryname == 'Work'
                                              ? '${findWorkTaskItem.startTime}'
                                              : widget.categoryname == 'Health'
                                                  ? '${findHealthTaskItem.startTime} - ${findHealthTaskItem.endTime}'
                                                  : widget.categoryname ==
                                                          'Social'
                                                      ? '${findSocialTaskItem.startTime} - ${findSocialTaskItem.endTime}'
                                                      : widget.categoryname ==
                                                              'Technology'
                                                          ? '${findTechnologyTaskitem.startTime} - ${findTechnologyTaskitem.endTime}'
                                                          : widget.categoryname ==
                                                                  'Education'
                                                              ? '${findEducationTaskItem.startTime} - ${findEducationTaskItem.endTime}'
                                                              : widget.categoryname ==
                                                                      'Fashion'
                                                                  ? '${findFashionTaskItem.startTime} - ${findFashionTaskItem.endTime}'
                                                                  : widget.categoryname ==
                                                                          'Finance'
                                                                      ? '${findFinanceTaskItem.startTime} - ${findFinanceTaskItem.endTime}'
                                                                      : widget.categoryname ==
                                                                              'Travel'
                                                                          ? '${findTravelTaskItem.startTime} - ${findTravelTaskItem.endTime}'
                                                                          : widget.categoryname == 'Food'
                                                                              ? '${findFoodTaskItem.startTime} - ${findFoodTaskItem.endTime}'
                                                                              : widget.categoryname == 'Sports'
                                                                                  ? '${findSportsTaskItem.startTime} - ${findSportsTaskItem.endTime}'
                                                                                  : widget.categoryname == 'Home' ? '${findHomeTaskItem.startTime} - ${findHomeTaskItem.endTime}' : '${findAllTaskItem.startTime} - ${findAllTaskItem.endTime}',
                                      style: TextStyle(color: Colors.grey.shade500)),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 60.0,
                                width: 0.5,
                                color: Colors.black,
                              ),
                              RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  widget.categoryname == 'Personal'
                                      ? findPersonalTaskItem.isCompleted == 1
                                          ? "COMPLETED"
                                          : "TODO"
                                      : widget.categoryname == 'Work'
                                          ? findWorkTaskItem.isCompleted == 1
                                              ? "COMPLETED"
                                              : "TODO"
                                          : widget.categoryname == 'Health'
                                              ? findHealthTaskItem
                                                          .isCompleted ==
                                                      1
                                                  ? "COMPLETED"
                                                  : "TODO"
                                              : widget.categoryname == 'Social'
                                                  ? findSocialTaskItem
                                                              .isCompleted ==
                                                          1
                                                      ? "COMPLETED"
                                                      : "TODO"
                                                  : widget.categoryname ==
                                                          'Technology'
                                                      ? findTechnologyTaskitem
                                                                  .isCompleted ==
                                                              1
                                                          ? "COMPLETED"
                                                          : "TODO"
                                                      : widget.categoryname ==
                                                              'Education'
                                                          ? findEducationTaskItem
                                                                      .isCompleted ==
                                                                  1
                                                              ? "COMPLETED"
                                                              : "TODO"
                                                          : widget.categoryname ==
                                                                  'Fashion'
                                                              ? findFashionTaskItem
                                                                          .isCompleted ==
                                                                      1
                                                                  ? "COMPLETED"
                                                                  : "TODO"
                                                              : widget.categoryname ==
                                                                      'Finance'
                                                                  ? findFinanceTaskItem
                                                                              .isCompleted ==
                                                                          1
                                                                      ? "COMPLETED"
                                                                      : "TODO"
                                                                  : widget.categoryname ==
                                                                          'Travel'
                                                                      ? findTravelTaskItem.isCompleted ==
                                                                              1
                                                                          ? "COMPLETED"
                                                                          : "TODO"
                                                                      : widget.categoryname ==
                                                                              'Food'
                                                                          ? findFoodTaskItem.isCompleted == 1
                                                                              ? "COMPLETED"
                                                                              : "TODO"
                                                                          : widget.categoryname == 'Sports'
                                                                              ? findSportsTaskItem.isCompleted == 1
                                                                                  ? "COMPLETED"
                                                                                  : "TODO"
                                                                              : widget.categoryname == 'Home' ? findHomeTaskItem.isCompleted == 1
                                                                                  ? "COMPLETED"
                                                                                  : "TODO" : findAllTaskItem.isCompleted == 1 ? "COMPLETED" : "TODO",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
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

// Method to show a bottom sheet with personal task details
  _showBottomSheet(context, PTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                            // setState(() {
                            //     findPersonalTasks = dbTasksList.value;
                            //   });
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deletePersonal(task.id);
                                      //   setState(() {
                                      // findPersonalTasks = dbTasksList.value;
                                      // });
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement(
                                  widget.categoryname);
                              await DBHelper.updateCompletedPersonalTasks(
                                  task.id);
                              // setState(() {
                              //   findPersonalTasks = dbTasksList.value;
                              // });
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await DBHelper.completedCountDecrement(
                                            widget.categoryname);
                                        DBHelper.deletePersonal(task.id);
                                        Get.back();
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with work task details
  _showBottomSheetWork(context, WorkTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                            // setState(() {
                            //     findWorkTasks = dbWorksList.value;
                            //   });
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteWork(task.id);
                                      //     setState(() {
                                      //   findWorkTasks = dbWorksList.value;
                                      // });
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement('Work');
                              await DBHelper.updateCompletedWorkTasks(task.id);
                              // setState(() {
                              //       findWorkTasks = dbWorksList.value;
                              //     });
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await DBHelper.completedCountDecrement(
                                            'Work');
                                        DBHelper.deleteWork(task.id);
                                        Get.back();
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with health task details
  _showBottomSheetHealth(context, HealthTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                            // setState(() {
                            //   findHealthTasks = dbHealthList.value;
                            // });
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteHealth(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement(
                                  widget.categoryname);
                              await DBHelper.updateCompletedHealthTasks(
                                  task.id);
                              // setState(() {
                              //     findHealthTasks = dbHealthList.value;
                              //   });
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Health');
                                        DBHelper.deleteHealth(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with social task details
  _showBottomSheetSocial(context, SocialTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteSocial(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement('Social');
                              await DBHelper.updateCompletedSocialTasks(
                                  task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Social');
                                        DBHelper.deleteSocial(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with social task details
  _showBottomSheetTechnology(context, TechnologyTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteTechnology(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement(
                                  'Technology');
                              await DBHelper.updateCompletedTechnologyTasks(
                                  task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Technology');
                                        DBHelper.deleteTechnology(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with social task details
  _showBottomSheetEducation(context, EducationTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteEducation(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement(
                                  'Education');
                              await DBHelper.updateCompletedEducationTasks(
                                  task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Education');
                                        DBHelper.deleteEducation(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with social task details
  _showBottomSheetFashion(context, FashionTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteFashion(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement('Fashion');
                              await DBHelper.updateCompletedFashionTasks(
                                  task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Fashion');
                                        DBHelper.deleteFashion(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with social task details
  _showBottomSheetFinance(context, FinanceTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteFinance(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement('Finance');
                              await DBHelper.updateCompletedFinanceTasks(
                                  task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Finance');
                                        DBHelper.deleteFinance(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with social task details
  _showBottomSheetTravel(context, TravelTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteTravel(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement('Travel');
                              await DBHelper.updateCompletedTravelTasks(
                                  task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Travel');
                                        DBHelper.deleteTravel(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with social task details
  _showBottomSheetFood(context, FoodTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteFood(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement('Food');
                              await DBHelper.updateCompletedFoodTasks(task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Food');
                                        DBHelper.deleteFood(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

// Method to show a bottom sheet with social task details
  _showBottomSheetSports(context, SportsTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteSports(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement('Sports');
                              await DBHelper.updateCompletedSportsTasks(
                                  task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Sports');
                                        DBHelper.deleteSports(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Method to show a bottom sheet with social task details
  _showBottomSheetHome(context, HomeTasksDB task) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.sizeOf(context).height / 7
            : MediaQuery.sizeOf(context).height / 4.2,
        child: task.isCompleted == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.off(() => EditTask(
                                task: task,
                                date: widget.selectedDate,
                                categoryname: widget.categoryname));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure want to delete this task ?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                    onPressed: () {
                                      DBHelper.deleteHome(task.id);
                                      Get.back();
                                      Get.back();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Yes'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          label: const Text('Delete Task'),
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await DBHelper.completedCountIncrement('Home');
                              await DBHelper.updateCompletedHomeTasks(task.id);
                              Get.back();
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.lightBlue),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Task Completed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure want to delete this task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        await DBHelper.completedCountDecrement(
                                            'Home');
                                        DBHelper.deleteHome(task.id);
                                        Get.back();
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Delete Completed Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
_goToSpecifiedCategory(ctx,AllTasksDB findAllTaskItem){
  switch (findAllTaskItem.category) {
    case 'personal':
      Get.off(()=>Details(categoryname: 'Personal'));
      break;
    case 'work':
      Get.off(()=>Details(categoryname: 'Work'));
      break;
    case 'health':
      Get.off(()=>Details(categoryname: 'Health'));
      break;
    case 'social':
      Get.off(()=>Details(categoryname: 'Social'));
      break;
    case 'technology':
      Get.off(()=>Details(categoryname: 'Technology'));
      break;
    case 'education':
      Get.off(()=>Details(categoryname: 'Education'));
      break;
    case 'fashion':
      Get.off(()=>Details(categoryname: 'Fashion'));
      break;
    case 'finance':
      Get.off(()=>Details(categoryname: 'Finance'));
      break;
    case 'travel':
      Get.off(()=>Details(categoryname: 'Travel'));
      break;
    case 'food':
      Get.off(()=>Details(categoryname: 'Food'));
      break;
    case 'sports':
      Get.off(()=>Details(categoryname: 'Sports'));
      break;
    case 'home':
      Get.off(()=>Details(categoryname: 'Home'));
      break;
    default:
  }
}
}

// Handle the deletion of a category.
Future<void> deletePressed(context, Category category) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content:
          const Text('Are you sure you want to delete the Social category?'),
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
