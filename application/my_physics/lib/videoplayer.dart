import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_physics/main.dart';
import 'package:video_player/video_player.dart';

class Videoplayer extends StatefulWidget {
  const Videoplayer({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<Videoplayer> createState() => _MyvideoplayertState();
}

class _MyvideoplayertState extends State<Videoplayer> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
      setState(() {
        _isPlaying = true;
      });
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoPlayerController.pause();
        _isPlaying = false;
      } else {
        _videoPlayerController.play();
        _isPlaying = true;
      }
    });
  }

  void _seekBackward10Seconds() {
    final currentPosition = _videoPlayerController.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _videoPlayerController.seekTo(
      Duration(
        milliseconds: newPosition.inMilliseconds.clamp(
          0,
          _videoPlayerController.value.duration.inMilliseconds,
        ),
      ),
    );
  }

  void _seekForward10Seconds() {
    final currentPosition = _videoPlayerController.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _videoPlayerController.seekTo(
      Duration(
        milliseconds: newPosition.inMilliseconds.clamp(
          0,
          _videoPlayerController.value.duration.inMilliseconds,
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: _initializeVideoPlayerFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 60, // Set the height as needed
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.cyan,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Introduction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: AutofillHints.birthday,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MainScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Set the button color to deep purple
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Video List',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.replay_10),
                      color: Colors.white,
                      iconSize: 25,
                      onPressed: _seekBackward10Seconds,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      color: Colors.white,
                      iconSize: 25,
                      onPressed: _togglePlayPause,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.forward_10),
                      color: Colors.white,
                      iconSize: 25,
                      onPressed: _seekForward10Seconds,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.cyan, // Set the color of the divider to deep purple
                thickness: 1.0, // Set the thickness of the divider to 1.0
                indent: 16.0, // Add left and right indentation
                endIndent: 16.0, // Add right indentation
              ),
              Container(
                color: const Color.fromARGB(255, 62, 61, 61), // Set background color for description text
                padding: const EdgeInsets.all(16.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Created by: Tedx',
                      style: TextStyle(
                        color: Colors.cyan, // Set text color to deep purple
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Description: TEDx is a program of local, self-organized events that bring people together to share a TED-like experience. At a TEDx event, TED Talks video and live speakers combine to spark deep discussion and connection in a small group. TEDx events are independently organized under a free license granted by TED.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}
}
