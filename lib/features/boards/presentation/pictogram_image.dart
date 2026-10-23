import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';

/// Imagen de un pictograma: foto propia si existe, si no el pictograma ARASAAC.
class PictogramImage extends StatelessWidget {
  const PictogramImage(this.pictogram, {super.key});

  final Pictogram pictogram;

  @override
  Widget build(BuildContext context) {
    final photo = pictogram.photoPath;
    if (photo != null && File(photo).existsSync()) {
      return Image.file(File(photo), fit: BoxFit.cover);
    }
    final asset = pictogram.assetPath;
    if (asset != null) return Image.asset(asset, fit: BoxFit.contain);
    return const Icon(Icons.image_outlined, size: 40, color: Color(0x668A93A0));
  }
}
