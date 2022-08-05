import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        home: RandomWords());
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
  //여러 곳에서 쓰기 위해 TextStyle을 변수에 담는다
  final _biggerFont = const TextStyle(fontSize: 18); // NEW

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
        ),
        body: _buildSuggestions());
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
        // return ListTile(
        //   title: Text(
        //     _suggestions[index].asPascalCase,
        //     style: _biggerFont,
        //   ),
        // );
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Transform.rotate(
        angle: -0.2,
        child: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
      ),
      //아이콘 추가 위치
    );
  }
}

// The StatefulWidget object is, itself, immutable and can be thrown away and regenerated,
// but the State object persists over the lifetime of the widget.