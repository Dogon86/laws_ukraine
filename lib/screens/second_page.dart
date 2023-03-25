import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laws_app/models/law.dart';
import 'package:laws_app/widgets/app_drawer.dart';
import 'dart:convert';

import '../models/law.dart';
import 'law_detail_page.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Law> laws = [];
  List<Law> filteredLaws = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLaws();
  }

  Future<void> loadLaws() async {
    final lawsJson = await rootBundle.loadString('assets/laws.json');
    final lawsData = jsonDecode(lawsJson)['laws'] as List<dynamic>;
    setState(() {
      laws = lawsData.map((law) => Law.fromJson(law)).toList();
      filteredLaws = laws;
    });
  }

  void _filterLaws(String searchText) {
    setState(() {
      filteredLaws = laws.where((law) => law.title.toLowerCase().contains(searchText.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список законів'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Пошук законів',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _filterLaws(_searchController.text),
                ),
              ),
              onChanged: (value) => _filterLaws(value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLaws.length,
              itemBuilder: (context, index) {
                final law = filteredLaws[index];
                return ListTile(
                  title: Text(law.title),
                  subtitle: Text(law.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawDetailPage(filePath: law.filePath, fileName: law.title),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
