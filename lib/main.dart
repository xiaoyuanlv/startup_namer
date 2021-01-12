import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0), 
        itemBuilder: (context, i) {
          if(i.isOdd) return Divider();
              
          final index = i ~/ 2;
          if(index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return
       Container(

          height: 100,
          width: 300,
        child:
        ListTile(
        title:  Center( child: Text(
          pair.asPascalCase,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              shadows: [
                Shadow(
                    offset: Offset(1, 1),
                    color: Colors.black38,
                    blurRadius: 5),
                Shadow(
                    offset: Offset(-1, -1),
                    color: Colors.white.withOpacity(0.77),
                    blurRadius: 5)
              ],
              color: Colors.white),

        ),
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.indigo : null,
        ),
          onTap: () {
            setState(() {
              if(alreadySaved) {
                _saved.remove(pair);
              } else {
                _saved.add(pair);
              }
            });
          },
        ),

    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
              offset: Offset(10, 10),
              color: Colors.black38,
              blurRadius: 20),
          BoxShadow(
              offset: Offset(-10, -10),
              color: Colors.white.withOpacity(0.85),
              blurRadius: 20)

    ]),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(

      MaterialPageRoute<void>(
        builder: (BuildContext context) {

            final tiles = _saved.map((WordPair pair) {
                  return ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
              },
            );

            final divided = ListTile.divideTiles(
                tiles: tiles,
                context: context
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'),
              ),
              body: ListView(children: divided),
            );

        }
      )
    );
  }

}

class RandomWords extends StatefulWidget {
  @override
   State<RandomWords> createState() => _RandomWordsState();
}
