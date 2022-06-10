import 'package:flutter/material.dart';

import 'package:flutter_todo_app/constants/constants.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:intl/intl.dart';

class ListItem extends StatefulWidget {
  final Task taskItem;
  const ListItem({required this.taskItem, Key? key}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late LocalStorage _localStorage;

  late final TextEditingController _taskNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.taskItem.name;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(1.5, 1.5))
              ]),
          child: ListTile(
              leading: InkWell(
                onTap: () async {
                  widget.taskItem.isComplated =
                      widget.taskItem.isComplated == false ? true : false;

                  await _localStorage.updateTask(task: widget.taskItem);

                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.taskItem.isComplated
                          ? Colors.green
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.black.withOpacity(0.5), width: 1)),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
              ),
              title: widget.taskItem.isComplated
                  ? Text(widget.taskItem.name,
                      style: widget.taskItem.isComplated
                          ? Constants.getComlateTextStyle()
                          : Constants.getIsNotComlateTextStyle())
                  : TextField(
                      controller: _taskNameController,
                      minLines: 1,
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onSubmitted: (yeniDeger) async {
                        if (yeniDeger.length > 3) {
                          widget.taskItem.name = yeniDeger;

                          await _localStorage.updateTask(task: widget.taskItem);
                          setState(() {});
                        }
                      }),
              trailing: Text(
                DateFormat("hh:mm a")
                    .format(widget.taskItem.createdAt),
                style: widget.taskItem.isComplated
                    ? Constants.getComlateTextStyle()
                    : Constants.getIsNotComlateTextStyle(),
              ))),
    );
  }
}
