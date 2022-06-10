import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  bool isComplated;

  Task(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.isComplated});

  factory Task.create({required String taskname, required DateTime datetime}) {
    return Task(
        id:const Uuid().v1(),
        name: taskname,
        createdAt: datetime,
        isComplated: false);
  }
}
