import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewScreen extends StatefulWidget {
  final List<String>? detailImageList;

  const ImageViewScreen(
      {super.key, this.detailImageList,});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 80.0,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount:  widget.detailImageList!.length,
                  itemBuilder: (context, index) {
                    final image = widget.detailImageList![index];

                    return Center(
                      child:  Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.contain)),
                            ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${index + 1}/${widget.detailImageList!.length}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
