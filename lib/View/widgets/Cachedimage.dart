import 'package:flutter/material.dart';

class Cachedimage extends StatelessWidget {
  final String imageURL;
  final Widget loadingErrorWidget;
  final double? height;
  final double? width;
  final BoxFit boxFit;
  const Cachedimage(
      {super.key,
      required this.imageURL,
      required this.loadingErrorWidget,
      this.height,
      this.boxFit = BoxFit.cover,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
        imageURL,
        height: height,
        width: width,
        alignment: Alignment.center,
        fit: boxFit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
              child: SizedBox(
                  height: height, width: width, child: loadingErrorWidget));
        },
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
              height: height, width: width, child: loadingErrorWidget);
        },
      ),
    );
  }
}
