import 'package:hive/hive.dart';

part 'track.g.dart';

@HiveType(typeId: 0)
class Track extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String duration;

  @HiveField(3)
  String author;

  @HiveField(4)
  String imageUrl;

  Track(this.id, this.title, this.duration, this.author, this.imageUrl);
}
