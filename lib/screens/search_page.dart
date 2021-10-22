import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  youtube.YoutubeExplode yt = youtube.YoutubeExplode();
  Future<youtube.SearchPage?>? page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: false,
            decoration: const InputDecoration(
              hintText: 'Search YouTube',
            ),
            onSubmitted: (query) => search(query),
          ),
          suggestionsCallback: (query) async {
            return (await yt.search.getQuerySuggestions(query)).take(5);
          },
          onSuggestionSelected: (String query) => search(query),
          itemBuilder: (context, String suggestion) =>
              ListTile(title: Text(suggestion)),
          hideOnLoading: true,
          hideOnEmpty: true,
        ),
      ),
      body: page != null
          ? FutureBuilder(
              future: page,
              builder: (context, AsyncSnapshot<youtube.SearchPage?> snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  var content = snapshot.data!.searchContent
                      .where((item) =>
                          (item is youtube.SearchVideo && !item.isLive) ||
                          item is youtube.SearchPlaylist)
                      .toList();
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var current = content[index];
                            if (current is youtube.SearchVideo) {
                              return ListTile(
                                title: Text(current.title),
                                subtitle: Text('Video - ' + current.duration),
                                leading: current.thumbnails.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: current.thumbnails[0].url
                                            .toString(),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )
                                    : const Icon(Icons.error),
                                onTap: () {},
                              );
                            } else if (current is youtube.SearchPlaylist) {
                              return ListTile(
                                title: Text(current.playlistTitle),
                                subtitle: Text('Playlist - ' +
                                    current.playlistVideoCount.toString() +
                                    ' videos'),
                                leading: current.thumbnails.isNotEmpty
                                    ? Image.network(
                                        current.thumbnails[0].url.toString())
                                    : null,
                                onTap: () {},
                              );
                            } else {
                              return const ListTile(title: Text('Unknown'));
                            }
                          },
                          itemCount: content.length,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            child: const Text('Load more'),
                            onPressed: () => loadMore(),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : null,
    );
  }

  void search(String query) {
    page = yt.search.getPage(query);
    setState(() {});
  }

  void loadMore() async {
    var current = await page;
    page = current?.nextPage(youtube.YoutubeHttpClient());
    setState(() {});
  }
}
