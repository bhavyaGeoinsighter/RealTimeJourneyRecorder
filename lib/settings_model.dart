import 'package:hive/hive.dart';

part 'settings_model.g.dart';


@HiveType(typeId: 2)
class settingsModel {
  @HiveField(0)
  late String resolution = '720p';
  @HiveField(1)
  late bool automatic = false;

  settingsModel({required this.resolution,required this.automatic});

}
