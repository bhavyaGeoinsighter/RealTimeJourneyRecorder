import 'package:hive/hive.dart';

part 'token_model.g.dart';


@HiveType(typeId: 1)
class tokenModel {
  @HiveField(0)
  late final String token;

  tokenModel({required this.token});

}
