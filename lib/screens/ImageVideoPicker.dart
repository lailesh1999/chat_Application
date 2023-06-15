//import 'dart:js';
//import 'dart:js';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_compression_flutter/flutter_image_compress.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class Imagepicker {
  List<XFile> selectedImages = [];
  String compressedImagePath = "/storage/emulated/0/Download/ChatApplication";

  ///image picker
  // Future<List<XFile>> getImages() async {
  //   final pickedFile = await ImagePicker().pickMultiImage(imageQuality: 100, maxHeight: 640, maxWidth: 480);
  //
  //   List<XFile> xfilePick = pickedFile;
  //   int c = 0;
  //   if (xfilePick.isNotEmpty) {
  //     for (var i = 0; i < xfilePick.length; i++) {
  //       //final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(xfilePick[i].path, "$compressedImagePath/compress+$c"".jpg",quality: 1);
  //
  //       Future<Uint8List> compressedData = compressImage(xfilePick[i], 70);
  //       Uint8List data = await compressedData;
  //       String fileName = 'compressed_image$c.png';
  //       XFile xFile = await convertToXFile(data, fileName);
  //       selectedImages.add(xFile );
  //       c = c + 1;
  //     }
  //     // selectedImages.add(File(xfilePick[i].path));
  //   } else {
  //     //ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(content: Text('Nothing is selected')));
  //     // Navigator.pop(context as BuildContext);
  //   }
  //   return selectedImages;
  // }

  Future<Uint8List> compressImage1(File imageFile, int quality) async {
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
       // width: newWidth,
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

// to create a image file
  Future<XFile> convertToXFile(Uint8List data, String fileName) async {
    // Get the temporary directory path
    //final directory = await getTemporaryDirectory();
    final filePath = '${compressedImagePath}/$fileName';

    // Create a new file with the Uint8List data
    final file = File(filePath);
    await file.writeAsBytes(data);

    // Return the XFile instance
    return XFile(filePath);
  }


  Future<List<XFile>> videoPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowCompression: true,
      allowedExtensions: ['jpg', 'png','mp4', 'mov', 'avi'],
    );
    if (result != null) {
     // List<XFile> files = result.paths.map((path) => File(path!)).cast<XFile>().toList();
      List<File> files = result.paths.map((path) => File(path!)).toList();
      int c=0;
      for (int i = 0; i < files.length; i++) {
        final ex = files[i].path;
        String fileExtension = ex.split(".").last.toLowerCase();
        //copyFile(files[i].path, '/storage/emulated/0/Download/chatApplication');
        if(fileExtension == "jpg" || fileExtension == "png" ){

          Future<Uint8List?> compressedData = compressImage(files[i]) ;
          Uint8List? data = await compressedData;
          String fileName = 'compressed_image$c.png';
          XFile xFile = await convertToXFile(data!, fileName);
          selectedImages.add(xFile);
          c = c + 1;
        }
        else{
              c=c+1;
              compressVideo(files[i].path,c);
        }
      }
      //final dd = files[0].path;
      //String fileExtension = dd.split(".").last;
      int len = files.length;

    } else {
      print("No file selected");
    }
    return selectedImages;
  }

  Future<void> compressVideo(String videoPath,int c) async {
    // Set the video quality.
    VideoQuality quality = VideoQuality.LowQuality;

    // Compress the video.
    MediaInfo? info = await VideoCompress.compressVideo(
      videoPath,
      quality: quality,
      deleteOrigin: false,
      includeAudio: true,
    );


    // Print the path of the compressed video.
    print(info?.path);
    Directory directory = Directory('/storage/emulated/0/Download/ChatApplication');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    // Write the compressed video to the directory.
    //await info!.writeAsBytesSync(directory);
    // var filename = "compresss";
    // var filesname;
    DateTime current_date = DateTime.now();
    int currentSeconds = current_date.second;
    File compressedVideoFile = File('${directory.path}/compress$currentSeconds.mp4');
    List<int> videoBytes = await File(info?.path ?? '').readAsBytes();
    compressedVideoFile.writeAsBytesSync(videoBytes);
  }




  void copyFile(String sourcePath, String destinationDirectory) {
    final File sourceFile = File(sourcePath);

    // Check if the source file exists
    if (!sourceFile.existsSync()) {
      print('Source file does not exist.');
      return;
    }

    // Extract the file name from the source path
    final String fileName = sourceFile.path.split('/').last;

    // Construct the destination path by combining the destination directory and the file name
    final String destinationPath = '$destinationDirectory/$fileName';

    // Check if the destination file already exists
    final File destinationFile = File(destinationPath);
    if (destinationFile.existsSync()) {
      print('Destination file already exists.');
      return;
    }

    try {
      // Read the content of the source file
      final List<int> content = sourceFile.readAsBytesSync();

      // Write the content to the destination file
      destinationFile.writeAsBytesSync(content);

      print('File copied successfully.');
    } catch (e) {
      print('An error occurred while copying the file: $e');
    }
  }


  // Future<Uint8List?> compressImage(File imageFile, int quality) async {
  //   final compressedFile = await FlutterImageCompress.compressWithFile(
  //     imageFile.path,
  //     quality: quality,
  //   );
  //
  //   return compressedFile;
  // }

   // Future<Uint8List?> compressImage(ImageFile imageFile,int quality) async{
   //   Configuration config = Configuration(
   //     outputType: ImageOutputType.webpThenJpg,
   //     // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
   //     useJpgPngNativeCompressor: false,
   //     // set quality between 0-100
   //     quality: 40,
   //   );
   //   final param = ImageFileConfiguration(input: imageFile, config: config);
   //   final output = await compressor.compress(param);
   //   Uint8List dd= await  imageFileToUint8List(output as File) as Uint8List;
   //  return dd;
   // }

  Future<Uint8List?> compressImage(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,

      quality: 20,
     // rotate: 90,
    );
    print('Original image size: ${file.lengthSync()}');
    print('Compressed image size: ${result?.length}');
    return result;
  }



}
