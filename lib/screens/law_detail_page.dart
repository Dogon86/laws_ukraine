import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LawDetailPage extends StatefulWidget {
  final String filePath;
  final String fileName;
  int _totalMatches = 0;

  LawDetailPage({required this.filePath, required this.fileName});

  @override
  _LawDetailPageState createState() => _LawDetailPageState();
}

class _LawDetailPageState extends State<LawDetailPage> {
  String _lawText = '';
  String _searchText = '';
  int _currentMatchIndex = 0;

  final _scrollController = ScrollController(); // Add ScrollController

  void _onForwardButtonPressed() {
    final matches =
        RegExp(_searchText, caseSensitive: false).allMatches(_lawText);
    if (matches.isNotEmpty) {
      if (_currentMatchIndex < matches.length - 1) {
        setState(() {
          _currentMatchIndex++;
          widget._totalMatches = matches.length;
        });
      } else {
        // We have reached the end of matches, go back to the first match
        setState(() {
          _currentMatchIndex = 0;
          widget._totalMatches = matches.length;
        });
      }
      _scrollController.animateTo(
          matches.elementAt(_currentMatchIndex).start.toDouble(),
          duration: Duration(milliseconds: 100),
          curve: Curves.ease); // Scroll to match
    }
  }

  void _onBackwardButtonPressed() {
    final matches =
        RegExp(_searchText, caseSensitive: false).allMatches(_lawText);
    if (matches.isNotEmpty) {
      if (_currentMatchIndex > 0) {
        setState(() {
          _currentMatchIndex--;
          widget._totalMatches = matches.length;
        });
      } else {
        // We have reached the first match, go to the last match
        setState(() {
          _currentMatchIndex = matches.length - 1;
          widget._totalMatches = matches.length;
        });
      }
      _scrollController.animateTo(
          matches.elementAt(_currentMatchIndex).start.toDouble(),
          duration: Duration(milliseconds: 100),
          curve: Curves.ease); // Scroll to match
    }
  }

  void _scrollToMatch(int position) {
    // Add method to scroll to match
    _scrollController.animateTo(position.toDouble(),
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _loadLawText();
  }

  Future<void> _loadLawText() async {
    final lawText = await rootBundle.loadString(widget.filePath);
    setState(() {
      _lawText = lawText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              controller:
                  _scrollController, // Add ScrollController to SingleChildScrollView
              child: Text.rich(
                _highlightOccurrences(_lawText, _searchText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Пошук по тексту закону',
                  hintStyle: TextStyle(color: Colors.blue),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.blueGrey),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                    _currentMatchIndex = 0;
                    widget._totalMatches =
                        0; // reset total matches when search text changes
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _currentMatchIndex = 0;
                  widget._totalMatches =
                      0; // reset total matches when search is triggered
                });
              },
              color: Colors.lightBlue,
            ),
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: _onForwardButtonPressed,
              color: Colors.blue,
            ),
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: _onBackwardButtonPressed,
              color: Colors.blue,
            ),
            Text(
              '${_currentMatchIndex + 1}/${widget._totalMatches}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _highlightOccurrences(String source, String query) {
    if (query.isEmpty) {
      return TextSpan(text: source);
    }

    final matches = RegExp(query, caseSensitive: false).allMatches(source);

    if (matches.isEmpty) {
      return TextSpan(text: source);
    }

    if (_currentMatchIndex >= matches.length) {
      _currentMatchIndex = 0;
    }

    final currentMatch = matches.elementAt(_currentMatchIndex);

    int start = 0;
    List<TextSpan> children = [];

    for (Match match in matches) {
      if (match.start > start) {
        children.add(TextSpan(
          text: source.substring(start, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(
          backgroundColor: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = match.end;
    }

    if (start < source.length) {
      children.add(TextSpan(
        text: source.substring(start),
      ));
    }

    return TextSpan(children: children);
  }
}
