import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;

  const VideoScreen({super.key, required this.videoUrl});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1),(){
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _controller!.setLooping(true);
      _controller!.initialize().then((value){
        setState(() {
          _controller!.play();
        });
      });
    });

        super.initState();

  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  // void _initializeVideoPlayer() {
  //   _controller = VideoPlayerController.file(File(widget.videoUrl))
  //     ..initialize().then((value) {
  //       setState(() {
  //         _controller!.play();
  //       });
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.videoUrl == null
          ? Container()
          : _controller == null
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.indigoAccent,
                ))
              : VideoPlayer(_controller!),
    );
  }
}
