import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:timerg/Models/project_model.dart';
import 'package:timerg/Models/time_entry_model.dart';
import 'package:timerg/Models/user_model.dart';
import 'package:timerg/providers/data_provider.dart';
import 'package:uuid/uuid.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  FirebaseDatabase database = FirebaseDatabase(
      databaseURL:
          "https://timerg-a31ec-default-rtdb.europe-west1.firebasedatabase.app");

  static const projectDB = 'project';
  static const userDB = 'users';
  static const timeEntryDb = 'time_entry';

  String generateID() {
    const id = Uuid();
    return id.v1();
  }

  // region USERS
  Future<String> createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    final String? id = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference ref = database.ref("$userDB/$id}");
    UserModel user = UserModel(
      id: id,
      email: email,
      password: password,
    );
    await ref.set(user.toJson());

    return 'success';
  }
  // endregion

  // region PROJECTS
  Future<void> createProject(Project project) async {
    String id = generateID();
    project.id = id;
    DatabaseReference ref = database.ref("$projectDB/$id}");

    await ref.set(project.toJson());
  }

  Future<List<Project>> queryAllProjects() async {
    List<Project> projects = [];
    DatabaseReference ref = database.ref("$projectDB");
    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value != null) {
      Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));
      // Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.values.forEach((projectData) {
        Project project = Project.fromJson(projectData);
        projects.add(project);
      });
    } else {
      print('No data available.');
    }

    return projects;
  }
  // endregion

// region TIME ENTRIES
  Future<String?> addTime(TimeEntry timeEntry) async {
    String id = generateID();
    timeEntry.id = id;
    DatabaseReference ref = database.ref("$timeEntryDb/$id}");

    await ref.set(timeEntry.toJson());
    return id;
  }
// endregion
}
