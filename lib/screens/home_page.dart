import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ourtube/models/playlist.dart';
import 'package:ourtube/screens/playlist_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Playlist>('playlists').listenable(),
        builder: (context, Box<Playlist> box, widget) {
          var playlists = box.values.toList();
          return GridView.extent(
            maxCrossAxisExtent: 300,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            children: [
              for (var playlist in playlists)
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 5,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: playlist.tracks.isNotEmpty
                                    ? playlist.tracks[0].imageUrl
                                    : "https://cdn.discordapp.com/attachments/622783387676966937/902351164136357908/unknown.png",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              playlist.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Row(
                              children: [
                                Text(playlist.tracks.length.toString()),
                                const Icon(Icons.music_note)
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistPage(playlist),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('New playlist'),
              content: TextField(
                autofocus: true,
                onSubmitted: (name) {
                  var playlist = Playlist(name);
                  Hive.box<Playlist>('playlists').add(playlist);
                },
              ),
            ),
          );
        },
        tooltip: 'New playlist',
        child: const Icon(Icons.add),
      ),
    );
  }
}
