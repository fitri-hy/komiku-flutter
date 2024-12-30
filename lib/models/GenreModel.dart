import 'package:flutter/material.dart';

class GenreModel {
  final String title;
  final String slug;

  GenreModel({required this.title, required this.slug});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      title: json['title'] as String,
      slug: json['slug'] as String,
    );
  }
}
