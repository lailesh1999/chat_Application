import 'dart:ui';
import 'dart:typed_data';
import 'package:chat_application/model/chatModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_application/permission/CapturePicture.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:chat_application/screens/displayUploadPicture.dart';

//import 'package:flutter_image_compress/flutter_image_compress.dart';
//import 'package:custom_multi_imagepicker_2/custom_multi_imagepicker_2.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
//import 'package:multiple_images_picker/multiple_images_picker.dart';

Future<void> runCamera() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        cameras: cameras,
      ),
    ),
  );
}

class indivisual extends StatefulWidget {
  indivisual({
    Key? key,
    required this.chatModel,
  }) : super(key: key);
  final ChatModel chatModel;
  final cameras = availableCameras();

  @override
  State<indivisual> createState() => _indivisualState();
}

class _indivisualState extends State<indivisual> {
  //List<Asset> images = <Asset>[];
  //String _error = 'No Error Dectected';

  //File? image;
  // XFile? compressedImage;
  // originalImage;
  //

  // Future<String?> pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return null;
  //     final imageTemp = File(image.path);
  //     setState(() => this.image = imageTemp);
  //
  //
  //
  //
  //    // return imageTemp.path;
  //     //originalImage = imageTemp.path;
  //     if (imageTemp.path == null) return null;
  //     final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(imageTemp.path, "$compressedImagePath/compress.jpg",quality: 10);
  //     if (compressedFile != null) {
  //       setState(() {
  //         compressedImage = compressedFile;
  //       });
  //       print("SIZE");
  //       print(imageTemp.path!.length);
  //       print(compressedFile.length);
  //     }
  //     return compressedFile?.path;
  //
  //
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //     return null;
  //   }
  // }
  List<XFile> selectedImages = [];
  String compressedImagePath = "/storage/emulated/0/Download";

  Future<List<XFile>> getImages() async {
    final pickedFile = await ImagePicker().pickMultiImage(imageQuality: 100, maxHeight: 640, maxWidth: 480);
    List<XFile> xfilePick = pickedFile;

    int c = 0;
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        //final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(xfilePick[i].path, "$compressedImagePath/compress+$c"".jpg",quality: 1);

        Future<Uint8List> compressedData =  compressImage(xfilePick[i], 70) ;
        Uint8List data = await compressedData;
        String fileName = 'compressed_image$c.png';
        XFile xFile = await convertToXFile(data, fileName);
        selectedImages.add(xFile );
        c = c + 1;
      }


      // selectedImages.add(File(xfilePick[i].path));
    }else {
      ScaffoldMessenger.of(context as BuildContext)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
      Navigator.pop(context as BuildContext);
    }

    return selectedImages;
  }

  Future<XFile> convertToXFile(Uint8List data, String fileName) async {
    // Get the temporary directory path
    final directory = await getTemporaryDirectory();
    final filePath = '${compressedImagePath}/$fileName';

    // Create a new file with the Uint8List data
    final file = File(filePath);
    await file.writeAsBytes(data);

    // Return the XFile instance
    return XFile(filePath);
  }



    Future<Uint8List> compressImage(XFile imageFile, int quality) async {
      // Read the image file as bytes
      final bytes = await imageFile.readAsBytes();

      // Decode the image bytes into an Image object
      final image = await decodeImageFromList(bytes);

      // Get the width and height of the image
      final width = image.width;
      final height = image.height;

      // Calculate the target size based on the desired quality
      final targetSize = (bytes.length * (quality / 100)).round();

      // If the target size is smaller than the current size, perform compression
      if (targetSize < bytes.length) {
        // Calculate the compression ratio
        final compressionRatio = bytes.length / targetSize;

        // Calculate the new dimensions based on the compression ratio
        final newWidth = (width / compressionRatio).round();
        final newHeight = (height / compressionRatio).round();

        // Resize the image
        final resizedImage = await image.toByteData(
          format: ui.ImageByteFormat.png,
          //width: newWidth,
          //height: newHeight,
        );

        // Convert the resized image to Uint8List
        final Uint8List compressedData = resizedImage!.buffer.asUint8List();
        return compressedData;
      } else {
        // Return the original image data if no compression is needed
        return bytes;
      }
    }


