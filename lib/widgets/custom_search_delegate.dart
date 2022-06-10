import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/model/task_model.dart';

import 'package:flutter_todo_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;
  CustomSearchDelegate({required this.allTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, true);
        },
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.blue);
  }

  @override
  Widget buildResults(BuildContext context) {
    //Future<List<Task>> allTask =  locator<LocalStorage>().getAllTask();
    List<Task> filteredList = allTask
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
             // print("search page Listview çalıştı");
              var taskItem = filteredList[index];
              return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.delete, size: 24, color: Colors.white),
                        const SizedBox(width: 30),
                        const Text(
                          "remove_task",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ).tr()
                      ],
                    ),
                  ),
                  key: Key(taskItem.id),
                  onDismissed: (directional) async {
                    filteredList.removeAt(index);
                    await locator<LocalStorage>().deleteTask(task: taskItem);
                  },
                  child: ListItem(taskItem: taskItem));
            },
          )
        : Center(
            child: const Text("search_not_found").tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
