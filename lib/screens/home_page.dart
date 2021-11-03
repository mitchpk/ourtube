import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourtube/models/playlist.dart';
import 'package:ourtube/screens/playlist_page.dart';

class HomePage extends StatelessWidget {
  const HomePage(this.playlists, {Key? key}) : super(key: key);
  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    final double boxSize =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        var playlist = playlists[index];
        return InkWell(
          child: SizedBox(
            width: boxSize / 2 - 30,
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  child: CachedNetworkImage(
                    imageUrl: playlist.tracks.isNotEmpty
                        ? playlist.tracks[0].imageUrl
                        : "https://cdn.discordapp.com/attachments/622783387676966937/902351164136357908/unknown.png",
                  ),
                ),
                Text(playlist.name),
                Text(playlist.tracks.length.toString() + " tracks"),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistPage(playlists[index]),
              ),
            );
          },
        );
      },
    );
  }
}
