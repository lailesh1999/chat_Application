import 'dart:io';

import 'package:flutter/material.dart';


class displayFile extends StatefulWidget {
  List<File> filePath;
    displayFile({super.key, required this.filePath });

  @override
  State<displayFile> createState() => _displayFileState();
}

class _displayFileState extends State<displayFile> {
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
              widget.filePath.clear();
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(widget.filePath as String),
                // height: 900,
                // width: 550,
                fit: BoxFit.cover,
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
