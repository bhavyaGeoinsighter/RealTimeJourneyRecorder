import 'package:hive/hive.dart';

part 'settings_model.g.dart';


@HiveType(typeId: 2)
class settingsModel {
  @HiveField(0)
  late final String resolution;
  @HiveField(1)
  late final bool automatic;

  settingsModel({required this.resolution,required this.automatic});

}
