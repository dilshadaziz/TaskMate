import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:taskmate/constants/colors.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/allTasks.dart';
import 'package:taskmate/screens/details/details.dart';
import 'package:taskmate/screens/details/widgets/search_tasks.dart';

class AllTasksList extends StatefulWidget {
  const AllTasksList({super.key});

  @override
  State<AllTasksList> createState() => _AllTasksListState();
}

class _AllTasksListState extends State<AllTasksList> {
  DateTime _selectedDate = DateTime.now();

  int leftToday = 0;
  int tabbar = 0;


  @override
  void initState() {
    DBHelper.getAllTasks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: tabbar,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(color: Colors.black),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateBar(),
                        _buildTaskTitle(),
                      ],
                    ),
                  ),
                ),
            ),
          ),
          ValueListenableBuilder(
                    valueListenable: dbAllTasksList,
                    builder: (context, allTaskList, child) {
      
                      List<AllTasksDB> allTasksForSelectedDate = allTaskList
      .where((task) =>
          task.date == DateFormat.yMd().format(_selectedDate) ||
          task.repeat == 'Daily')
      .toList();
      
      List<AllTasksDB> allTasksNotCompleted = allTaskList
                            .where((element) => element.isCompleted == 0)
                            .toList();
                        List<AllTasksDB> allTasksCompleted = allTaskList
                            .where((element) => element.isCompleted == 1)
                            .toList();
      
                        List<AllTasksDB> noTasks = allTasksNotCompleted
                            .where((element) =>
                                element.date ==
                                        DateFormat.yMd().format(_selectedDate) &&
                                    element.repeat == 'None' ||
                                element.repeat == 'Daily' ||
                                element.isCompleted == 1)
                            .toList();
                        List<AllTasksDB> noTasks2 = allTasksCompleted
                            .where((element) =>
                                element.date ==
                                        DateFormat.yMd().format(_selectedDate) &&
                                    element.repeat == 'None' &&
                                    element.isCompleted == 1 ||
                                element.repeat == 'Daily')
                            .toList();
      if(allTasksForSelectedDate.isNotEmpty){
        leftToday = allTasksForSelectedDate.length - allTasksForSelectedDate[0].count!;
      }
            if (tabbar == 0 && allTasksNotCompleted.isEmpty || tabbar == 1 && allTasksCompleted.isEmpty || noTasks.isEmpty && tabbar == 0 || noTasks2.isEmpty && tabbar == 1) {
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 1.8,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height / 10,
                                    child: Image.asset(
                                        'assets/images/clipboard.png')),
                                const Text(
                                  'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                          ),
                        );
                      }
      
                      return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: allTasksForSelectedDate.length,
                        (_, index) {
                          if (allTasksForSelectedDate[index].repeat ==
      'Daily' &&
      allTasksForSelectedDate[index]
        .isCompleted ==
      0 && tabbar == 0 || allTasksForSelectedDate[index].date == DateFormat.yMd().format(_selectedDate) && allTasksForSelectedDate[index].isCompleted == 1 && tabbar == 1 || allTasksForSelectedDate[index].repeat == 'Daily' && tabbar ==1 && allTasksForSelectedDate[index].isCompleted == 1) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        horizontalOffset:500,
                                duration: const Duration(milliseconds: 600),
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => _goToSpecifiedCategory(allTasksForSelectedDate[index].category!),
                            child: Container(
                                      decoration: BoxDecoration(
                                          color: allTasksForSelectedDate[index].color == 0
                                              ? kYellowLight
                                              : allTasksForSelectedDate[index].color == 1
                                                  ? kBlueLight
                                                  : kRedLight,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10))),
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15, top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${allTasksForSelectedDate[index].taskTitle}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Colors.grey.shade500,
                                                    size:
                                                        MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.025,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                      '${allTasksForSelectedDate[index].startTime} - ${allTasksForSelectedDate[index].endTime}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade500)),
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                height: 60.0,
                                                width: 0.5,
                                                color: Colors.black,
                                              ),
                                              RotatedBox(
                                                quarterTurns: 3,
                                                child: Text(
                                                  allTasksForSelectedDate[index]
                                                              .isCompleted ==
                                                          1
                                                      ? "COMPLETED"
                                                      : "TODO",
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
                                ),
                              ),
                            );
                          }
                    
                          if (allTasksForSelectedDate[index].date ==
      DateFormat.yMd().format(_selectedDate) && allTasksForSelectedDate[index]
      .isCompleted ==
      0 && tabbar == 0) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              child: SlideAnimation(
                                horizontalOffset:500,
                                duration: const Duration(milliseconds: 600),
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    
                                    onTap: () =>_goToSpecifiedCategory(allTasksForSelectedDate[index].category!),
                                    
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: allTasksForSelectedDate[index].color == 0
                                              ? kYellowLight
                                              : allTasksForSelectedDate[index].color == 1
                                                  ? kBlueLight
                                                  : kRedLight,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10))),
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15, top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${allTasksForSelectedDate[index].taskTitle}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Colors.grey.shade500,
                                                    size:
                                                        MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.025,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                      '${allTasksForSelectedDate[index].startTime} - ${allTasksForSelectedDate[index].endTime}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade500)),
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                height: 60.0,
                                                width: 0.5,
                                                color: Colors.black,
                                              ),
                                              RotatedBox(
                                                quarterTurns: 3,
                                                child: Text(
                                                  allTasksForSelectedDate[index]
                                                              .isCompleted ==
                                                          1
                                                      ? "COMPLETED"
                                                      : "TODO",
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
                                ),
                              ),
                            );
                          } else {
                            return Container(
                            );
                          }
                        },
                      ),
                    );
                    },
                  )
        ],),
      
      ),
    );
  }



  Widget _buildAppBar(context) {
    return ValueListenableBuilder(
      valueListenable: dbAllTasksList,
      builder: (context, allTaskList, child) {

        late List<AllTasksDB> allTasksForSelectedDate;

         
            allTasksForSelectedDate = allTaskList
                .cast<AllTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
                if (allTasksForSelectedDate.isNotEmpty) {
                  leftToday = allTasksForSelectedDate.length - allTasksForSelectedDate[0].count!;
                }
        return SliverAppBar(
        expandedHeight: 90,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
              color: Colors.white,
            )),
            actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: IconButton(
                onPressed: () {
                  Get.to(() => SearchTasks(categoryname: 'AllTasks',selectedDate : _selectedDate),
                      transition: Transition.downToUp,
                      duration: const Duration(milliseconds: 300));
                },
                icon: const Icon(Icons.search,color: Colors.grey,),
                iconSize: 30,
              ),
            )
          ],
        flexibleSpace: FlexibleSpaceBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'All Category Tasks',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: MediaQuery.sizeOf(context).width*0.05),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'You have $leftToday tasks for today!',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
      }
      
    );
  }

   Widget _buildDateBar() {
    return DatePicker(
      DateTime.now(),
      height: 80,
      width: 50,
      initialSelectedDate: DateTime.now(),
      selectionColor: Colors.grey.shade600,
      selectedTextColor: Colors.white,
      monthTextStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
      dayTextStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
      dateTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      onDateChange: (selectedDate) {
        setState(() {
          _selectedDate = selectedDate;
        });
        debugPrint('$_selectedDate');
      },
    );
  }

  Widget _buildTaskTitle() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TabBar(
        dividerColor: Colors.transparent,
        onTap: (value) {
          setState(() {
            tabbar = value;
            print(tabbar);
          });
        },
        tabs: [
          Tab(child: Marquee(text: 'Not Completed Tasks         ')),
          Tab(child: Marquee(text: 'Completed Tasks       ')),
        ],
      ),
    );
  }
  _goToSpecifiedCategory(String category){
  switch (category) {
    case 'personal':
      Get.off(()=>const Details(categoryname: 'Personal'));
      break;
    case 'work':
      Get.off(()=>const Details(categoryname: 'Work'));
      break;
    case 'health':
      Get.off(()=>const Details(categoryname: 'Health'));
      break;
    case 'social':
      Get.off(()=>const Details(categoryname: 'Social'));
      break;
    case 'technology':
      Get.off(()=>const Details(categoryname: 'Technology'));
      break;
    case 'education':
      Get.off(()=>const Details(categoryname: 'Education'));
      break;
    case 'fashion':
      Get.off(()=>const Details(categoryname: 'Fashion'));
      break;
    case 'finance':
      Get.off(()=>const Details(categoryname: 'Finance'));
      break;
    case 'travel':
      Get.off(()=>const Details(categoryname: 'Travel'));
      break;
    case 'food':
      Get.off(()=>const Details(categoryname: 'Food'));
      break;
    case 'sports':
      Get.off(()=>const Details(categoryname: 'Sports'));
      break;
    case 'home':
      Get.off(()=>const Details(categoryname: 'Home'));
      break;
    default:
  }
}
}