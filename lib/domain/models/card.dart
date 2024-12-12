import 'package:flutter/material.dart';

class CardData {
  final String text;
  final String descriptionText;
  final IconData icon;
  final String? imageUrl;
  bool isFavorite;

  CardData(
    this.text, {
    required this.descriptionText,
    this.icon = Icons.ac_unit_outlined,
    this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
