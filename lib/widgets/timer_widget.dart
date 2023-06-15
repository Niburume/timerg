import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:timerg/Models/time_entry_model.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/helpers/db_helper.dart';
import 'package:timerg/helpers/geo_controller.dart';
import 'package:timerg/providers/timer_provider.dart';
import 'package:timerg/screens/choose_project_screen.dart';

import 'package:timerg/screens/main_screen.dart';
import 'package:timerg/screens/projects_screen.dart';
import 'package:timerg/screens/set_project_screen.dart';
import 'package:timerg/widgets/confimation.dart';
import 'package:timerg/widgets/timePicker.dart';

import '../Models/project_model.dart';
import '../constants/constants.dart';
import '../providers/data_provider.dart';
import 'package:intl/intl.dart';

enum Time { start, end }

class TimerW extends StatefulWidget with ChangeNotifier {
  TimerW({Key? key}) : super(key: key);

  @override
  State<TimerW> createState() => _TimerWState();
}

class _TimerWState extends State<TimerW> {
  String currentProjectName = 'Set a project';
  String currentUserId = '';
  Duration duration = Duration();
  Timer? timer;
  bool isRunning = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool isButtonVisible = false;
  DateTime currentDate = DateTime.now();

  String get dateString {
    String formattedDate = DateFormat('yyyy.MM.dd').format(currentDate);
    return formattedDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    currentUserId =
        Provider.of<DataProvider>(context, listen: false).getCurrentUserId();

    super.initState();
    startTracking();
  }

