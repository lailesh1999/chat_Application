import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'dart:io';

import 'package:video_player/video_player.dart';

class DisplayPicture extends StatefulWidget {
  List<XFile>  imagePath;

  DisplayPicture({super.key, required this.imagePath });

  @override
  State<DisplayPicture> createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPicture> {
  // XFile? compressedImage;
  //
  // File? originalImage;
  //
  // String compressedImagePath = "/storage/emulated/0/Download";

  // Future compressImage() async {
  //   originalImage = File(widget.imagePath);
  //   if (widget.imagePath == null) return null;
  //   final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(originalImage!.path, "$compressedImagePath/compress.jpg",quality: 20);
  //   if (compressedFile != null) {
  //       setState(() {
  //         compressedImage = compressedFile;
  //       });
  //       print("SIZE");
  //     print(originalImage!.length);
  //     print(compressedFile.length);
  //   }
  // }
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              widget.imagePath.clear();
            },
            icon: Icon(Icons.close),
            iconSize: 34,
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height - 150,
            //   child: Image.file(
            //     File(widget.imagePath),
            //     // height: 900,
            //     // width: 550,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            ListView.builder(
             // scrollDirection: Axis.horizontal,
                itemCount: widget.imagePath.length,
              itemBuilder: (BuildContext context, int index) {
                //final imageUrl =widget.imagePath[index].toString();
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Image.file(File(widget.imagePath[index].path)),
                );
              },
            ),
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            FloatingActionButton(
              onPressed: () {
                // Wrap the play or pause in a call to `setState`. This ensures the
                // correct icon is shown.
                setState(() {
                  // If the video is playing, pause it.
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    // If the video is paused, play it.
                    _controller.play();
                  }
                });
              },
              // Display the correct icon depending on the state of the player.
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),


            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: IconButton(
                  alignment: Alignment.bottomRight,
                  icon: const Icon(Icons.send),
                  splashColor: Colors.transparent,
                  // Set the splash color to transparent
                  highlightColor: Colors.transparent,
                  iconSize: 45,
                  color: Colors.indigo,
                  onPressed: () {
                    //compressImage();
                    //print('working');
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
