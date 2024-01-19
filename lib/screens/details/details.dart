import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:taskmate/constants/colors.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/allTasks.dart';
import 'package:taskmate/model/education_task.dart';
import 'package:taskmate/model/fashion_task.dart';
import 'package:taskmate/model/finance_task.dart';
import 'package:taskmate/model/food_task.dart';
// import 'package:taskmate/model/category.dart';
import 'package:taskmate/model/health_task.dart';
import 'package:taskmate/model/home_task.dart';
import 'package:taskmate/model/personal_task.dart';
import 'package:taskmate/model/social_task.dart';
import 'package:taskmate/model/sports_task.dart';
import 'package:taskmate/model/technology_task.dart';
import 'package:taskmate/model/travel_task.dart';
import 'package:taskmate/model/work_task.dart';
// import 'package:taskmate/model/task.dart';
import 'package:taskmate/screens/details/widgets/add_task_bar.dart';
import 'package:taskmate/screens/details/widgets/edit_task.dart';
import 'package:taskmate/screens/details/widgets/search_tasks.dart';
// import 'package:taskmate/services/notify_helper.dart';

class Details extends StatefulWidget {
  final String categoryname;

  const Details({required this.categoryname, super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  DateTime _selectedDate = DateTime.now();

  int leftToday = 0;
  int tabbar = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: tabbar,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: _buildFloatingActionButton(),
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Container(
                // color: SColors.black,
                decoration: const BoxDecoration(color: Colors.black),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, right: 15),
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
            widget.categoryname == 'Personal'
                ? ValueListenableBuilder(
                    valueListenable: dbTasksList,
                    builder: (context, personalList, child) {
                      List<PTasksDB> personalTasksForSelectedDate = personalList
                          .where((task) =>
                              task.date ==
                                  DateFormat.yMd().format(_selectedDate) ||
                              task.repeat == 'Daily')
                          .toList();
                      List<PTasksDB> personalNotCompleted = personalList
                          .where((element) => element.isCompleted == 0)
                          .toList();
                      List<PTasksDB> personalCompleted = personalList
                          .where((element) => element.isCompleted == 1)
                          .toList();

                      List<PTasksDB> noTasks = personalNotCompleted
                          .where((element) =>
                              element.date ==
                                      DateFormat.yMd().format(_selectedDate) &&
                                  element.repeat == 'None' ||
                              element.repeat == 'Daily' ||
                              element.isCompleted == 1)
                          .toList();
                      List<PTasksDB> noTasks2 = personalCompleted
                          .where((element) =>
                              element.date ==
                                      DateFormat.yMd().format(_selectedDate) &&
                                  element.repeat == 'None' &&
                                  element.isCompleted == 1 ||
                              element.repeat == 'Daily')
                          .toList();

                      if (personalTasksForSelectedDate.isNotEmpty) {
                        leftToday = personalTasksForSelectedDate.length -
                            personalTasksForSelectedDate[0].count!;
                      }
                      if (tabbar == 0 && personalNotCompleted.isEmpty ||
                          tabbar == 1 && personalCompleted.isEmpty ||
                          noTasks.isEmpty && tabbar == 0 ||
                          noTasks2.isEmpty && tabbar == 1) {
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
                          childCount: personalTasksForSelectedDate.length,
                          (_, index) {
                            if (personalTasksForSelectedDate[index].repeat ==
                                        'Daily' &&
                                    personalTasksForSelectedDate[index]
                                            .isCompleted ==
                                        0 &&
                                    tabbar == 0 ||
                                personalTasksForSelectedDate[index].date ==
                                        DateFormat.yMd()
                                            .format(_selectedDate) &&
                                    personalTasksForSelectedDate[index]
                                            .isCompleted ==
                                        1 &&
                                    tabbar == 1 ||
                                personalTasksForSelectedDate[index].repeat ==
                                        'Daily' &&
                                    tabbar == 1 &&
                                    personalTasksForSelectedDate[index]
                                            .isCompleted ==
                                        1) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                child: SlideAnimation(
                                  horizontalOffset: 100,
                                  duration: const Duration(milliseconds: 300),
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () => _showBottomSheet(context,
                                          personalTasksForSelectedDate[index]),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: personalTasksForSelectedDate[
                                                            index]
                                                        .color ==
                                                    0
                                                ? kYellowLight
                                                : personalTasksForSelectedDate[
                                                                index]
                                                            .color ==
                                                        1
                                                    ? kBlueLight
                                                    : kRedLight,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                        padding: const EdgeInsets.all(15),
                                        margin: const EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${personalTasksForSelectedDate[index].taskTitle}',
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      color:
                                                          Colors.grey.shade500,
                                                      size: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.025,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                        '${personalTasksForSelectedDate[index].startTime} - ${personalTasksForSelectedDate[index].endTime}',
                                                        style: TextStyle(
                                                            color: Colors.grey
                                                                .shade500)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  height: 60.0,
                                                  width: 0.5,
                                                  color: Colors.black,
                                                ),
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Text(
                                                    personalTasksForSelectedDate[
                                                                    index]
                                                                .isCompleted ==
                                                            1
                                                        ? "COMPLETED"
                                                        : "TODO",
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            // else if(tabbar == 1 && personalTasksForSelectedDate[index].repeat == 'Daily' && personalTasksForSelectedDate[index].isCompleted == 0){
                            //   return Container();
                            // }

                            if (personalTasksForSelectedDate[index].date ==
                                    DateFormat.yMd().format(_selectedDate) &&
                                personalTasksForSelectedDate[index]
                                        .isCompleted ==
                                    0 &&
                                tabbar == 0) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                child: SlideAnimation(
                                  horizontalOffset: 500,
                                  duration: const Duration(milliseconds: 600),
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () => _showBottomSheet(context,
                                          personalTasksForSelectedDate[index]),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: personalTasksForSelectedDate[
                                                            index]
                                                        .color ==
                                                    0
                                                ? kYellowLight
                                                : personalTasksForSelectedDate[
                                                                index]
                                                            .color ==
                                                        1
                                                    ? kBlueLight
                                                    : kRedLight,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                        padding: const EdgeInsets.all(15),
                                        margin: const EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${personalTasksForSelectedDate[index].taskTitle}',
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      color:
                                                          Colors.grey.shade500,
                                                      size: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.025,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                        '${personalTasksForSelectedDate[index].startTime} - ${personalTasksForSelectedDate[index].endTime}',
                                                        style: TextStyle(
                                                            color: Colors.grey
                                                                .shade500)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  height: 60.0,
                                                  width: 0.5,
                                                  color: Colors.black,
                                                ),
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Text(
                                                    personalTasksForSelectedDate[
                                                                    index]
                                                                .isCompleted ==
                                                            1
                                                        ? "COMPLETED"
                                                        : "TODO",
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              return Container();
                            }
                          },
                        ),
                      );
                    },
                  )
                : widget.categoryname == 'Work'
                    ? ValueListenableBuilder(
                        valueListenable: dbWorksList,
                        builder: (context, workList, child) {
                          List<WorkTasksDB> workTasksForSelectedDate = workList
                              .where((task) =>
                                  task.date ==
                                      DateFormat.yMd().format(_selectedDate) ||
                                  task.repeat == 'Daily')
                              .toList();
                          List<WorkTasksDB> workNotCompleted = workList
                              .where((element) => element.isCompleted == 0)
                              .toList();
                          List<WorkTasksDB> workCompleted = workList
                              .where((element) => element.isCompleted == 1)
                              .toList();
                          List<WorkTasksDB> noTasks = workNotCompleted
                              .where((element) =>
                                  element.date ==
                                          DateFormat.yMd()
                                              .format(_selectedDate) &&
                                      element.repeat == 'None' ||
                                  element.repeat == 'Daily' ||
                                  element.isCompleted == 1)
                              .toList();
                          List<WorkTasksDB> noTasks2 = workCompleted
                              .where((element) =>
                                  element.date ==
                                          DateFormat.yMd()
                                              .format(_selectedDate) &&
                                      element.repeat == 'None' &&
                                      element.isCompleted == 1 ||
                                  element.repeat == 'Daily')
                              .toList();

                          if (tabbar == 0 && workNotCompleted.isEmpty ||
                              tabbar == 1 && workCompleted.isEmpty ||
                              noTasks.isEmpty && tabbar == 0 ||
                              noTasks2.isEmpty && tabbar == 1) {
                            return SliverToBoxAdapter(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 1.8,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height /
                                                10,
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
                              childCount: workTasksForSelectedDate.length,
                              (_, index) {
                                if (workTasksForSelectedDate[index].repeat ==
                                            'Daily' &&
                                        workTasksForSelectedDate[index]
                                                .isCompleted ==
                                            0 &&
                                        tabbar == 0 ||
                                    workTasksForSelectedDate[index].date ==
                                            DateFormat.yMd()
                                                .format(_selectedDate) &&
                                        workTasksForSelectedDate[index]
                                                .isCompleted ==
                                            1 &&
                                        tabbar == 1 ||
                                    workTasksForSelectedDate[index].repeat ==
                                            'Daily' &&
                                        tabbar == 1 &&
                                        workTasksForSelectedDate[index]
                                                .isCompleted ==
                                            1) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: SlideAnimation(
                                      horizontalOffset: 500,
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () => _showBottomSheetWork(
                                              context,
                                              workTasksForSelectedDate[index]),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: workTasksForSelectedDate[
                                                                index]
                                                            .color ==
                                                        0
                                                    ? kYellowLight
                                                    : workTasksForSelectedDate[
                                                                    index]
                                                                .color ==
                                                            1
                                                        ? kBlueLight
                                                        : kRedLight,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10))),
                                            padding: const EdgeInsets.all(15),
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 15, top: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${workTasksForSelectedDate[index].taskTitle}',
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.access_time,
                                                          color: Colors
                                                              .grey.shade500,
                                                          size: MediaQuery.sizeOf(
                                                                      context)
                                                                  .height *
                                                              0.025,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                            '${workTasksForSelectedDate[index].startTime} - ${workTasksForSelectedDate[index].endTime}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      height: 60.0,
                                                      width: 0.5,
                                                      color: Colors.black,
                                                    ),
                                                    RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Text(
                                                        workTasksForSelectedDate[
                                                                        index]
                                                                    .isCompleted ==
                                                                1
                                                            ? "COMPLETED"
                                                            : "TODO",
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                if (workTasksForSelectedDate[index].date ==
                                        DateFormat.yMd()
                                            .format(_selectedDate) &&
                                    workTasksForSelectedDate[index]
                                            .isCompleted ==
                                        0 &&
                                    tabbar == 0) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: SlideAnimation(
                                      horizontalOffset: 500,
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () => _showBottomSheetWork(
                                              context,
                                              workTasksForSelectedDate[index]),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: workTasksForSelectedDate[
                                                                index]
                                                            .color ==
                                                        0
                                                    ? kYellowLight
                                                    : workTasksForSelectedDate[
                                                                    index]
                                                                .color ==
                                                            1
                                                        ? kBlueLight
                                                        : kRedLight,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10))),
                                            padding: const EdgeInsets.all(15),
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 15, top: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${workTasksForSelectedDate[index].taskTitle}',
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.access_time,
                                                          color: Colors
                                                              .grey.shade500,
                                                          size: MediaQuery.sizeOf(
                                                                      context)
                                                                  .height *
                                                              0.025,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                            '${workTasksForSelectedDate[index].startTime} - ${workTasksForSelectedDate[index].endTime}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      height: 60.0,
                                                      width: 0.5,
                                                      color: Colors.black,
                                                    ),
                                                    RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Text(
                                                        workTasksForSelectedDate[
                                                                        index]
                                                                    .isCompleted ==
                                                                1
                                                            ? "COMPLETED"
                                                            : "TODO",
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                  return Container();
                                }
                              },
                            ),
                          );
                        },
                      )
                    : widget.categoryname == 'Health'
                        ? ValueListenableBuilder(
                            valueListenable: dbHealthList,
                            builder: (context, healthList, child) {
                              List<HealthTasksDB> healthTasksForSelectedDate =
                                  healthList
                                      .where((task) =>
                                          task.date ==
                                              DateFormat.yMd()
                                                  .format(_selectedDate) ||
                                          task.repeat == 'Daily')
                                      .toList();
                              List<HealthTasksDB> healthNotCompleted =
                                  healthList
                                      .where(
                                          (element) => element.isCompleted == 0)
                                      .toList();
                              List<HealthTasksDB> healthCompleted = healthList
                                  .where((element) => element.isCompleted == 1)
                                  .toList();

                              List<HealthTasksDB> noTasks = healthNotCompleted
                                  .where((element) =>
                                      element.date ==
                                              DateFormat.yMd()
                                                  .format(_selectedDate) &&
                                          element.repeat == 'None' ||
                                      element.repeat == 'Daily' ||
                                      element.isCompleted == 1)
                                  .toList();
                              List<HealthTasksDB> noTasks2 = healthCompleted
                                  .where((element) =>
                                      element.date ==
                                              DateFormat.yMd()
                                                  .format(_selectedDate) &&
                                          element.repeat == 'None' &&
                                          element.isCompleted == 1 ||
                                      element.repeat == 'Daily')
                                  .toList();

                              if (tabbar == 0 && healthNotCompleted.isEmpty ||
                                  tabbar == 1 && healthCompleted.isEmpty ||
                                  noTasks.isEmpty && tabbar == 0 ||
                                  noTasks2.isEmpty && tabbar == 1) {
                                return SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.8,
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                    .height /
                                                10,
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
                                  childCount: healthTasksForSelectedDate.length,
                                  (_, index) {
                                    if (healthTasksForSelectedDate[index]
                                                    .repeat ==
                                                'Daily' &&
                                            healthTasksForSelectedDate[index]
                                                    .isCompleted ==
                                                0 &&
                                            tabbar == 0 ||
                                        healthTasksForSelectedDate[index]
                                                    .date ==
                                                DateFormat.yMd()
                                                    .format(_selectedDate) &&
                                            healthTasksForSelectedDate[index]
                                                    .isCompleted ==
                                                1 &&
                                            tabbar == 1 ||
                                        healthTasksForSelectedDate[index]
                                                    .repeat ==
                                                'Daily' &&
                                            tabbar == 1 &&
                                            healthTasksForSelectedDate[index]
                                                    .isCompleted ==
                                                1) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        child: SlideAnimation(
                                          horizontalOffset: 500,
                                          duration:
                                              const Duration(milliseconds: 600),
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _showBottomSheetHealth(
                                                      context,
                                                      healthTasksForSelectedDate[
                                                          index]),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: healthTasksForSelectedDate[
                                                                    index]
                                                                .color ==
                                                            0
                                                        ? kYellowLight
                                                        : healthTasksForSelectedDate[
                                                                        index]
                                                                    .color ==
                                                                1
                                                            ? kBlueLight
                                                            : kRedLight,
                                                    borderRadius:
                                                        const BorderRadius
                                                            .only(
                                                            topRight: Radius
                                                                .circular(10),
                                                            bottomLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                                padding:
                                                    const EdgeInsets.all(15),
                                                margin: const EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${healthTasksForSelectedDate[index].taskTitle}',
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.access_time,
                                                              color: Colors.grey
                                                                  .shade500,
                                                              size: MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.025,
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                                '${healthTasksForSelectedDate[index].startTime} - ${healthTasksForSelectedDate[index].endTime}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500)),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          height: 60.0,
                                                          width: 0.5,
                                                          color: Colors.black,
                                                        ),
                                                        RotatedBox(
                                                          quarterTurns: 3,
                                                          child: Text(
                                                            healthTasksForSelectedDate[
                                                                            index]
                                                                        .isCompleted ==
                                                                    1
                                                                ? "COMPLETED"
                                                                : "TODO",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                    if (healthTasksForSelectedDate[index]
                                                .date ==
                                            DateFormat.yMd()
                                                .format(_selectedDate) &&
                                        healthTasksForSelectedDate[index]
                                                .isCompleted ==
                                            0 &&
                                        tabbar == 0) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        child: SlideAnimation(
                                          horizontalOffset: 500,
                                          duration:
                                              const Duration(milliseconds: 600),
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _showBottomSheetHealth(
                                                      context,
                                                      healthTasksForSelectedDate[
                                                          index]),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: healthTasksForSelectedDate[
                                                                    index]
                                                                .color ==
                                                            0
                                                        ? kYellowLight
                                                        : healthTasksForSelectedDate[
                                                                        index]
                                                                    .color ==
                                                                1
                                                            ? kBlueLight
                                                            : kRedLight,
                                                    borderRadius:
                                                        const BorderRadius
                                                            .only(
                                                            topRight: Radius
                                                                .circular(10),
                                                            bottomLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                                padding:
                                                    const EdgeInsets.all(15),
                                                margin: const EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${healthTasksForSelectedDate[index].taskTitle}',
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.access_time,
                                                              color: Colors.grey
                                                                  .shade500,
                                                              size: MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.025,
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                                '${healthTasksForSelectedDate[index].startTime} - ${healthTasksForSelectedDate[index].endTime}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500)),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          height: 60.0,
                                                          width: 0.5,
                                                          color: Colors.black,
                                                        ),
                                                        RotatedBox(
                                                          quarterTurns: 3,
                                                          child: Text(
                                                            healthTasksForSelectedDate[
                                                                            index]
                                                                        .isCompleted ==
                                                                    1
                                                                ? "COMPLETED"
                                                                : "TODO",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                      return Container();
                                    }
                                  },
                                ),
                              );
                            },
                          )
                        : widget.categoryname == 'Social'
                            ? ValueListenableBuilder(
                                valueListenable: dbSocialList,
                                builder: (context, socialList, child) {
                                  List<SocialTasksDB>
                                      socialTasksForSelectedDate = socialList
                                          .where((task) =>
                                              task.date ==
                                                  DateFormat.yMd()
                                                      .format(_selectedDate) ||
                                              task.repeat == 'Daily')
                                          .toList();
                                  List<SocialTasksDB> socialNotCompleted =
                                      socialList
                                          .where((element) =>
                                              element.isCompleted == 0)
                                          .toList();
                                  List<SocialTasksDB> socialCompleted =
                                      socialList
                                          .where((element) =>
                                              element.isCompleted == 1)
                                          .toList();

                                  List<SocialTasksDB> noTasks =
                                      socialNotCompleted
                                          .where((element) =>
                                              element.date ==
                                                      DateFormat.yMd().format(
                                                          _selectedDate) &&
                                                  element.repeat == 'None' ||
                                              element.repeat == 'Daily' ||
                                              element.isCompleted == 1)
                                          .toList();
                                  List<SocialTasksDB> noTasks2 = socialCompleted
                                      .where((element) =>
                                          element.date ==
                                                  DateFormat.yMd()
                                                      .format(_selectedDate) &&
                                              element.repeat == 'None' &&
                                              element.isCompleted == 1 ||
                                          element.repeat == 'Daily')
                                      .toList();

                                  if (tabbar == 0 &&
                                          socialNotCompleted.isEmpty ||
                                      tabbar == 1 && socialCompleted.isEmpty ||
                                      noTasks.isEmpty && tabbar == 0 ||
                                      noTasks2.isEmpty && tabbar == 1) {
                                    return SliverToBoxAdapter(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.8,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height /
                                                        10,
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
                                      childCount:
                                          socialTasksForSelectedDate.length,
                                      (_, index) {
                                        if (socialTasksForSelectedDate[index]
                                                        .repeat ==
                                                    'Daily' &&
                                                socialTasksForSelectedDate[
                                                            index]
                                                        .isCompleted ==
                                                    0 &&
                                                tabbar == 0 ||
                                            socialTasksForSelectedDate[
                                                            index]
                                                        .date ==
                                                    DateFormat.yMd().format(
                                                        _selectedDate) &&
                                                socialTasksForSelectedDate[
                                                            index]
                                                        .isCompleted ==
                                                    1 &&
                                                tabbar == 1 ||
                                            socialTasksForSelectedDate[index]
                                                        .repeat ==
                                                    'Daily' &&
                                                tabbar == 1 &&
                                                socialTasksForSelectedDate[
                                                            index]
                                                        .isCompleted ==
                                                    1) {
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            child: SlideAnimation(
                                              horizontalOffset: 500,
                                              duration: const Duration(
                                                  milliseconds: 600),
                                              child: FadeInAnimation(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _showBottomSheetSocial(
                                                          context,
                                                          socialTasksForSelectedDate[
                                                              index]),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: socialTasksForSelectedDate[index]
                                                                    .color ==
                                                                0
                                                            ? kYellowLight
                                                            : socialTasksForSelectedDate[index]
                                                                        .color ==
                                                                    1
                                                                ? kBlueLight
                                                                : kRedLight,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight:
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${socialTasksForSelectedDate[index].taskTitle}',
                                                              style: const TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .access_time,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500,
                                                                  size: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.025,
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                    '${socialTasksForSelectedDate[index].startTime} - ${socialTasksForSelectedDate[index].endTime}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade500)),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              height: 60.0,
                                                              width: 0.5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            RotatedBox(
                                                              quarterTurns: 3,
                                                              child: Text(
                                                                socialTasksForSelectedDate[index]
                                                                            .isCompleted ==
                                                                        1
                                                                    ? "COMPLETED"
                                                                    : "TODO",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                        if (socialTasksForSelectedDate[index]
                                                    .date ==
                                                DateFormat.yMd()
                                                    .format(_selectedDate) &&
                                            socialTasksForSelectedDate[index]
                                                    .isCompleted ==
                                                0 &&
                                            tabbar == 0) {
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            child: SlideAnimation(
                                              horizontalOffset: 500,
                                              duration: const Duration(
                                                  milliseconds: 600),
                                              child: FadeInAnimation(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _showBottomSheetSocial(
                                                          context,
                                                          socialTasksForSelectedDate[
                                                              index]),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: socialTasksForSelectedDate[index]
                                                                    .color ==
                                                                0
                                                            ? kYellowLight
                                                            : socialTasksForSelectedDate[index]
                                                                        .color ==
                                                                    1
                                                                ? kBlueLight
                                                                : kRedLight,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight:
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${socialTasksForSelectedDate[index].taskTitle}',
                                                              style: const TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .access_time,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500,
                                                                  size: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.025,
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                    '${socialTasksForSelectedDate[index].startTime} - ${socialTasksForSelectedDate[index].endTime}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade500)),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              height: 60.0,
                                                              width: 0.5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            RotatedBox(
                                                              quarterTurns: 3,
                                                              child: Text(
                                                                socialTasksForSelectedDate[index]
                                                                            .isCompleted ==
                                                                        1
                                                                    ? "COMPLETED"
                                                                    : "TODO",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                        if (socialTasksForSelectedDate
                                            .isEmpty) {
                                          return Container(
                                              child: const Center(
                                            child: Text("No Tasks"),
                                          ));
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  );
                                },
                              )
                            : widget.categoryname == 'Technology'
                                ? ValueListenableBuilder(
                                    valueListenable: dbTechnologyList,
                                    builder: (context, technologyList, child) {
                                      List<TechnologyTasksDB>
                                          technologyTasksForSelectedDate =
                                          technologyList
                                              .where((task) =>
                                                  task.date ==
                                                      DateFormat.yMd().format(
                                                          _selectedDate) ||
                                                  task.repeat == 'Daily')
                                              .toList();
                                      List<TechnologyTasksDB>
                                          technologyNotCompleted =
                                          technologyList
                                              .where((element) =>
                                                  element.isCompleted == 0)
                                              .toList();
                                      List<TechnologyTasksDB>
                                          technologyCompleted = technologyList
                                              .where((element) =>
                                                  element.isCompleted == 1)
                                              .toList();

                                      List<TechnologyTasksDB> noTasks =
                                          technologyNotCompleted
                                              .where((element) =>
                                                  element.date ==
                                                          DateFormat.yMd().format(
                                                              _selectedDate) &&
                                                      element.repeat ==
                                                          'None' ||
                                                  element.repeat == 'Daily' ||
                                                  element.isCompleted == 1)
                                              .toList();
                                      List<TechnologyTasksDB> noTasks2 =
                                          technologyCompleted
                                              .where((element) =>
                                                  element.date ==
                                                          DateFormat.yMd().format(
                                                              _selectedDate) &&
                                                      element.repeat ==
                                                          'None' &&
                                                      element.isCompleted ==
                                                          1 ||
                                                  element.repeat == 'Daily')
                                              .toList();
                                      if (tabbar == 0 &&
                                              technologyNotCompleted.isEmpty ||
                                          tabbar == 1 &&
                                              technologyCompleted.isEmpty ||
                                          noTasks.isEmpty && tabbar == 0 ||
                                          noTasks2.isEmpty && tabbar == 1) {
                                        return SliverToBoxAdapter(
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.8,
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height /
                                                        10,
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
                                          childCount:
                                              technologyTasksForSelectedDate
                                                  .length,
                                          (_, index) {
                                            if (technologyTasksForSelectedDate[index]
                                                            .repeat ==
                                                        'Daily' &&
                                                    technologyTasksForSelectedDate[
                                                                index]
                                                            .isCompleted ==
                                                        0 &&
                                                    tabbar == 0 ||
                                                technologyTasksForSelectedDate[index]
                                                            .date ==
                                                        DateFormat.yMd().format(
                                                            _selectedDate) &&
                                                    technologyTasksForSelectedDate[
                                                                index]
                                                            .isCompleted ==
                                                        1 &&
                                                    tabbar == 1 ||
                                                technologyTasksForSelectedDate[
                                                                index]
                                                            .repeat ==
                                                        'Daily' &&
                                                    tabbar == 1 &&
                                                    technologyTasksForSelectedDate[
                                                                index]
                                                            .isCompleted ==
                                                        1) {
                                              return AnimationConfiguration
                                                  .staggeredList(
                                                position: index,
                                                child: SlideAnimation(
                                                  horizontalOffset: 500,
                                                  duration: const Duration(
                                                      milliseconds: 600),
                                                  child: FadeInAnimation(
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _showBottomSheetTechnology(
                                                              context,
                                                              technologyTasksForSelectedDate[
                                                                  index]),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: technologyTasksForSelectedDate[index]
                                                                            .color ==
                                                                        0
                                                                    ? kYellowLight
                                                                    : technologyTasksForSelectedDate[index]
                                                                                .color ==
                                                                            1
                                                                        ? kBlueLight
                                                                        : kRedLight,
                                                                borderRadius: const BorderRadius
                                                                    .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${technologyTasksForSelectedDate[index].taskTitle}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .access_time,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade500,
                                                                      size: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.025,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            4),
                                                                    Text(
                                                                        '${technologyTasksForSelectedDate[index].startTime} - ${technologyTasksForSelectedDate[index].endTime}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey.shade500)),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  height: 60.0,
                                                                  width: 0.5,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                RotatedBox(
                                                                  quarterTurns:
                                                                      3,
                                                                  child: Text(
                                                                    technologyTasksForSelectedDate[index].isCompleted ==
                                                                            1
                                                                        ? "COMPLETED"
                                                                        : "TODO",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
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
                                            if (technologyTasksForSelectedDate[
                                                            index]
                                                        .date ==
                                                    DateFormat.yMd().format(
                                                        _selectedDate) &&
                                                technologyTasksForSelectedDate[
                                                            index]
                                                        .isCompleted ==
                                                    0 &&
                                                tabbar == 0) {
                                              return AnimationConfiguration
                                                  .staggeredList(
                                                position: index,
                                                child: SlideAnimation(
                                                  horizontalOffset: 500,
                                                  duration: const Duration(
                                                      milliseconds: 600),
                                                  child: FadeInAnimation(
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _showBottomSheetTechnology(
                                                              context,
                                                              technologyTasksForSelectedDate[
                                                                  index]),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: technologyTasksForSelectedDate[index]
                                                                            .color ==
                                                                        0
                                                                    ? kYellowLight
                                                                    : technologyTasksForSelectedDate[index]
                                                                                .color ==
                                                                            1
                                                                        ? kBlueLight
                                                                        : kRedLight,
                                                                borderRadius: const BorderRadius
                                                                    .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${technologyTasksForSelectedDate[index].taskTitle}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .access_time,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade500,
                                                                      size: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.025,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            4),
                                                                    Text(
                                                                        '${technologyTasksForSelectedDate[index].startTime} - ${technologyTasksForSelectedDate[index].endTime}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey.shade500)),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  height: 60.0,
                                                                  width: 0.5,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                RotatedBox(
                                                                  quarterTurns:
                                                                      3,
                                                                  child: Text(
                                                                    technologyTasksForSelectedDate[index].isCompleted ==
                                                                            1
                                                                        ? "COMPLETED"
                                                                        : "TODO",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
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
                                            if (technologyTasksForSelectedDate
                                                .isEmpty) {
                                              return Container(
                                                  child: const Center(
                                                child: Text("No Tasks"),
                                              ));
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  )
                                : widget.categoryname == 'Education'
                                    ? ValueListenableBuilder(
                                        valueListenable: dbEducationList,
                                        builder:
                                            (context, educationList, child) {
                                          List<EducationTasksDB>
                                              educationTasksForSelectedDate =
                                              educationList
                                                  .where((task) =>
                                                      task.date ==
                                                          DateFormat.yMd().format(
                                                              _selectedDate) ||
                                                      task.repeat == 'Daily')
                                                  .toList();
                                          List<EducationTasksDB>
                                              educationNotCompleted =
                                              educationList
                                                  .where((element) =>
                                                      element.isCompleted == 0)
                                                  .toList();
                                          List<EducationTasksDB>
                                              educationCompleted = educationList
                                                  .where((element) =>
                                                      element.isCompleted == 1)
                                                  .toList();

                                          List<EducationTasksDB> noTasks =
                                              educationNotCompleted
                                                  .where((element) =>
                                                      element.date ==
                                                              DateFormat.yMd()
                                                                  .format(
                                                                      _selectedDate) &&
                                                          element.repeat ==
                                                              'None' ||
                                                      element.repeat ==
                                                          'Daily' ||
                                                      element.isCompleted == 1)
                                                  .toList();
                                          List<EducationTasksDB>
                                              noTasks2 = educationCompleted
                                                  .where((element) =>
                                                      element.date ==
                                                              DateFormat.yMd()
                                                                  .format(
                                                                      _selectedDate) &&
                                                          element.repeat ==
                                                              'None' &&
                                                          element.isCompleted ==
                                                              1 ||
                                                      element.repeat == 'Daily')
                                                  .toList();
                                          if (tabbar == 0 &&
                                                  educationNotCompleted
                                                      .isEmpty ||
                                              tabbar == 1 &&
                                                  educationCompleted.isEmpty ||
                                              noTasks.isEmpty && tabbar == 0 ||
                                              noTasks2.isEmpty && tabbar == 1) {
                                            return SliverToBoxAdapter(
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.8,
                                                child: Center(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height /
                                                                10,
                                                        child: Image.asset(
                                                            'assets/images/clipboard.png')),
                                                    const Text(
                                                      'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            );
                                          }
                                          return SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                              childCount:
                                                  educationTasksForSelectedDate
                                                      .length,
                                              (_, index) {
                                                if (educationTasksForSelectedDate[
                                                                    index]
                                                                .repeat ==
                                                            'Daily' &&
                                                        educationTasksForSelectedDate[
                                                                    index]
                                                                .isCompleted ==
                                                            0 &&
                                                        tabbar == 0 ||
                                                    educationTasksForSelectedDate[
                                                                    index]
                                                                .date ==
                                                            DateFormat.yMd().format(
                                                                _selectedDate) &&
                                                        educationTasksForSelectedDate[
                                                                    index]
                                                                .isCompleted ==
                                                            1 &&
                                                        tabbar == 1 ||
                                                    educationTasksForSelectedDate[
                                                                    index]
                                                                .repeat ==
                                                            'Daily' &&
                                                        tabbar == 1 &&
                                                        educationTasksForSelectedDate[
                                                                    index]
                                                                .isCompleted ==
                                                            1) {
                                                  return AnimationConfiguration
                                                      .staggeredList(
                                                    position: index,
                                                    child: SlideAnimation(
                                                      horizontalOffset: 500,
                                                      duration: const Duration(
                                                          milliseconds: 600),
                                                      child: FadeInAnimation(
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              _showBottomSheetEducation(
                                                                  context,
                                                                  educationTasksForSelectedDate[
                                                                      index]),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: educationTasksForSelectedDate[index].color ==
                                                                            0
                                                                        ? kYellowLight
                                                                        : educationTasksForSelectedDate[index].color ==
                                                                                1
                                                                            ? kBlueLight
                                                                            : kRedLight,
                                                                    borderRadius: const BorderRadius
                                                                        .only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomRight:
                                                                            Radius.circular(10))),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 15,
                                                                    right: 15,
                                                                    top: 15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${educationTasksForSelectedDate[index].taskTitle}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .access_time,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade500,
                                                                          size: MediaQuery.sizeOf(context).height *
                                                                              0.025,
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                4),
                                                                        Text(
                                                                            '${educationTasksForSelectedDate[index].startTime} - ${educationTasksForSelectedDate[index].endTime}',
                                                                            style:
                                                                                TextStyle(color: Colors.grey.shade500)),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      height:
                                                                          60.0,
                                                                      width:
                                                                          0.5,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    RotatedBox(
                                                                      quarterTurns:
                                                                          3,
                                                                      child:
                                                                          Text(
                                                                        educationTasksForSelectedDate[index].isCompleted ==
                                                                                1
                                                                            ? "COMPLETED"
                                                                            : "TODO",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                                if (educationTasksForSelectedDate[
                                                                index]
                                                            .date ==
                                                        DateFormat.yMd().format(
                                                            _selectedDate) &&
                                                    educationTasksForSelectedDate[
                                                                index]
                                                            .isCompleted ==
                                                        0 &&
                                                    tabbar == 0) {
                                                  return AnimationConfiguration
                                                      .staggeredList(
                                                    position: index,
                                                    child: SlideAnimation(
                                                      horizontalOffset: 500,
                                                      duration: const Duration(
                                                          milliseconds: 600),
                                                      child: FadeInAnimation(
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              _showBottomSheetEducation(
                                                                  context,
                                                                  educationTasksForSelectedDate[
                                                                      index]),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: educationTasksForSelectedDate[index].color ==
                                                                            0
                                                                        ? kYellowLight
                                                                        : educationTasksForSelectedDate[index].color ==
                                                                                1
                                                                            ? kBlueLight
                                                                            : kRedLight,
                                                                    borderRadius: const BorderRadius
                                                                        .only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomRight:
                                                                            Radius.circular(10))),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 15,
                                                                    right: 15,
                                                                    top: 15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${educationTasksForSelectedDate[index].taskTitle}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .access_time,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade500,
                                                                          size: MediaQuery.sizeOf(context).height *
                                                                              0.025,
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                4),
                                                                        Text(
                                                                            '${educationTasksForSelectedDate[index].startTime} - ${educationTasksForSelectedDate[index].endTime}',
                                                                            style:
                                                                                TextStyle(color: Colors.grey.shade500)),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      height:
                                                                          60.0,
                                                                      width:
                                                                          0.5,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    RotatedBox(
                                                                      quarterTurns:
                                                                          3,
                                                                      child:
                                                                          Text(
                                                                        educationTasksForSelectedDate[index].isCompleted ==
                                                                                1
                                                                            ? "COMPLETED"
                                                                            : "TODO",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                                if (educationTasksForSelectedDate
                                                    .isEmpty) {
                                                  return Container(
                                                      child: const Center(
                                                    child: Text("No Tasks"),
                                                  ));
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    : widget.categoryname == 'Fashion'
                                        ? ValueListenableBuilder(
                                            valueListenable: dbFashionList,
                                            builder:
                                                (context, fashionList, child) {
                                              List<FashionTasksDB>
                                                  fashionTasksForSelectedDate =
                                                  fashionList
                                                      .where((task) =>
                                                          task.date ==
                                                              DateFormat.yMd()
                                                                  .format(
                                                                      _selectedDate) ||
                                                          task.repeat ==
                                                              'Daily')
                                                      .toList();
                                              List<FashionTasksDB>
                                                  fashionNotCompleted =
                                                  fashionList
                                                      .where((element) =>
                                                          element.isCompleted ==
                                                          0)
                                                      .toList();
                                              List<FashionTasksDB>
                                                  fashionCompleted = fashionList
                                                      .where((element) =>
                                                          element.isCompleted ==
                                                          1)
                                                      .toList();

                                              List<FashionTasksDB> noTasks =
                                                  fashionNotCompleted
                                                      .where((element) =>
                                                          element.date ==
                                                                  DateFormat
                                                                          .yMd()
                                                                      .format(
                                                                          _selectedDate) &&
                                                              element.repeat ==
                                                                  'None' ||
                                                          element.repeat ==
                                                              'Daily' ||
                                                          element.isCompleted ==
                                                              1)
                                                      .toList();
                                              List<FashionTasksDB> noTasks2 =
                                                  fashionCompleted
                                                      .where((element) =>
                                                          element.date ==
                                                                  DateFormat
                                                                          .yMd()
                                                                      .format(
                                                                          _selectedDate) &&
                                                              element.repeat ==
                                                                  'None' &&
                                                              element.isCompleted ==
                                                                  1 ||
                                                          element.repeat ==
                                                              'Daily')
                                                      .toList();
                                              if (tabbar == 0 &&
                                                      fashionNotCompleted
                                                          .isEmpty ||
                                                  tabbar == 1 &&
                                                      fashionCompleted
                                                          .isEmpty ||
                                                  noTasks.isEmpty &&
                                                      tabbar == 0 ||
                                                  noTasks2.isEmpty &&
                                                      tabbar == 1) {
                                                return SliverToBoxAdapter(
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            1.8,
                                                    child: Center(
                                                        child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height /
                                                                10,
                                                            child: Image.asset(
                                                                'assets/images/clipboard.png')),
                                                        const Text(
                                                          'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    )),
                                                  ),
                                                );
                                              }
                                              return SliverList(
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                  childCount:
                                                      fashionTasksForSelectedDate
                                                          .length,
                                                  (_, index) {
                                                    if (fashionTasksForSelectedDate[
                                                                        index]
                                                                    .repeat ==
                                                                'Daily' &&
                                                            fashionTasksForSelectedDate[
                                                                        index]
                                                                    .isCompleted ==
                                                                0 &&
                                                            tabbar == 0 ||
                                                        fashionTasksForSelectedDate[
                                                                        index]
                                                                    .date ==
                                                                DateFormat.yMd()
                                                                    .format(
                                                                        _selectedDate) &&
                                                            fashionTasksForSelectedDate[
                                                                        index]
                                                                    .isCompleted ==
                                                                1 &&
                                                            tabbar == 1 ||
                                                        fashionTasksForSelectedDate[
                                                                        index]
                                                                    .repeat ==
                                                                'Daily' &&
                                                            tabbar == 1 &&
                                                            fashionTasksForSelectedDate[
                                                                        index]
                                                                    .isCompleted ==
                                                                1) {
                                                      return AnimationConfiguration
                                                          .staggeredList(
                                                        position: index,
                                                        child: SlideAnimation(
                                                          horizontalOffset: 500,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      600),
                                                          child:
                                                              FadeInAnimation(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () =>
                                                                  _showBottomSheetFashion(
                                                                      context,
                                                                      fashionTasksForSelectedDate[
                                                                          index]),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: fashionTasksForSelectedDate[index].color ==
                                                                                0
                                                                            ? kYellowLight
                                                                            : fashionTasksForSelectedDate[index].color ==
                                                                                    1
                                                                                ? kBlueLight
                                                                                : kRedLight,
                                                                        borderRadius: const BorderRadius
                                                                            .only(
                                                                            topRight:
                                                                                Radius.circular(10),
                                                                            bottomLeft: Radius.circular(10),
                                                                            bottomRight: Radius.circular(10))),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        15),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        top:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          '${fashionTasksForSelectedDate[index].taskTitle}',
                                                                          style: const TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              color: Colors.grey.shade500,
                                                                              size: MediaQuery.sizeOf(context).height * 0.025,
                                                                            ),
                                                                            const SizedBox(width: 4),
                                                                            Text('${fashionTasksForSelectedDate[index].startTime} - ${fashionTasksForSelectedDate[index].endTime}',
                                                                                style: TextStyle(color: Colors.grey.shade500)),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          height:
                                                                              60.0,
                                                                          width:
                                                                              0.5,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        RotatedBox(
                                                                          quarterTurns:
                                                                              3,
                                                                          child:
                                                                              Text(
                                                                            fashionTasksForSelectedDate[index].isCompleted == 1
                                                                                ? "COMPLETED"
                                                                                : "TODO",
                                                                            style:
                                                                                const TextStyle(
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
                                                    if (fashionTasksForSelectedDate[
                                                                    index]
                                                                .date ==
                                                            DateFormat.yMd().format(
                                                                _selectedDate) &&
                                                        fashionTasksForSelectedDate[
                                                                    index]
                                                                .isCompleted ==
                                                            0 &&
                                                        tabbar == 0) {
                                                      return AnimationConfiguration
                                                          .staggeredList(
                                                        position: index,
                                                        child: SlideAnimation(
                                                          horizontalOffset: 500,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      600),
                                                          child:
                                                              FadeInAnimation(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () =>
                                                                  _showBottomSheetFashion(
                                                                      context,
                                                                      fashionTasksForSelectedDate[
                                                                          index]),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: fashionTasksForSelectedDate[index].color ==
                                                                                0
                                                                            ? kYellowLight
                                                                            : fashionTasksForSelectedDate[index].color ==
                                                                                    1
                                                                                ? kBlueLight
                                                                                : kRedLight,
                                                                        borderRadius: const BorderRadius
                                                                            .only(
                                                                            topRight:
                                                                                Radius.circular(10),
                                                                            bottomLeft: Radius.circular(10),
                                                                            bottomRight: Radius.circular(10))),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        15),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        top:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          '${fashionTasksForSelectedDate[index].taskTitle}',
                                                                          style: const TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              color: Colors.grey.shade500,
                                                                              size: MediaQuery.sizeOf(context).height * 0.025,
                                                                            ),
                                                                            const SizedBox(width: 4),
                                                                            Text('${fashionTasksForSelectedDate[index].startTime} - ${fashionTasksForSelectedDate[index].endTime}',
                                                                                style: TextStyle(color: Colors.grey.shade500)),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          height:
                                                                              60.0,
                                                                          width:
                                                                              0.5,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        RotatedBox(
                                                                          quarterTurns:
                                                                              3,
                                                                          child:
                                                                              Text(
                                                                            fashionTasksForSelectedDate[index].isCompleted == 1
                                                                                ? "COMPLETED"
                                                                                : "TODO",
                                                                            style:
                                                                                const TextStyle(
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
                                                    if (fashionTasksForSelectedDate
                                                        .isEmpty) {
                                                      return Container(
                                                          child: const Center(
                                                        child: Text("No Tasks"),
                                                      ));
                                                    } else {
                                                      return Container();
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : widget.categoryname == 'Finance'
                                            ? ValueListenableBuilder(
                                                valueListenable: dbFinanceList,
                                                builder: (context, financeList,
                                                    child) {
                                                  List<FinanceTasksDB>
                                                      financeTasksForSelectedDate =
                                                      financeList
                                                          .where((task) =>
                                                              task.date ==
                                                                  DateFormat
                                                                          .yMd()
                                                                      .format(
                                                                          _selectedDate) ||
                                                              task.repeat ==
                                                                  'Daily')
                                                          .toList();
                                                  List<FinanceTasksDB>
                                                      financeNotCompleted =
                                                      financeList
                                                          .where((element) =>
                                                              element
                                                                  .isCompleted ==
                                                              0)
                                                          .toList();
                                                  List<FinanceTasksDB>
                                                      financeCompleted =
                                                      financeList
                                                          .where((element) =>
                                                              element
                                                                  .isCompleted ==
                                                              1)
                                                          .toList();

                                                  List<FinanceTasksDB> noTasks =
                                                      financeNotCompleted
                                                          .where((element) =>
                                                              element.date ==
                                                                      DateFormat
                                                                              .yMd()
                                                                          .format(
                                                                              _selectedDate) &&
                                                                  element.repeat ==
                                                                      'None' ||
                                                              element.repeat ==
                                                                  'Daily' ||
                                                              element.isCompleted ==
                                                                  1)
                                                          .toList();
                                                  List<FinanceTasksDB>
                                                      noTasks2 =
                                                      financeCompleted
                                                          .where((element) =>
                                                              element.date ==
                                                                      DateFormat
                                                                              .yMd()
                                                                          .format(
                                                                              _selectedDate) &&
                                                                  element.repeat ==
                                                                      'None' &&
                                                                  element.isCompleted ==
                                                                      1 ||
                                                              element.repeat ==
                                                                  'Daily')
                                                          .toList();
                                                  if (tabbar == 0 &&
                                                          financeNotCompleted
                                                              .isEmpty ||
                                                      tabbar == 1 &&
                                                          financeCompleted
                                                              .isEmpty ||
                                                      noTasks.isEmpty &&
                                                          tabbar == 0 ||
                                                      noTasks2.isEmpty &&
                                                          tabbar == 1) {
                                                    return SliverToBoxAdapter(
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            1.8,
                                                        child: Center(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height /
                                                                    10,
                                                                child: Image.asset(
                                                                    'assets/images/clipboard.png')),
                                                            const Text(
                                                              'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        )),
                                                      ),
                                                    );
                                                  }
                                                  return SliverList(
                                                    delegate:
                                                        SliverChildBuilderDelegate(
                                                      childCount:
                                                          financeTasksForSelectedDate
                                                              .length,
                                                      (_, index) {
                                                        if (financeTasksForSelectedDate[
                                                                            index]
                                                                        .repeat ==
                                                                    'Daily' &&
                                                                financeTasksForSelectedDate[
                                                                            index]
                                                                        .isCompleted ==
                                                                    0 &&
                                                                tabbar == 0 ||
                                                            financeTasksForSelectedDate[
                                                                            index]
                                                                        .date ==
                                                                    DateFormat
                                                                            .yMd()
                                                                        .format(
                                                                            _selectedDate) &&
                                                                financeTasksForSelectedDate[
                                                                            index]
                                                                        .isCompleted ==
                                                                    1 &&
                                                                tabbar == 1 ||
                                                            financeTasksForSelectedDate[
                                                                            index]
                                                                        .repeat ==
                                                                    'Daily' &&
                                                                tabbar == 1 &&
                                                                financeTasksForSelectedDate[
                                                                            index]
                                                                        .isCompleted ==
                                                                    1) {
                                                          return AnimationConfiguration
                                                              .staggeredList(
                                                            position: index,
                                                            child:
                                                                SlideAnimation(
                                                              horizontalOffset:
                                                                  500,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          600),
                                                              child:
                                                                  FadeInAnimation(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () => _showBottomSheetFinance(
                                                                      context,
                                                                      financeTasksForSelectedDate[
                                                                          index]),
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: financeTasksForSelectedDate[index].color == 0
                                                                            ? kYellowLight
                                                                            : financeTasksForSelectedDate[index].color == 1
                                                                                ? kBlueLight
                                                                                : kRedLight,
                                                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        top:
                                                                            15),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '${financeTasksForSelectedDate[index].taskTitle}',
                                                                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.access_time,
                                                                                  color: Colors.grey.shade500,
                                                                                  size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                ),
                                                                                const SizedBox(width: 4),
                                                                                Text('${financeTasksForSelectedDate[index].startTime} - ${financeTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                              height: 60.0,
                                                                              width: 0.5,
                                                                              color: Colors.black,
                                                                            ),
                                                                            RotatedBox(
                                                                              quarterTurns: 3,
                                                                              child: Text(
                                                                                financeTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                        if (financeTasksForSelectedDate[
                                                                        index]
                                                                    .date ==
                                                                DateFormat.yMd()
                                                                    .format(
                                                                        _selectedDate) &&
                                                            financeTasksForSelectedDate[
                                                                        index]
                                                                    .isCompleted ==
                                                                0 &&
                                                            tabbar == 0) {
                                                          return AnimationConfiguration
                                                              .staggeredList(
                                                            position: index,
                                                            child:
                                                                SlideAnimation(
                                                              horizontalOffset:
                                                                  500,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          600),
                                                              child:
                                                                  FadeInAnimation(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () => _showBottomSheetFinance(
                                                                      context,
                                                                      financeTasksForSelectedDate[
                                                                          index]),
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: financeTasksForSelectedDate[index].color == 0
                                                                            ? kYellowLight
                                                                            : financeTasksForSelectedDate[index].color == 1
                                                                                ? kBlueLight
                                                                                : kRedLight,
                                                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        top:
                                                                            15),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '${financeTasksForSelectedDate[index].taskTitle}',
                                                                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.access_time,
                                                                                  color: Colors.grey.shade500,
                                                                                  size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                ),
                                                                                const SizedBox(width: 4),
                                                                                Text('${financeTasksForSelectedDate[index].startTime} - ${financeTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                              height: 60.0,
                                                                              width: 0.5,
                                                                              color: Colors.black,
                                                                            ),
                                                                            RotatedBox(
                                                                              quarterTurns: 3,
                                                                              child: Text(
                                                                                financeTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                        if (financeTasksForSelectedDate
                                                            .isEmpty) {
                                                          return Container(
                                                              child:
                                                                  const Center(
                                                            child: Text(
                                                                "No Tasks"),
                                                          ));
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    ),
                                                  );
                                                },
                                              )
                                            : widget.categoryname == 'Travel'
                                                ? ValueListenableBuilder(
                                                    valueListenable:
                                                        dbTravelList,
                                                    builder: (context,
                                                        travelList, child) {
                                                      List<TravelTasksDB>
                                                          travelTasksForSelectedDate =
                                                          travelList
                                                              .where((task) =>
                                                                  task.date ==
                                                                      DateFormat
                                                                              .yMd()
                                                                          .format(
                                                                              _selectedDate) ||
                                                                  task.repeat ==
                                                                      'Daily')
                                                              .toList();
                                                      List<TravelTasksDB>
                                                          travelNotCompleted =
                                                          travelList
                                                              .where((element) =>
                                                                  element
                                                                      .isCompleted ==
                                                                  0)
                                                              .toList();
                                                      List<TravelTasksDB>
                                                          travelCompleted =
                                                          travelList
                                                              .where((element) =>
                                                                  element
                                                                      .isCompleted ==
                                                                  1)
                                                              .toList();

                                                      List<TravelTasksDB> noTasks = travelNotCompleted
                                                          .where((element) =>
                                                              element.date ==
                                                                      DateFormat
                                                                              .yMd()
                                                                          .format(
                                                                              _selectedDate) &&
                                                                  element.repeat ==
                                                                      'None' ||
                                                              element.repeat ==
                                                                  'Daily' ||
                                                              element.isCompleted ==
                                                                  1)
                                                          .toList();
                                                      List<TravelTasksDB> noTasks2 = travelCompleted
                                                          .where((element) =>
                                                              element.date ==
                                                                      DateFormat
                                                                              .yMd()
                                                                          .format(
                                                                              _selectedDate) &&
                                                                  element.repeat ==
                                                                      'None' &&
                                                                  element.isCompleted ==
                                                                      1 ||
                                                              element.repeat ==
                                                                  'Daily')
                                                          .toList();
                                                      if (tabbar == 0 &&
                                                              travelNotCompleted
                                                                  .isEmpty ||
                                                          tabbar == 1 &&
                                                              travelCompleted
                                                                  .isEmpty ||
                                                          noTasks.isEmpty &&
                                                              tabbar == 0 ||
                                                          noTasks2.isEmpty &&
                                                              tabbar == 1) {
                                                        return SliverToBoxAdapter(
                                                          child: SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                1.8,
                                                            child: Center(
                                                                child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height:
                                                                        MediaQuery.sizeOf(context).height /
                                                                            10,
                                                                    child: Image
                                                                        .asset(
                                                                            'assets/images/clipboard.png')),
                                                                const Text(
                                                                  'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            )),
                                                          ),
                                                        );
                                                      }
                                                      return SliverList(
                                                        delegate:
                                                            SliverChildBuilderDelegate(
                                                          childCount:
                                                              travelTasksForSelectedDate
                                                                  .length,
                                                          (_, index) {
                                                            if (travelTasksForSelectedDate[index]
                                                                            .repeat ==
                                                                        'Daily' &&
                                                                    travelTasksForSelectedDate[index]
                                                                            .isCompleted ==
                                                                        0 &&
                                                                    tabbar ==
                                                                        0 ||
                                                                travelTasksForSelectedDate[index]
                                                                            .date ==
                                                                        DateFormat.yMd().format(
                                                                            _selectedDate) &&
                                                                    travelTasksForSelectedDate[index]
                                                                            .isCompleted ==
                                                                        1 &&
                                                                    tabbar ==
                                                                        1 ||
                                                                travelTasksForSelectedDate[index]
                                                                            .repeat ==
                                                                        'Daily' &&
                                                                    tabbar ==
                                                                        1 &&
                                                                    travelTasksForSelectedDate[index]
                                                                            .isCompleted ==
                                                                        1) {
                                                              return AnimationConfiguration
                                                                  .staggeredList(
                                                                position: index,
                                                                child:
                                                                    SlideAnimation(
                                                                  horizontalOffset:
                                                                      500,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          600),
                                                                  child:
                                                                      FadeInAnimation(
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap: () => _showBottomSheetTravel(
                                                                          context,
                                                                          travelTasksForSelectedDate[
                                                                              index]),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color: travelTasksForSelectedDate[index].color == 0
                                                                                ? kYellowLight
                                                                                : travelTasksForSelectedDate[index].color == 1
                                                                                    ? kBlueLight
                                                                                    : kRedLight,
                                                                            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15,
                                                                            right:
                                                                                15,
                                                                            top:
                                                                                15),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  '${travelTasksForSelectedDate[index].taskTitle}',
                                                                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.access_time,
                                                                                      color: Colors.grey.shade500,
                                                                                      size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                    ),
                                                                                    const SizedBox(width: 4),
                                                                                    Text('${travelTasksForSelectedDate[index].startTime} - ${travelTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                  height: 60.0,
                                                                                  width: 0.5,
                                                                                  color: Colors.black,
                                                                                ),
                                                                                RotatedBox(
                                                                                  quarterTurns: 3,
                                                                                  child: Text(
                                                                                    travelTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                            if (travelTasksForSelectedDate[
                                                                            index]
                                                                        .date ==
                                                                    DateFormat
                                                                            .yMd()
                                                                        .format(
                                                                            _selectedDate) &&
                                                                travelTasksForSelectedDate[
                                                                            index]
                                                                        .isCompleted ==
                                                                    0 &&
                                                                tabbar == 0) {
                                                              return AnimationConfiguration
                                                                  .staggeredList(
                                                                position: index,
                                                                child:
                                                                    SlideAnimation(
                                                                  horizontalOffset:
                                                                      500,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          600),
                                                                  child:
                                                                      FadeInAnimation(
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap: () => _showBottomSheetTravel(
                                                                          context,
                                                                          travelTasksForSelectedDate[
                                                                              index]),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color: travelTasksForSelectedDate[index].color == 0
                                                                                ? kYellowLight
                                                                                : travelTasksForSelectedDate[index].color == 1
                                                                                    ? kBlueLight
                                                                                    : kRedLight,
                                                                            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15,
                                                                            right:
                                                                                15,
                                                                            top:
                                                                                15),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  '${travelTasksForSelectedDate[index].taskTitle}',
                                                                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.access_time,
                                                                                      color: Colors.grey.shade500,
                                                                                      size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                    ),
                                                                                    const SizedBox(width: 4),
                                                                                    Text('${travelTasksForSelectedDate[index].startTime} - ${travelTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                  height: 60.0,
                                                                                  width: 0.5,
                                                                                  color: Colors.black,
                                                                                ),
                                                                                RotatedBox(
                                                                                  quarterTurns: 3,
                                                                                  child: Text(
                                                                                    travelTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                            if (travelTasksForSelectedDate
                                                                .isEmpty) {
                                                              return Container(
                                                                  child:
                                                                      const Center(
                                                                child: Text(
                                                                    "No Tasks"),
                                                              ));
                                                            } else {
                                                              return Container();
                                                            }
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : widget.categoryname == 'Food'
                                                    ? ValueListenableBuilder(
                                                        valueListenable:
                                                            dbFoodList,
                                                        builder: (context,
                                                            foodList, child) {
                                                          List<FoodTasksDB>
                                                              foodTasksForSelectedDate =
                                                              foodList
                                                                  .where((task) =>
                                                                      task.date ==
                                                                          DateFormat.yMd().format(
                                                                              _selectedDate) ||
                                                                      task.repeat ==
                                                                          'Daily')
                                                                  .toList();
                                                          List<FoodTasksDB>
                                                              foodNotCompleted =
                                                              foodList
                                                                  .where((element) =>
                                                                      element
                                                                          .isCompleted ==
                                                                      0)
                                                                  .toList();
                                                          List<FoodTasksDB>
                                                              foodCompleted =
                                                              foodList
                                                                  .where((element) =>
                                                                      element
                                                                          .isCompleted ==
                                                                      1)
                                                                  .toList();

                                                          List<FoodTasksDB> noTasks = foodNotCompleted
                                                              .where((element) =>
                                                                  element.date ==
                                                                          DateFormat.yMd().format(
                                                                              _selectedDate) &&
                                                                      element
                                                                              .repeat ==
                                                                          'None' ||
                                                                  element.repeat ==
                                                                      'Daily' ||
                                                                  element.isCompleted ==
                                                                      1)
                                                              .toList();
                                                          List<FoodTasksDB> noTasks2 = foodCompleted
                                                              .where((element) =>
                                                                  element.date ==
                                                                          DateFormat.yMd().format(
                                                                              _selectedDate) &&
                                                                      element.repeat ==
                                                                          'None' &&
                                                                      element.isCompleted ==
                                                                          1 ||
                                                                  element.repeat ==
                                                                      'Daily')
                                                              .toList();
                                                          if (tabbar == 0 &&
                                                                  foodNotCompleted
                                                                      .isEmpty ||
                                                              tabbar == 1 &&
                                                                  foodCompleted
                                                                      .isEmpty ||
                                                              noTasks.isEmpty &&
                                                                  tabbar == 0 ||
                                                              noTasks2.isEmpty &&
                                                                  tabbar == 1) {
                                                            return SliverToBoxAdapter(
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    1.8,
                                                                child: Center(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            MediaQuery.sizeOf(context).height /
                                                                                10,
                                                                        child: Image.asset(
                                                                            'assets/images/clipboard.png')),
                                                                    const Text(
                                                                      'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ],
                                                                )),
                                                              ),
                                                            );
                                                          }
                                                          return SliverList(
                                                            delegate:
                                                                SliverChildBuilderDelegate(
                                                              childCount:
                                                                  foodTasksForSelectedDate
                                                                      .length,
                                                              (_, index) {
                                                                if (foodTasksForSelectedDate[index].repeat == 'Daily' && foodTasksForSelectedDate[index].isCompleted == 0 && tabbar == 0 ||
                                                                    foodTasksForSelectedDate[index].date ==
                                                                            DateFormat.yMd().format(
                                                                                _selectedDate) &&
                                                                        foodTasksForSelectedDate[index].isCompleted ==
                                                                            1 &&
                                                                        tabbar ==
                                                                            1 ||
                                                                    foodTasksForSelectedDate[index]
                                                                                .repeat ==
                                                                            'Daily' &&
                                                                        tabbar ==
                                                                            1 &&
                                                                        foodTasksForSelectedDate[index].isCompleted ==
                                                                            1) {
                                                                  return AnimationConfiguration
                                                                      .staggeredList(
                                                                    position:
                                                                        index,
                                                                    child:
                                                                        SlideAnimation(
                                                                      horizontalOffset:
                                                                          500,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              600),
                                                                      child:
                                                                          FadeInAnimation(
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap: () => _showBottomSheetFood(
                                                                              context,
                                                                              foodTasksForSelectedDate[index]),
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                color: foodTasksForSelectedDate[index].color == 0
                                                                                    ? kYellowLight
                                                                                    : foodTasksForSelectedDate[index].color == 1
                                                                                        ? kBlueLight
                                                                                        : kRedLight,
                                                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                            padding:
                                                                                const EdgeInsets.all(15),
                                                                            margin: const EdgeInsets.only(
                                                                                left: 15,
                                                                                right: 15,
                                                                                top: 15),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      '${foodTasksForSelectedDate[index].taskTitle}',
                                                                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.access_time,
                                                                                          color: Colors.grey.shade500,
                                                                                          size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                        ),
                                                                                        const SizedBox(width: 4),
                                                                                        Text('${foodTasksForSelectedDate[index].startTime} - ${foodTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                      height: 60.0,
                                                                                      width: 0.5,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    RotatedBox(
                                                                                      quarterTurns: 3,
                                                                                      child: Text(
                                                                                        foodTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                                if (foodTasksForSelectedDate[index]
                                                                            .date ==
                                                                        DateFormat.yMd().format(
                                                                            _selectedDate) &&
                                                                    foodTasksForSelectedDate[index]
                                                                            .isCompleted ==
                                                                        0 &&
                                                                    tabbar ==
                                                                        0) {
                                                                  return AnimationConfiguration
                                                                      .staggeredList(
                                                                    position:
                                                                        index,
                                                                    child:
                                                                        SlideAnimation(
                                                                      horizontalOffset:
                                                                          500,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              600),
                                                                      child:
                                                                          FadeInAnimation(
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap: () => _showBottomSheetFood(
                                                                              context,
                                                                              foodTasksForSelectedDate[index]),
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                color: foodTasksForSelectedDate[index].color == 0
                                                                                    ? kYellowLight
                                                                                    : foodTasksForSelectedDate[index].color == 1
                                                                                        ? kBlueLight
                                                                                        : kRedLight,
                                                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                            padding:
                                                                                const EdgeInsets.all(15),
                                                                            margin: const EdgeInsets.only(
                                                                                left: 15,
                                                                                right: 15,
                                                                                top: 15),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      '${foodTasksForSelectedDate[index].taskTitle}',
                                                                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.access_time,
                                                                                          color: Colors.grey.shade500,
                                                                                          size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                        ),
                                                                                        const SizedBox(width: 4),
                                                                                        Text('${foodTasksForSelectedDate[index].startTime} - ${foodTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                      height: 60.0,
                                                                                      width: 0.5,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    RotatedBox(
                                                                                      quarterTurns: 3,
                                                                                      child: Text(
                                                                                        foodTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                                if (foodTasksForSelectedDate
                                                                    .isEmpty) {
                                                                  return Container(
                                                                      child:
                                                                          const Center(
                                                                    child: Text(
                                                                        "No Tasks"),
                                                                  ));
                                                                } else {
                                                                  return Container();
                                                                }
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : widget.categoryname ==
                                                            'Sports'
                                                        ? ValueListenableBuilder(
                                                            valueListenable:
                                                                dbSportsList,
                                                            builder: (context,
                                                                sportsList,
                                                                child) {
                                                              List<SportsTasksDB>
                                                                  sportsTasksForSelectedDate =
                                                                  sportsList
                                                                      .where((task) =>
                                                                          task.date ==
                                                                              DateFormat.yMd().format(
                                                                                  _selectedDate) ||
                                                                          task.repeat ==
                                                                              'Daily')
                                                                      .toList();
                                                              List<SportsTasksDB>
                                                                  sportsNotCompleted =
                                                                  sportsList
                                                                      .where((element) =>
                                                                          element
                                                                              .isCompleted ==
                                                                          0)
                                                                      .toList();
                                                              List<SportsTasksDB>
                                                                  sportsCompleted =
                                                                  sportsList
                                                                      .where((element) =>
                                                                          element
                                                                              .isCompleted ==
                                                                          1)
                                                                      .toList();

                                                              List<SportsTasksDB> noTasks = sportsNotCompleted
                                                                  .where((element) =>
                                                                      element.date ==
                                                                              DateFormat.yMd().format(
                                                                                  _selectedDate) &&
                                                                          element.repeat ==
                                                                              'None' ||
                                                                      element.repeat ==
                                                                          'Daily' ||
                                                                      element.isCompleted ==
                                                                          1)
                                                                  .toList();
                                                              List<SportsTasksDB> noTasks2 = sportsCompleted
                                                                  .where((element) =>
                                                                      element.date ==
                                                                              DateFormat.yMd().format(
                                                                                  _selectedDate) &&
                                                                          element.repeat ==
                                                                              'None' &&
                                                                          element.isCompleted ==
                                                                              1 ||
                                                                      element.repeat ==
                                                                          'Daily')
                                                                  .toList();
                                                              if (tabbar == 0 && sportsNotCompleted.isEmpty ||
                                                                  tabbar == 1 &&
                                                                      sportsCompleted
                                                                          .isEmpty ||
                                                                  noTasks.isEmpty &&
                                                                      tabbar ==
                                                                          0 ||
                                                                  noTasks2.isEmpty &&
                                                                      tabbar ==
                                                                          1) {
                                                                return SliverToBoxAdapter(
                                                                  child:
                                                                      SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        1.8,
                                                                    child: Center(
                                                                        child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                            height: MediaQuery.sizeOf(context).height /
                                                                                10,
                                                                            child:
                                                                                Image.asset('assets/images/clipboard.png')),
                                                                        const Text(
                                                                          'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ),
                                                                );
                                                              }
                                                              return SliverList(
                                                                delegate:
                                                                    SliverChildBuilderDelegate(
                                                                  childCount:
                                                                      sportsTasksForSelectedDate
                                                                          .length,
                                                                  (_, index) {
                                                                    if (sportsTasksForSelectedDate[index].repeat == 'Daily' && sportsTasksForSelectedDate[index].isCompleted == 0 && tabbar == 0 ||
                                                                        sportsTasksForSelectedDate[index].date == DateFormat.yMd().format(_selectedDate) &&
                                                                            sportsTasksForSelectedDate[index].isCompleted ==
                                                                                1 &&
                                                                            tabbar ==
                                                                                1 ||
                                                                        sportsTasksForSelectedDate[index].repeat == 'Daily' &&
                                                                            tabbar ==
                                                                                1 &&
                                                                            sportsTasksForSelectedDate[index].isCompleted ==
                                                                                1) {
                                                                      return AnimationConfiguration
                                                                          .staggeredList(
                                                                        position:
                                                                            index,
                                                                        child:
                                                                            SlideAnimation(
                                                                          horizontalOffset:
                                                                              500,
                                                                          duration:
                                                                              const Duration(milliseconds: 600),
                                                                          child:
                                                                              FadeInAnimation(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () => _showBottomSheetSports(context, sportsTasksForSelectedDate[index]),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: sportsTasksForSelectedDate[index].color == 0
                                                                                        ? kYellowLight
                                                                                        : sportsTasksForSelectedDate[index].color == 1
                                                                                            ? kBlueLight
                                                                                            : kRedLight,
                                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                                padding: const EdgeInsets.all(15),
                                                                                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${sportsTasksForSelectedDate[index].taskTitle}',
                                                                                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.access_time,
                                                                                              color: Colors.grey.shade500,
                                                                                              size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                            ),
                                                                                            const SizedBox(width: 4),
                                                                                            Text('${sportsTasksForSelectedDate[index].startTime} - ${sportsTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                          height: 60.0,
                                                                                          width: 0.5,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                        RotatedBox(
                                                                                          quarterTurns: 3,
                                                                                          child: Text(
                                                                                            sportsTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                                    if (sportsTasksForSelectedDate[index].date ==
                                                                            DateFormat.yMd().format(
                                                                                _selectedDate) &&
                                                                        sportsTasksForSelectedDate[index].isCompleted ==
                                                                            0 &&
                                                                        tabbar ==
                                                                            0) {
                                                                      return AnimationConfiguration
                                                                          .staggeredList(
                                                                        position:
                                                                            index,
                                                                        child:
                                                                            SlideAnimation(
                                                                          horizontalOffset:
                                                                              500,
                                                                          duration:
                                                                              const Duration(milliseconds: 600),
                                                                          child:
                                                                              FadeInAnimation(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () => _showBottomSheetSports(context, sportsTasksForSelectedDate[index]),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: sportsTasksForSelectedDate[index].color == 0
                                                                                        ? kYellowLight
                                                                                        : sportsTasksForSelectedDate[index].color == 1
                                                                                            ? kBlueLight
                                                                                            : kRedLight,
                                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                                padding: const EdgeInsets.all(15),
                                                                                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${sportsTasksForSelectedDate[index].taskTitle}',
                                                                                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.access_time,
                                                                                              color: Colors.grey.shade500,
                                                                                              size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                            ),
                                                                                            const SizedBox(width: 4),
                                                                                            Text('${sportsTasksForSelectedDate[index].startTime} - ${sportsTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                          height: 60.0,
                                                                                          width: 0.5,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                        RotatedBox(
                                                                                          quarterTurns: 3,
                                                                                          child: Text(
                                                                                            sportsTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                                    if (sportsTasksForSelectedDate
                                                                        .isEmpty) {
                                                                      return Container(
                                                                          child:
                                                                              const Center(
                                                                        child: Text(
                                                                            "No Tasks"),
                                                                      ));
                                                                    } else {
                                                                      return Container();
                                                                    }
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : ValueListenableBuilder(
                                                            valueListenable:
                                                                dbHomeList,
                                                            builder: (context,
                                                                homeList,
                                                                child) {
                                                              List<HomeTasksDB> homeTasksForSelectedDate = homeList
                                                                  .where((task) =>
                                                                      task.date ==
                                                                          DateFormat.yMd().format(
                                                                              _selectedDate) ||
                                                                      task.repeat ==
                                                                          'Daily')
                                                                  .toList();
                                                              List<HomeTasksDB>
                                                                  homeNotCompleted =
                                                                  homeList
                                                                      .where((element) =>
                                                                          element
                                                                              .isCompleted ==
                                                                          0)
                                                                      .toList();
                                                              List<HomeTasksDB>
                                                                  homeCompleted =
                                                                  homeList
                                                                      .where((element) =>
                                                                          element
                                                                              .isCompleted ==
                                                                          1)
                                                                      .toList();

                                                              List<HomeTasksDB> noTasks = homeNotCompleted
                                                                  .where((element) =>
                                                                      element.date ==
                                                                              DateFormat.yMd().format(
                                                                                  _selectedDate) &&
                                                                          element.repeat ==
                                                                              'None' ||
                                                                      element.repeat ==
                                                                          'Daily' ||
                                                                      element.isCompleted ==
                                                                          1)
                                                                  .toList();
                                                              List<HomeTasksDB> noTasks2 = homeCompleted
                                                                  .where((element) =>
                                                                      element.date ==
                                                                              DateFormat.yMd().format(
                                                                                  _selectedDate) &&
                                                                          element.repeat ==
                                                                              'None' &&
                                                                          element.isCompleted ==
                                                                              1 ||
                                                                      element.repeat ==
                                                                          'Daily')
                                                                  .toList();

                                                              if (tabbar == 0 && homeNotCompleted.isEmpty ||
                                                                  tabbar == 1 &&
                                                                      homeCompleted
                                                                          .isEmpty ||
                                                                  noTasks.isEmpty &&
                                                                      tabbar ==
                                                                          0 ||
                                                                  noTasks2.isEmpty &&
                                                                      tabbar ==
                                                                          1) {
                                                                return SliverToBoxAdapter(
                                                                  child:
                                                                      SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        1.8,
                                                                    child: Center(
                                                                        child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                            height: MediaQuery.sizeOf(context).height /
                                                                                10,
                                                                            child:
                                                                                Image.asset('assets/images/clipboard.png')),
                                                                        const Text(
                                                                          'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ),
                                                                );
                                                              }
                                                              return SliverList(
                                                                delegate:
                                                                    SliverChildBuilderDelegate(
                                                                  childCount:
                                                                      homeTasksForSelectedDate
                                                                          .length,
                                                                  (_, index) {
                                                                    if (homeTasksForSelectedDate[index].repeat == 'Daily' && homeTasksForSelectedDate[index].isCompleted == 0 && tabbar == 0 ||
                                                                        homeTasksForSelectedDate[index].date == DateFormat.yMd().format(_selectedDate) &&
                                                                            homeTasksForSelectedDate[index].isCompleted ==
                                                                                1 &&
                                                                            tabbar ==
                                                                                1 ||
                                                                        homeTasksForSelectedDate[index].repeat == 'Daily' &&
                                                                            tabbar ==
                                                                                1 &&
                                                                            homeTasksForSelectedDate[index].isCompleted ==
                                                                                1) {
                                                                      return AnimationConfiguration
                                                                          .staggeredList(
                                                                        position:
                                                                            index,
                                                                        child:
                                                                            SlideAnimation(
                                                                          horizontalOffset:
                                                                              500,
                                                                          duration:
                                                                              const Duration(milliseconds: 600),
                                                                          child:
                                                                              FadeInAnimation(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () => _showBottomSheetHome(context, homeTasksForSelectedDate[index]),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: homeTasksForSelectedDate[index].color == 0
                                                                                        ? kYellowLight
                                                                                        : homeTasksForSelectedDate[index].color == 1
                                                                                            ? kBlueLight
                                                                                            : kRedLight,
                                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                                padding: const EdgeInsets.all(15),
                                                                                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${homeTasksForSelectedDate[index].taskTitle}',
                                                                                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.access_time,
                                                                                              color: Colors.grey.shade500,
                                                                                              size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                            ),
                                                                                            const SizedBox(width: 4),
                                                                                            Text('${homeTasksForSelectedDate[index].startTime} - ${homeTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                          height: 60.0,
                                                                                          width: 0.5,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                        RotatedBox(
                                                                                          quarterTurns: 3,
                                                                                          child: Text(
                                                                                            homeTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                                    if (homeTasksForSelectedDate[index].date ==
                                                                            DateFormat.yMd().format(
                                                                                _selectedDate) &&
                                                                        homeTasksForSelectedDate[index].isCompleted ==
                                                                            0 &&
                                                                        tabbar ==
                                                                            0) {
                                                                      return AnimationConfiguration
                                                                          .staggeredList(
                                                                        position:
                                                                            index,
                                                                        child:
                                                                            SlideAnimation(
                                                                          horizontalOffset:
                                                                              500,
                                                                          duration:
                                                                              const Duration(milliseconds: 600),
                                                                          child:
                                                                              FadeInAnimation(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () => _showBottomSheetHome(context, homeTasksForSelectedDate[index]),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: homeTasksForSelectedDate[index].color == 0
                                                                                        ? kYellowLight
                                                                                        : homeTasksForSelectedDate[index].color == 1
                                                                                            ? kBlueLight
                                                                                            : kRedLight,
                                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                                padding: const EdgeInsets.all(15),
                                                                                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${homeTasksForSelectedDate[index].taskTitle}',
                                                                                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.access_time,
                                                                                              color: Colors.grey.shade500,
                                                                                              size: MediaQuery.sizeOf(context).height * 0.025,
                                                                                            ),
                                                                                            const SizedBox(width: 4),
                                                                                            Text('${homeTasksForSelectedDate[index].startTime} - ${homeTasksForSelectedDate[index].endTime}', style: TextStyle(color: Colors.grey.shade500)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                          height: 60.0,
                                                                                          width: 0.5,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                        RotatedBox(
                                                                                          quarterTurns: 3,
                                                                                          child: Text(
                                                                                            homeTasksForSelectedDate[index].isCompleted == 1 ? "COMPLETED" : "TODO",
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
                                                                    if (homeTasksForSelectedDate
                                                                        .isEmpty) {
                                                                      return Container(
                                                                          child:
                                                                              const Center(
                                                                        child: Text(
                                                                            "No Tasks"),
                                                                      ));
                                                                    } else {
                                                                      return Container();
                                                                    }
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          )
          ],
        ),
      ),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () async {
        DBHelper.getPersonal();
        dynamic result = await Get.to(
            () => AddTaskPage(
                  categoryname: widget.categoryname,
                ),
            transition: Transition.size);
        print(result);

        if (result != '') {
          if (result == null) {
            return;
          }
          Get.snackbar(
            result,
            'Task added successfully!',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            icon: const Icon(
              Icons.check_circle_outline,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildAppBar(context) {
    return ValueListenableBuilder(
        valueListenable: widget.categoryname == 'Personal'
            ? dbTasksList
            : widget.categoryname == 'Work'
                ? dbWorksList
                : widget.categoryname == 'Health'
                    ? dbHealthList
                    : widget.categoryname == 'Social'
                        ? dbSocialList
                        : widget.categoryname == 'Technology'
                            ? dbTechnologyList
                            : widget.categoryname == 'Education'
                                ? dbEducationList
                                : widget.categoryname == 'Fashion'
                                    ? dbFashionList
                                    : widget.categoryname == 'Finance'
                                        ? dbFinanceList
                                        : widget.categoryname == 'Travel'
                                            ? dbTravelList
                                            : widget.categoryname == 'Food'
                                                ? dbFoodList
                                                : widget.categoryname ==
                                                        'Sports'
                                                    ? dbSportsList
                                                    : widget.categoryname ==
                                                            'Home'
                                                        ? dbHomeList
                                                        : dbAllTasksList,
        builder: (context, taskList, child) {
          late List<PTasksDB> personalTasksForSelectedDate;
          late List<WorkTasksDB> workTasksForSelectedDate;
          late List<HealthTasksDB> healthTasksForSelectedDate;
          late List<SocialTasksDB> socialTasksForSelectedDate;
          late List<TechnologyTasksDB> technologyTasksForSelectedDate;
          late List<EducationTasksDB> educationTasksForSelectedDate;
          late List<FashionTasksDB> fashionTasksForSelectedDate;
          late List<FinanceTasksDB> financeTasksForSelectedDate;
          late List<TravelTasksDB> travelTasksForSelectedDate;
          late List<FoodTasksDB> foodTasksForSelectedDate;
          late List<SportsTasksDB> sportsTasksForSelectedDate;
          late List<HomeTasksDB> homeTasksForSelectedDate;
          late List<AllTasksDB> allTasksForSelectedDate;

          if (widget.categoryname == 'Personal') {
            personalTasksForSelectedDate = taskList
                .cast<PTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Work') {
            workTasksForSelectedDate = taskList
                .cast<WorkTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Health') {
            healthTasksForSelectedDate = taskList
                .cast<HealthTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Social') {
            socialTasksForSelectedDate = taskList
                .cast<SocialTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Technology') {
            technologyTasksForSelectedDate = taskList
                .cast<TechnologyTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Education') {
            educationTasksForSelectedDate = taskList
                .cast<EducationTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Fashion') {
            fashionTasksForSelectedDate = taskList
                .cast<FashionTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Finance') {
            financeTasksForSelectedDate = taskList
                .cast<FinanceTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Travel') {
            travelTasksForSelectedDate = taskList
                .cast<TravelTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Food') {
            foodTasksForSelectedDate = taskList
                .cast<FoodTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Sports') {
            sportsTasksForSelectedDate = taskList
                .cast<SportsTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else if (widget.categoryname == 'Home') {
            homeTasksForSelectedDate = taskList
                .cast<HomeTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          } else {
            allTasksForSelectedDate = taskList
                .cast<AllTasksDB>()
                .where((task) =>
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily')
                .toList();
          }
          if (widget.categoryname == 'Personal') {
            if (personalTasksForSelectedDate.isNotEmpty) {
              leftToday = personalTasksForSelectedDate.length -
                  personalTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Work') {
            if (workTasksForSelectedDate.isNotEmpty) {
              leftToday = workTasksForSelectedDate.length -
                  workTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Health') {
            if (healthTasksForSelectedDate.isNotEmpty) {
              leftToday = healthTasksForSelectedDate.length -
                  healthTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Social') {
            if (socialTasksForSelectedDate.isNotEmpty) {
              leftToday = socialTasksForSelectedDate.length -
                  socialTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Technology') {
            if (technologyTasksForSelectedDate.isNotEmpty) {
              leftToday = technologyTasksForSelectedDate.length -
                  technologyTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Education') {
            if (educationTasksForSelectedDate.isNotEmpty) {
              leftToday = educationTasksForSelectedDate.length -
                  educationTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Fashion') {
            if (fashionTasksForSelectedDate.isNotEmpty) {
              leftToday = fashionTasksForSelectedDate.length -
                  fashionTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Finance') {
            if (financeTasksForSelectedDate.isNotEmpty) {
              leftToday = financeTasksForSelectedDate.length -
                  financeTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Travel') {
            if (travelTasksForSelectedDate.isNotEmpty) {
              leftToday = travelTasksForSelectedDate.length -
                  travelTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Food') {
            if (foodTasksForSelectedDate.isNotEmpty) {
              leftToday = foodTasksForSelectedDate.length -
                  foodTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Sports') {
            if (sportsTasksForSelectedDate.isNotEmpty) {
              leftToday = sportsTasksForSelectedDate.length -
                  sportsTasksForSelectedDate[0].count!;
            }
          } else if (widget.categoryname == 'Home') {
            if (homeTasksForSelectedDate.isNotEmpty) {
              leftToday = homeTasksForSelectedDate.length -
                  homeTasksForSelectedDate[0].count!;
            }
          } else {
            if (allTasksForSelectedDate.isNotEmpty) {
              leftToday = allTasksForSelectedDate.length -
                  allTasksForSelectedDate[0].count!;
            }
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
                    Get.to(
                        () => SearchTasks(
                            categoryname: widget.categoryname,
                            selectedDate: _selectedDate),
                        transition: Transition.downToUp,
                        duration: const Duration(milliseconds: 300));
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
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
                    '${widget.categoryname} tasks',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'You have $leftToday tasks for today!',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          );
        });
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
          Tab(
            child: Marquee(text: 'Not Completed Tasks         '),
          ),
          Tab(child: Marquee(text: 'Completed Tasks     ')),
        ],
      ),
    );
  }

  // Widget _buildCard(
  //     title, start, end, int color, int id, int isCompleted, index) {
  //   // isCompleted = 1 ;
  //   debugPrint('listed title : $title');
  //   return
  // }

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
                          onPressed: () async {
                            dynamic result = await Get.off(() => EditTask(
                                task: task,
                                date: _selectedDate,
                                categoryname: widget.categoryname));
                            if (result != '') {
                              if (result == null) {
                                return;
                              }
                              Get.snackbar(
                                result,
                                'Task updated successfully!',
                                colorText: Colors.white,
                                backgroundColor: Colors.green,
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                ),
                                margin: const EdgeInsets.all(10),
                                forwardAnimationCurve: Curves.decelerate,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
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
                            Get.off(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
                            Get.to(() => EditTask(
                                task: task,
                                date: _selectedDate,
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
}
