import 'package:flutter/material.dart';

class HomeTopic {
  final String title;
  final String subtitle;
  final IconData icon;
  final String databaseTitle;
  final String content;

  HomeTopic(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.databaseTitle,
      required this.content});
}
