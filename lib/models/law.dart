import 'package:flutter/material.dart';

class Law {
  final String title;
  final String description;
  final String filePath;
  final String fileName;

  Law({required this.title, required this.description, required this.filePath, required this.fileName});

  factory Law.fromJson(Map<String, dynamic> json) {
    return Law(
      title: json['title'],
      description: json['description'],
      filePath: json['file_path'],
      fileName: json['file_name'],
    );
  }

  String? get text => null;
}
