import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? url;
  final BoxFit? boxFit;
  final double? height;
  const CachedImage({Key? key, required this.url, this.boxFit = BoxFit.cover,this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url!,
      fit: boxFit,
      height: height,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
      const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, value) => Stack(
        children: [
          Positioned.fill(
            child: Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image,/* size: 50,*/ color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