// Future<XFile?> compressImage(XFile imageFile, int quality,int c) async {
//   // Read the file
//   List<int> imageBytes = await imageFile.readAsBytes();
//
//   // Create an Image object from the bytes
//   Image image = UnitImage.memory(imageBytes);
//
//   //Uint8List.fromList(myList);
//   // Get the original dimensions of the image
//   //int width = image.width;
//   //int height = image.height;
//
//   // Create a new image with reduced quality
//   Image compressedImage = image.copyWith(quality: quality);
//
//   // Encode the compressed image to bytes
//   List<int> compressedBytes = await compressedImage.toByteData(format: ImageByteFormat.png)
//       .then((ByteData? byteData) => byteData!.buffer.asUint8List());
//
//   // Write the compressed bytes to a new file
//   File compressedFile = File('${imageFile.path}_compressed"$c".png');
//   await compressedFile.writeAsBytes(compressedBytes);
//
//   // Print the original and compressed file sizes
//   int originalSize = imageBytes.length;
//   int compressedSize = compressedBytes.length;
//   print('Original Size: $originalSize bytes');
//   print('Compressed Size: $compressedSize bytes');
//   return compressedFile!.path as XFile;
// }

// Future<void> comPress(File imageFile,int c) async{
//   // Get the image file.
//  // File imageFile = File('path/to/image.jpg');
//
//   // Get the image's width and height.
//   ByteData imageData = (await imageFile.readAsBytes()) as ByteData;
//   Image image = Image.memory(imageData as Uint8List ,filterQuality: FilterQuality.low);
//
//   //Image image = Image.decodeImage(imageFile.readAsBytes()) ;
//   //Image compressedImage = Image(width: image.width, height: image.height,);
//   //compressedImage.quality = 50;
//
//   setState(()async {
//     File compressedImageFile = File('/storage/emulated/0/Download/compress"$c".jpg');
//       await compressedImageFile.writeAsBytes(imageData as List<int>);
//   });
//
//   // Create a new Image object with the same width and height as the original image.
//
// }

// Future<void> compressImage(File imageFile,int c) async {
//   // Get the image file.
//   //File imageFile = File('path/to/image.jpg');
//
//   // Read the image file as a byte array.
//   ByteData imageData = (await imageFile.readAsBytes()) as ByteData;
//  // ByteData imageData = await imageFile.readAsBytes();
//   // Create a new Image object with the same width and height as the original image.
//   //Image image = Image.memory(imageData as Uint8List,filterQuality: FilterQuality.medium);
//
//   // Set the quality of the compressed image.
//   //image.quality = 50;
//   File compressedImageFile = File('/storage/emulated/0/Download/image"$c".jpg');
//   compressedImageFile.writeAsBytes(imageData as Uint8List);
//   // Save the compressed image to a new file.
//
//   //await image.save('path/to/compressed/image"$c".jpg');
// }

