import 'package:flutter/material.dart';

import 'net_image.dart';

// Banner reutilizabil: poză din API + gradient + texte albe deasupra.
// (în Lab 2 textul era "copt" în imagine; acum vine din JSON)
class BannerCard extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final String? label;
  final String title;
  final double titleSize;
  final Widget? bottom; // ex. buton sau puncte de slider
  const BannerCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.height,
    this.label,
    this.titleSize = 20,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            NetImage(imageUrl),
            // gradient întunecat spre stânga-jos, ca textul alb să se citească
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xB3000000), Color(0x00000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null)
                    Text(label!,
                        style: const TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                  Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontSize: titleSize, fontWeight: FontWeight.bold)),
                  if (bottom != null) ...[const SizedBox(height: 10), bottom!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
