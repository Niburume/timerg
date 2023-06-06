import 'package:flutter/cupertino.dart';
import 'package:timerg/helpers/db_helper.dart';

import '../Models/project_model.dart';
import '../Models/time_entry_model.dart';

class DataProvider with ChangeNotifier {
  String currentUserId = "";
  List<Project> _projects = [];
  Project? currentProject;
  TimeEntry? _currentTimeEntry;

  List<Project> get projects {
    return [..._projects];
  }

  TimeEntry? get currentTimeEntry {
    return _currentTimeEntry;
  }

  // region USERS
  void setUserId(String userId) {
    currentUserId = userId;
  }

  String getCurrentUserId() {
    return currentUserId;
  }

  // endregion
  // region PROJECTS
  Future<void> getAllProjects() async {
    _projects = await DBHelper.instance.queryAllProjects();
  }

  void setCurrentProject(Project project) {
    currentProject = project;
    notifyListeners();
  }

  // endregion
  // region TIME ENTRIES
  void setCurrentTimeEntry(TimeEntry timeEntry) {
    _currentTimeEntry = timeEntry;
    notifyListeners();
  }

  // endregion
}