  void startTracking() async {
    List<Project>? projects;
    const interval = tRequestFrequency;
    projects = await Provider.of<DataProvider>(context, listen: false)
        .queryAllProjects();

    Timer.periodic(interval, (Timer timer) async {
      if (projects!.isEmpty) {
        print('empty');
      } else {
        // Get the current position
        Project? foundProject = await GeoController.instance
            .checkDistanceOfProjectsToPosition(projects);

        if (foundProject != null && !isRunning) {
          Provider.of<DataProvider>(context, listen: false)
              .setCurrentProject(foundProject);
          setState(() {});
          startTimer();
        } else if (foundProject == null && isRunning) {
          // timer.cancel();
          stopTimer();
          // saveTimeEntry();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<DataProvider>(context, listen: true)
            .currentProject
            ?.projectName !=
        null) {
      currentProjectName = Provider.of<DataProvider>(context, listen: true)
          .currentProject!
          .projectName;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Switch(
            value: Provider.of<TimerProvider>(context, listen: true).autoMode,
            onChanged: (_) {
              Provider.of<TimerProvider>(context, listen: false)
                  .switchAutoMode();
              setState(() {});
            },
          ),
        ),
        buildTime(),
      ],
    );
  }

  Widget buildTime() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 1),
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ChooseProjectScreen.routeName);
              },
              child: Text(
                currentProjectName,
                maxLines: 2,
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ProjectScreen.routeName);
              },
              child: const Text(
                'SOME TAGS',
                maxLines: 2,
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(hintText: 'type a note here'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        chooseDate();
                      },
                      child: Text(
                        timeFromDuration(duration),
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        chooseDate();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            '$dateString ${DateFormat.EEEE().format(currentDate)}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: isRunning
                              ? timerButton(
                                  icon: Icons.pause,
                                  color: Colors.orange,
                                )
                              : timerButton(
                                  icon: Icons.play_arrow,
                                  color: Colors.greenAccent),
                          onTap: () {
                            if (isRunning) {
                              pauseTimer();
                            } else {
                              startTimer();
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            chooseTime(Time.start, startTime);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                (!isRunning && duration == Duration.zero)
                                    ? Text(
                                        '-//-',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      )
                                    : Text(
                                        '${startTime.hour}:${startTime.minute}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      ),
                                Text(
                                  'start',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: timerButton(icon: Icons.stop),
                          onTap: () {
                            stopTimer();
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            chooseTime(Time.end, endTime);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                (!isRunning && duration != Duration.zero)
                                    ? Text(
                                        '${endTime.hour}:${endTime.minute}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      )
                                    : Text(
                                        '-//-',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      ),
                                Text(
                                  'end',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                  ],
                )
              ],
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            Container(
              height: 50,
              child: Visibility(
                  visible: isButtonVisible,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: AnimatedOpacity(
                    opacity: isButtonVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: GeneralButton(
                      onTap: () {
                        if (currentProjectName == 'Set a project') {
                          showSnackBar(context);
                          return;
                        }
                        showConfirmationDialog();
                      },
                      title: 'ADD TIME',
                      backgroundColor: Colors.greenAccent,
                      textColor: Colors.black,
                      padding: 2,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTimeCard({required String time}) {
    return Container(
      child: Text(
        time,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 40),
      ),
    );
  }

  Widget timerButton({required IconData icon, Color? color}) {
    return Container(
      padding: EdgeInsets.all(5),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blueGrey,
        child: Icon(
          icon,
          size: 40,
          color: color,
        ),
      ),
    );
  }

  void addTime() {
    const addSeconds = 1;

    setState(() {
      if (duration.inHours >= kMaxHours) stopTimer();
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('You have to choose the project...'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Set a project',
        onPressed: () {
          Navigator.pushNamed(context, ProjectScreen.routeName);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void saveTimeEntry() async {
    final project =
        Provider.of<DataProvider>(context, listen: false).currentProject!;

    TimeEntry timeEntry = TimeEntry(
        userId: currentUserId,
        duration: timeFromDuration(duration),
        projectId: project.id!,
        timeFrom: startTime,
        timeTo: endTime,
        note: noteController.text,
        autoAdding:
            Provider.of<TimerProvider>(context, listen: false).autoMode);

    String? entryId = await DBHelper.instance.addTime(timeEntry);
    if (entryId != null) {
      duration = Duration();
    }
    isButtonVisible = false;

    Navigator.pop(context);
    Navigator.pushNamed(context, MainScreen.routeName);
  }

  void startTimer() {
    if (isRunning) return;
    startTime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    isRunning = true;
    isButtonVisible = false;
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
      isRunning = false;
      isButtonVisible = true;
      endTime = DateTime.now();
    });
  }

  void stopTimer() {
    endTime = DateTime.now();
    setState(() {
      if (duration != Duration()) isButtonVisible = true;
      print(!isRunning);
      print(duration);
      if (!isRunning && duration != Duration.zero) {
        print('dialog');
        showGeneralDialog(
            context: context,
            pageBuilder: (_, __, ___) {
              return ConfirmationDialog(
                  dataList: [
                    {
                      'Do you want to reset this time?':
                          timeFromDuration(duration)
                    }
                  ],
                  onOkTap: () {
                    duration = Duration();
                    Navigator.pop(context);
                    isButtonVisible = false;
                    setState(() {});
                  },
                  okTitle: 'Reset');
            });
      }
    });
    timer?.cancel();
    isRunning = false;
  }

  void showConfirmationDialog() {
    showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 400),
        context: context,
        pageBuilder: (_, __, ___) {
          return ConfirmationDialog(dataList: [
            {'Project': currentProjectName},
            {'Time': timeFromDuration(duration)},
            {'Tags': 'here some tag, and on'}
          ], onOkTap: saveTimeEntry, okTitle: 'add');
        });
  }

  void chooseDate() {
    showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.day,
    )
        .then((selectedDate) =>
            {if (selectedDate != null) currentDate = selectedDate})
        .then((value) => setState(() {}));
  }

  void chooseTime(Time timeToSet, DateTime? initialTime) {
    if (isRunning) return;
    initialTime ??= startTime;
    print(initialTime);
    showGeneralDialog(
        barrierDismissible:
            true, // Set to true to dismiss the dialog on tap outside
        barrierLabel: 'Dismiss',
        context: context,
        pageBuilder: (_, __, ___) {
          return TimePickerW(
            onTimeSelected: (DateTime selectedTime) {
              if (timeToSet == Time.start) {
                startTime = selectedTime;
              } else if (timeToSet == Time.end) {
                endTime = selectedTime;
              }
              calculateTotalTime();
              setState(() {});
            },
            initialTime: initialTime,
          );
        });
  }

  void calculateTotalTime() {
    if (startTime == endTime || startTime.isAfter(endTime)) {
      endTime = startTime.add(Duration(minutes: 5));
      duration = endTime.difference(startTime);
    }
  }

  String timeFromDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    String timeString = '$hours:$minutes:$seconds';

    return timeString;
  }
}
