// The English words package generates pairs of random words,
// which are used as potential startup names.
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Write Your First Flutter App
// https://codelabs.developers.google.com/codelabs/first-flutter-app-pt1#0
// https://codelabs.developers.google.com/codelabs/first-flutter-app-pt2#0

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 왜 const를 써야하지? 언제는 쓰라고 했다가 다시 지우라고 했다가..
        title: 'Startup Name Generator',
        // use ThemeData to change other aspects of the UI.
        // The Colors class in the Material library provides many color constants that you can play with.
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          )
        ),
        home: const RandomWords(),
    );
  }
}

// stful 이라고 쓰면 자동완성 가능
// class AAA extends StatefulWidget {
//   const AAA({Key? key}) : super(key: key);
//
//   @override
//   State<AAA> createState() => _AAAState();
// }
//
// class _AAAState extends State<AAA> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}
// Dart uses underscores instead of access modifier keywords like public or private
// Prefixing an identifier with an underscore enforces privacy in the Dart language
// and is a recommended best practice for State objects.
// Libraries not only provide APIs, but are a unit of privacy:
// identifiers that start with an underscore (_) are visible only inside the library.
// Every Dart app is a library, even if it doesn’t use a library directive.
class _RandomWordsState extends State<RandomWords> {
  //앞에 붙인 underscore는 어디에서나 이 필드에 접근할 수 있다는 의미(??)
  final _suggestions = <WordPair>[]; // NEW
  // This Set stores the word pairings that the user favorited.
  // Set is preferred to List because a properly implemented Set doesn't allow duplicate entries.
  final _saved = <WordPair>{};
  //여러 곳에서 쓰기 위해 TextStyle을 변수에 담는다
  final _biggerFont = const TextStyle(fontSize: 18); // NEW

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
          ],
        ),
        body: _buildSuggestions());
  }

  void _pushSaved(){
    // Navigator.push pushes the route to the Navigator's stack
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context){
          final tiles = _saved.map( // 요소 각각에 대해 return한 값들을 배열로 반환
            // ListView는 행으로 배열, ListTile은 열로 배열
            (pair) => ListTile(
              title: Text(
                pair.asSnakeCase,
                style: _biggerFont,
              ),
            )
          );
          final dividedTiles = tiles.isNotEmpty
            ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
              ).toList()
            : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: dividedTiles,),
          );
        }
      )
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // 1, 2, 3, 4, 5, ...
        if (i.isOdd) return const Divider();

        // 0, 1, 1, 2, 2, ...
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        final alreadySaved = _saved.contains(_suggestions[index]); // favorite 여부 체크
        // return ListTile(
        //   title: Text(
        //     _suggestions[index].asPascalCase,
        //     style: _biggerFont,
        //   ),
        // );
        return _buildRow(_suggestions[index], alreadySaved);
      },
    );
  }

  Widget _buildRow(WordPair pair, bool alreadySaved) {
    return ListTile(
      title: Transform.rotate(
        angle: -0.2,
        child: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
      ),
      //아이콘 추가 위치
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ), //Icon엔 onTap이 없네
      onTap: (){
        // In Flutter's reactive style framework, calling setState() triggers a call
        // to the build() method for the State object, resulting in an update to the UI.
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}

// The StatefulWidget object is, itself, immutable and can be thrown away and regenerated,
// but the State object persists over the lifetime of the widget.