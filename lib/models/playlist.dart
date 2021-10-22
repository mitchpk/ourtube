import 'package:hive/hive.dart';
import 'package:ourtube/models/track.dart';

part 'playlist.g.dart';

@HiveType(typeId: 1)
class Playlist extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Track> tracks;

  Playlist(this.name) : tracks = [];
}
