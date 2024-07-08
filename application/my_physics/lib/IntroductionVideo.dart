// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:my_physics/videoplayer.dart';

class Introductionvideo extends StatefulWidget {
  const Introductionvideo({super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _Introductionvideo createState() => _Introductionvideo();
}

class _Introductionvideo extends State<Introductionvideo>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Videoplayer(videoUrl: '../assets/video/Intro.mp4'),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 36, 34, 34),
    );
  }
}