import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:flutter_todo_app/widgets/custom_search_delegate.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

import '../helper/language_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = [];
    _getAllTaskFromDb();

    /*  _allTasks.add(Task.create(taskname: "Deneme", datetime: DateTime.now()));
    _allTasks.add(Task.create(taskname: "Deneme1", datetime: DateTime.now()));
    _allTasks.add(Task.create(taskname: "Deneme2", datetime: DateTime.now())); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => _showAddTaskBottomSheet(),
          child: const Text(
            "title",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showSearchPage();
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                var taskItem = _allTasks[index];
               // print("home page Listview çalıştı");
                return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.delete,
                              size: 24, color: Colors.white),
                          const SizedBox(width: 30),
                          const Text(
                            "remove_task",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ).tr()
                        ],
                      ),
                    ),
                    key: Key(taskItem.id),
                    onDismissed: (directional) {
                      _allTasks.removeAt(index);
                      _localStorage.deleteTask(task: taskItem);
                      setState(() {});
                    },
                    child: ListItem(taskItem: taskItem));
              },
            )
          : InkWell(
              onTap: () => _showAddTaskBottomSheet(),
              child: Center(
                child: const Text("empty_task_list").tr(),
              ),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListTile(
              title: TextField(
                onSubmitted: ((value) {
                  Navigator.of(context).pop();
                  DatePicker.showTimePicker(
                    context,
                    locale: TranslationHelper.getLanguage(context),
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev =
                          Task.create(taskname: value, datetime: time);
                      _allTasks.insert(0, yeniEklenecekGorev);

                      await _localStorage.addTask(task: yeniEklenecekGorev);

                      setState(() {});
                    },
                  );
                }),
                style: const TextStyle(fontSize: 24),
                decoration: InputDecoration(
                    hintText: "add_task".tr(), border: InputBorder.none),
              ),
            ),
          );
        });
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
  //  print("_getALLTaskFromDb methodu çalıştı");

    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTasks));
    _getAllTaskFromDb();
  }
}
