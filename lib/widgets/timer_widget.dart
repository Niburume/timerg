import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timerg/Models/time_entry_model.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/helpers/db_helper.dart';

import 'package:timerg/screens/main_screen.dart';
import 'package:timerg/screens/projects_screen.dart';
import 'package:timerg/widgets/confimation.dart';

import '../constants/constants.dart';
import '../providers/data_provider.dart';
import 'package:intl/intl.dart';

import '../screens/time_picker_screen.dart';
import 'datePicker.dart';

class TimerSmallWidget extends StatefulWidget {
  const TimerSmallWidget({Key? key}) : super(key: key);

  @override
  State<TimerSmallWidget> createState() => _TimerSmallWidgetState();
}

class _TimerSmallWidgetState extends State<TimerSmallWidget> {
  String currentProjectName = 'Set a project';
  String currentUserId = '';
  Duration duration = Duration();
  Timer? timer;
  bool isRunning = false;
  DateTime timeFrom = DateTime.now();
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
    // startTimer();
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
    return buildTime();
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
                Navigator.pushNamed(context, ProjectScreen.routeName);
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                dateString,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    chooseDateOrSetTime();
                  },
                  child: Text(
                    timeFromDuration(duration),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                      child: timerButton(icon: Icons.stop),
                      onTap: () {
                        stopTimer();
                      },
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

    final timeTo = DateTime.now();

    TimeEntry timeEntry = TimeEntry(
        userId: currentUserId,
        duration: timeFromDuration(duration),
        projectId: project.id!,
        timeFrom: timeFrom,
        timeTo: timeTo,
        autoCheckIn: false);

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
    timeFrom = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    isRunning = true;
    isButtonVisible = false;
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
      isRunning = false;
      isButtonVisible = true;
    });
  }

  void stopTimer() {
    setState(() {
      if (duration != Duration()) isButtonVisible = true;
      if (!isRunning && duration != Duration.zero) {
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
    // if (currentProjectName == 'Set a project') {
    //   Navigator.pushNamed(context, ProjectScreen.routeName);
    // }
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

  void chooseDateOrSetTime() {
    // TimeEntry timeEntry = TimeEntry(
    //     userId: currentUserId,
    //     duration: timeFromDuration(duration),
    //     projectId: project.id!,
    //     timeFrom: timeFrom,
    //     timeTo: timeTo,
    //     autoCheckIn: false);
    Navigator.pushNamed(context, TimePickerScreen.routeName);
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
