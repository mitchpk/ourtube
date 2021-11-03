import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ourtube/screens/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0.0),
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
