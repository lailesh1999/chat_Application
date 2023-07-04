import 'dart:ui';
import 'dart:typed_data';
import 'package:chat_application/model/chatModel.dart';
import 'package:chat_application/screens/fileDisplay.dart';
import 'package:chat_application/screens/testExample.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_application/permission/CapturePicture.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_application/screens/displayUploadPicture.dart';
import 'package:chat_application/screens/ZoomVoiceMessage.dart';
import 'package:chat_application/screens/ImageVideoPicker.dart';

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

class _indivisualState extends State<indivisual>
    with SingleTickerProviderStateMixin {
  //late FlutterSoundRecorder _recordingSession;
  Imagepicker im = new Imagepicker();
  String path = "/storage/emulated/0/Download";
  //String paths = "/storage/emulated/0/Download";

  //String audioPath = "/storage/emulated/0/Download/chatApplication";
  Directory directory =
      Directory("/storage/emulated/0/Download/chatApplication");
  int maxFileSize = 1 * 1024 * 1024; // 5MB limit
  Future<List<String>> getAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
      //type: FileType.custom,
      //allowedExtensions: ['mp3'],
    );
    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      int fileSize = file.size ?? 0;
      List<String> selectedFiles = [];
      List<String> invalidFiles = [];
      int c = 0;
      for (var file in result.files) {
        c++;
        if (fileSize < maxFileSize || file.size < maxFileSize) {
          selectedFiles.add(file.path as String);
        } else {
          invalidFiles.add(file.path as String);
        }
      }
      if (c == 0) {
        if (fileSize > maxFileSize) {
          AlertBox(context);
        }
      }
      if (invalidFiles.isNotEmpty) {
        AlertBox(context);
      }
      for (int i = 0; i < selectedFiles.length; i++) {
        //File audioPath = File(files[i]!.path);
        copyFile(
            selectedFiles[i], '/storage/emulated/0/Download/chatApplication');
      }
      return selectedFiles;
    } else {
      return [];
    }

    //List<File?> files = result.paths.map((path) => File(path!)).toList();
  }

  Future AlertBox(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File Size Exceeded'),
          content: Text(
              'The selected audio file exceeds the file size limit. MIN SIZE 900KB'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<List<PlatformFile>?> filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      for (int i = 0; i < files.length; i++) {
        copyFile(files[i].path, '/storage/emulated/0/Download/chatApplication');
      }
      //final dd = files[0].path;
      //String fileExtension = dd.split(".").last;
      int len = files.length;
      if (result != null && len > 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(' $len FILES SELECTED '),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('SEND'),
                ),
              ],
            );
          },
        );
      }
    } else {
      print("No file selected");
    }
    return result?.files;
  }

//copy file from one destination to another
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

  bool isTextEntered = false;

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
               /* ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ZoomButton()));
                    },
                    child: Text("NEXT"))*/
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
                      color: Colors.blue,
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
                  //popUp();
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
                                icon: Icon(Icons.emoji_emotions_rounded,
                                    size: 25),
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
                            onChanged: (value) {
                              setState(() {
                                isTextEntered = value.isNotEmpty;
                              });
                            })),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                  ),
                  (isTextEntered) ? button1() : ZoomButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget button1() {
    return (CircleAvatar(
      child: IconButton(
        icon: Icon(Icons.send),
        onPressed: () {
          setState(() {});
        },
      ),
    ));
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
                    iconcreation(Icons.insert_drive_file, Colors.indigo,
                        "Document", "files"),
                    SizedBox(
                      width: 40,
                    ),
                    iconcreation(
                        Icons.camera_alt, Colors.pink, "Camera", "camera"),
                    SizedBox(
                      width: 40,
                    ),
                    iconcreation(Icons.insert_photo, Colors.purpleAccent,
                        "Gallary", "gallery"),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconcreation(
                        Icons.audiotrack_sharp, Colors.blue, "AUDIO", "audio"),
                    SizedBox(
                      width: 40,
                    ),
                    iconcreation(Icons.contacts, Colors.blueAccent, "Contacts",
                        "contacts"),
                    SizedBox(
                      width: 40,
                    ),
                    iconcreation(Icons.location_on_rounded, Colors.redAccent,
                        "Location", "location"),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget iconcreation(IconData icon, Color color, String text, String text1) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        if (text1 == "gallery") {
          List<XFile>? imagePath = (await im.videoPicker());
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
        } else if (text1 == "contacts") {
          print("contacts");
        } else if (text1 == "audio") {
          getAudio();
        } else if (text1 == "files") {
          List<File>? filePath = (await filePicker())?.cast<File>();
          //int? len = imagePath?.length;
          if (filePath?.length != 1) {
            AlertDialog(
              title: Text('AlertDialog $filePath?.length Title'),
            );
          } else {
            if (filePath != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => displayFile(
                    // Pass the automatically generated path to
                    // the DisplayPictureScreen widget.
                    filePath: filePath,
                  ),
                ),
              );
            }
          }
        } else if (text1 == "camera") {
          print("camera");
        } else {
          print("location");
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
}
