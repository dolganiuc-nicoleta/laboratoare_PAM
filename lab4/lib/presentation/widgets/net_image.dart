import 'package:flutter/material.dart';

// Imagine din rețea, reutilizabilă: placeholder gri cât se încarcă și iconiță dacă eșuează.
class NetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  const NetImage(this.url, {super.key, this.width, this.height, this.fit = BoxFit.cover});

  static const _bg = Color(0xFFF1EFED);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      // cât timp se descarcă poza
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : Container(width: width, height: height, color: _bg),
      // dacă poza nu se poate încărca
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: _bg,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }
}
