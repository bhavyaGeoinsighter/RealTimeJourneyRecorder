import 'package:hive/hive.dart';

part 'journey_model.g.dart';

@HiveType(typeId: 0)
class journeyModel{
  @HiveField(0)
  late String id = "";
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
  late bool isCsvUploaded;
  @HiveField(9)
  late bool isVideoUploaded;

  journeyModel({required this.id, required this.name, required this.description,required this.videoPath,required this.csvPath,required this.createdOn, required this.extra,required this.isCsvUploaded, required this.isVideoUploaded,required this.modifiedOn});

}