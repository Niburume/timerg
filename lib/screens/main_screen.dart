import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:timerg/helpers/db_helper.dart';
import 'package:timerg/helpers/geo_controller.dart';

import 'package:timerg/screens/projects_screen.dart';
import 'package:timerg/screens/set_project_screen.dart';
import 'package:timerg/widgets/timer_widget.dart';

import '../widgets/status_widget.dart';

class MainScreen extends StatefulWidget {
  static const routeName = 'main_screen';
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // GeoController.instance.startLocationUpdates();
    checkIfInZoneEvery15Min();

    super.initState();
  }

  void checkIfInZoneEvery15Min() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Logged as ${user?.email} + ${user?.uid}'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, SetProjectScreen.routeName);
                },
                child: Text('Set project screen')),
            ElevatedButton(
                onPressed: () async {
                  DBHelper.instance.queryAllProjects();
                },
                child: Text('Query all projects')),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(context, ProjectScreen.routeName);
                },
                child: Text('Projects')),
            ElevatedButton(
                onPressed: () async {}, child: Text('Start background')),
            ElevatedButton(
                onPressed: () async {
                  showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: 'Dismiss',
                      context: context,
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) {
                        return const StatusW();
                      });
                },
                child: Text('Show Succes')),
            Expanded(child: Container()),
            TimerW(),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
}
