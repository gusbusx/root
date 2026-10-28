import 'package:flutter/material.dart';

/// Web-safe fallback for local file images.
/// Browsers cannot read arbitrary device file paths via dart:io.
Widget buildLocalFileImage({
  required String path,
  double? height,
  double? width,
  BoxFit? fit,
  Color? color,
  String? semanticLabel,
  Widget? fallback,
}) {
  return fallback ??
      SizedBox(
        height: height,
        width: width,
        child: const Center(child: Icon(Icons.broken_image_outlined)),
      );
}
