import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'dart:io';

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
