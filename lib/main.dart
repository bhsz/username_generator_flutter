import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// Entry point of the app
void main() => runApp(MyApp());

// Think of composing widgets like a UI tree
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.blue), home: RandomWords());
  }
}

// _ simply means "private"

// The widget does very little, only creates the state
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

// The state is where the logic actually lies
class _RandomWordsState extends State<RandomWords> {
  final _wordPairs = <WordPair>[];
  final _favourites = <WordPair>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Username Generator")),
        actions: [IconButton(onPressed: _pushSaved, icon: Icon(Icons.list))],
      ),
      body: Center(
        child: _buildWordPairs(),
      ),
    );
  }

  Widget _buildWordPairs() {
    return ListView.builder(itemBuilder: (BuildContext context, int i) {
      if (i.isOdd) return Divider();

      // ~/ means div and floor
      final index = i ~/ 2;
      if (index >= _wordPairs.length) {
        _wordPairs.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_wordPairs[index]);
    });
  }

  Widget _buildRow(WordPair pair) {
    final alreadyFavourited = _favourites.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18)),
      trailing: Icon(
          alreadyFavourited ? Icons.favorite : Icons.favorite_outline,
          color: alreadyFavourited ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadyFavourited) {
            _favourites.remove(pair);
          } else {
            _favourites.add(pair);
          }
        });
      },
    );
  }

  // Navigator is a stack of routes
  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _favourites.map((WordPair pair) {
        return ListTile(
            title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18)));
      });

      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(context: context, tiles: tiles).toList()
          : <Widget>[];

      return Scaffold(
          appBar: AppBar(
            title: Text("Favourites"),
          ),
          body: ListView(
            children: divided,
          ));
    }));
  }
}
