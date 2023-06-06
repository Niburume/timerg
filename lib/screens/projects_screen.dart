import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timerg/components/list_tile.dart';
import 'package:timerg/helpers/db_helper.dart';
import 'package:timerg/providers/data_provider.dart';

import '../Models/project_model.dart';

class ProjectScreen extends StatefulWidget {
  static const routeName = 'porject_screen';

  const ProjectScreen({Key? key}) : super(key: key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<Project> _projects = [];

  void queryProjects() async {
    _projects = await DBHelper.instance.queryAllProjects();
    setState(() {});
  }

  @override
  void initState() {
    queryProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Projects',
          ),
        ),
        body: ListView.builder(
            itemCount: _projects.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Provider.of<DataProvider>(context, listen: false)
                      .setCurrentProject(_projects[i]);
                  Navigator.pop(context, _projects[i].projectName);
                  print(_projects[i].projectName);
                },
                child: ProjectListTile(
                    projectName: _projects[i].projectName,
                    radius: '${_projects[i].radius.toStringAsFixed(0)} M',
                    totalHours: '350'),
              );
            }));
  }
}
