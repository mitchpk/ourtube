import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ourtube/screens/playlist_page.dart';

import 'models/playlist.dart';
import 'models/track.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlaylistAdapter());
  Hive.registerAdapter(TrackAdapter());
  await Hive.openBox<Playlist>('playlists');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Playlist>('playlists').listenable(),
        builder: (context, Box<Playlist> box, widget) {
          var list = box.values.toList();
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(list[index].name),
              subtitle: Text(list[index].tracks.length.toString() + ' tracks'),
              trailing: Wrap(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.shuffle))
                ],
              ),
              onTap: () {
                //list[index].delete();
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PlaylistPage(list[index]),
                  ),
                );
              },
            ),
            itemCount: list.length,
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
