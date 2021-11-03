import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourtube/models/playlist.dart';

import 'search_page.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage(this.playlist, {Key? key}) : super(key: key);
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        actions: [
          PopupMenuButton(
            onSelected: (action) {
              switch (action) {
                case 'Remove':
                  playlist.delete();
                  Navigator.pop(context);
              }
            },
            itemBuilder: (context) {
              return {'Remove'}.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: playlist.tracks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(playlist.tracks[index].title),
            subtitle: Text(playlist.tracks[index].duration),
            leading: CachedNetworkImage(
              imageUrl: playlist.tracks[index].imageUrl,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchPage(playlist)));
        },
        tooltip: 'Add track',
        child: const Icon(Icons.add),
      ),
    );
  }
}
