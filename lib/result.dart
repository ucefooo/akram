import 'package:hive/hive.dart';

part 'result.g.dart';

@HiveType(typeId: 1)
class Result {

  Result({required this.imagePath, required this.results, required this.date});

  @HiveField(0)
  String? imagePath;

  @HiveField(1)
  String? results;

  @HiveField(2)
  DateTime? date;

}
