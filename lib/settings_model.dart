import 'package:hive/hive.dart';

part 'settings_model.g.dart';


@HiveType(typeId: 2)
class settingsModel {
  @HiveField(0)
  late String resolution = '720p';
  @HiveField(1)
  late bool automatic = false;
  @HiveField(2)
  late bool showMap = false;
  @HiveField(3)
  late String mapType = 'normal';
  @HiveField(4)
  late bool autoPlayPause = false;


  settingsModel({required this.resolution,required this.automatic,required this.showMap,required this.mapType,required this.autoPlayPause});

}
