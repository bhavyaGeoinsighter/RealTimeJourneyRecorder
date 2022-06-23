import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String videoPath;
  @HiveField(4)
  final String csvPath;
  @HiveField(5)
  final String createdOn;
  @HiveField(6)
  final String extra;
  @HiveField(7)
  final String modifiedOn;
  @HiveField(8)
  final bool isCsvUploaded;
  @HiveField(9)
  final bool isVideoUploaded;

  TodoModel({required this.id, required this.name, required this.description,required this.videoPath,required this.csvPath,required this.createdOn, required this.extra,required this.isCsvUploaded, required this.isVideoUploaded,required this.modifiedOn});

}