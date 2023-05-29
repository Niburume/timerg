import 'package:flutter/cupertino.dart';
import 'package:timerg/helpers/db_helper.dart';

import '../Models/project_model.dart';

class DataProvider with ChangeNotifier {
  String currentUserId = "";
  List<Project> _projects = [];

  List<Project> get projects {
    return [..._projects];
  }

  // region USERS
  void setUserId(String userId) {
    currentUserId = userId;
  }

  // endregion
// region PROJECTS
  Future<void> getAllProjects() async {
    _projects = await DBHelper.instance.queryAllProjects();
  }
  // endregion
}
