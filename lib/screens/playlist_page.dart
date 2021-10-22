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
      ),
      body: ListView(),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchPage()));
        },
        tooltip: 'Add track',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
