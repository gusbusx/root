import 'dart:io';
import 'package:flutter/material.dart';

/// Native implementation used on Android/iOS/desktop.
Widget buildLocalFileImage({
  required String path,
  double? height,
  double? width,
  BoxFit? fit,
  Color? color,
  String? semanticLabel,
  Widget? fallback,
}) {
  final normalizedPath = path.startsWith('file://')
      ? Uri.parse(path).toFilePath()
      : path;

  return Image.file(
    File(normalizedPath),
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    color: color,
    semanticLabel: semanticLabel,
    errorBuilder: (_, __, ___) =>
        fallback ??
        SizedBox(
          height: height,
          width: width,
          child: const Center(child: Icon(Icons.broken_image_outlined)),
        ),
  );
}