// Future<Uint8List?> compressImage(File imageFile, int quality) async {
//   // Read the image file as bytes
//   final bytes = await imageFile.readAsBytes();
//
//   // Decode the image bytes into an Image object
//   final image = await decodeImageFromList(bytes);
//
//   // Get the width and height of the image
//   final width = image.width;
//   final height = image.height;
//
//   // Create a new Image object with reduced size
//   final resizedImage = await image.toByteData(
//     format: ui.ImageByteFormat.png,
//
//   );
//   // Retrieve the compressed image bytes
//   final compressedBytes = resizedImage?.buffer.asUint8List();
//   return compressedBytes;
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        leadingWidth: 70,
        toolbarHeight: 75,
        backgroundColor: Colors.indigo[900],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 4),
              Icon(
                Icons.arrow_back,
                size: 24,
              ),
              Spacer(flex: 4),
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/person.png"),
                radius: 20,
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {},
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(width: 10,),
                Text(widget.chatModel.name,
                    style: TextStyle(
                      fontSize: 19,
                    )),
                Text(
                  "last seen at " + widget.chatModel.time,
                  style: TextStyle(fontSize: 15, color: Colors.white60),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          PopupMenuButton<String>(
              // Callback that sets the selected popup menu item.
              onSelected: (value) {
            print(value);
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "video_call",
                child: Row(
                  children: [
                    Icon(
                      Icons.videocam,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('VIDEO CALL'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "delete_chat",
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('DELETE CHAT'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "block",
                child: Row(
                  children: [
                    Icon(
                      Icons.block,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('BLOCK USER'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "mute",
                child: Row(
                  children: [
                    Icon(
                      Icons.volume_mute_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('MUTE NOTIFICATION'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "SEARCH",
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('SEARCH'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  popUp();
                },
                value: "MORE",
                child: Row(
                  children: [
                    Icon(
                      Icons.more_horiz_sharp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('MORE'),
                  ],
                ),
              ),
            ];
          }),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 55,
                    padding: EdgeInsets.only(left: 7),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              icon:
                                  Icon(Icons.emoji_emotions_rounded, size: 25),
                              onPressed: () {},
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.attach_file_sharp,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (builder) => bottomsheet());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.camera_alt_sharp,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    runCamera();
                                  },
                                ),
                              ],
                            ),
                            hintText: 'Type your message',
                            // icon: Icon(Icons.emoji_emotions_rounded),
                          ),
                        )),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.send_sharp),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
        height: 340,
        padding: EdgeInsets.only(bottom: 60),
        width: MediaQuery.of(context as BuildContext).size.width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
          margin: EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconcreation(
                        Icons.insert_drive_file, Colors.indigo, "Document"),
                    SizedBox(
                      width: 40,
                    ),
                    iconcreation(Icons.camera_alt, Colors.pink, "Camera"),
                    SizedBox(
                      width: 40,
                    ),
                    iconcreation(
                        Icons.insert_photo, Colors.purpleAccent, "Gallary"),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconcreation(Icons.audiotrack_sharp, Colors.blue, "AUDIO"),
                    SizedBox(
                      width: 40,
                    ),
                    iconcreation(Icons.contacts, Colors.blueAccent, "Contacts"),
                    SizedBox(
                      width: 40,
                    ),
                    iconcreation(Icons.location_on_rounded, Colors.redAccent,
                        "Location"),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget iconcreation(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);

        List<XFile> imagePath = await getImages();
        if (imagePath != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPicture(
                // Pass the automatically generated path to
                // the DisplayPictureScreen widget.
                imagePath: imagePath,
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
              radius: 30,
              backgroundColor: color,
              child: Icon(
                icon,
                size: 29,
                color: Colors.white,
              )),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void popUp() {
    PopupMenuButton<String>(
        // Callback that sets the selected popup menu item.
        onSelected: (value) {
      print(value);
    }, itemBuilder: (BuildContext context) {
      return [
        PopupMenuItem(
          value: "video_call",
          child: Row(
            children: [
              Icon(
                Icons.videocam,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text('VIDEO CALL'),
            ],
          ),
        ),
        PopupMenuItem(
          value: "delete_chat",
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text('DELETE CHAT'),
            ],
          ),
        ),
        PopupMenuItem(
          value: "block",
          child: Row(
            children: [
              Icon(
                Icons.block,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text('BLOCK USER'),
            ],
          ),
        ),
        PopupMenuItem(
          value: "mute",
          child: Row(
            children: [
              Icon(
                Icons.volume_mute_outlined,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text('MUTE NOTIFICATION'),
            ],
          ),
        ),
        PopupMenuItem(
          value: "SEARCH",
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text('SEARCH'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          value: "MORE",
          child: Row(
            children: [
              Icon(
                Icons.more_horiz_sharp,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text('MORE'),
            ],
          ),
        ),
      ];
    });
  }
}
