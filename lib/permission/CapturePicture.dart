import 'dart:async';
import 'dart:io';
import 'package:chat_application/screens/indivisualScreen.dart';
import 'package:chat_application/utils/routs.dart';
import 'package:orientation/orientation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/model/chatModel.dart';
// A screen that allows users to take a picture using a given camera.




Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`

  WidgetsFlutterBinding.ensureInitialized();

 final cameras = await availableCameras();

  //final firstCamera = cameras.first;
  runApp(MyApp(cameras: cameras));

}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TakePictureScreen(cameras: cameras),
    );
  }
}

class TakePictureScreen extends StatefulWidget {


 final List <CameraDescription> cameras;
  const TakePictureScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {

  List<CameraDescription> cameras = [];
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool _isFrontCamera = true;

  @override
  void initState() {
    super.initState();

    if (widget.cameras.isEmpty) {
      print('No cameras found on the device.');
      return;
    }
    // To display the current output from the Camera,
    // create a CameraController.
    final fistCamera = widget.cameras.first;
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      fistCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );


    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();



  }


  @override


  void _toggleCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      // Dispose the controller before switching cameras
     // _controller.dispose();

      // Obtain the new camera description
      final newCamera = _isFrontCamera
          ? widget.cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => widget.cameras.first,
      )
          : widget.cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => widget.cameras.first,
      );

      // Initialize the new controller
      _controller = CameraController(
        newCamera,
        ResolutionPreset.medium,
      );

      // Initialize the new controller
      _initializeControllerFuture = _controller.initialize();
    });
  }

  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    Navigator.popUntil(context,(route)=> route.settings.name == '/indivisual');
    super.dispose();
  }
  void exitCameraScreen(BuildContext context) {
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    //final ChatModel chatModel;

    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Container(
        height: 800,
        color: Colors.transparent,

        child:Column(

          children: [
            SizedBox(height: 45,width: 10,),
            Align(

              alignment: Alignment.topLeft,

           child: IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
               // Navigator.pushNamed(context, '/');
                exitCameraScreen(context);
                // MaterialApp(
                //   routes: {
                //     '/indivsual': (context) => indivisual(chatModel: chatModel),
                //   },
                  // other configurations...
                //)
              },
            ),
            ),
         FutureBuilder<void>(

          future: _initializeControllerFuture,
          builder: (context, snapshot) {
          //  if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            // } else {
            //   // Otherwise, display a loading indicator.
            //   return const Center(child: CircularProgressIndicator());
            // }
          },
        ),
          ]
      ),
      ),

      floatingActionButton: Row(
        children: [
          SizedBox(
            width: 30,
          ),
          FloatingActionButton(
            onPressed: () {
              // Add your onPressed logic here
            },
            child: Icon(Icons.picture_in_picture_rounded),
          ),
          SizedBox(
            width: 100,
          ),
          FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                final image = await _controller.takePicture();

                if (!mounted) return;

                // If the picture was taken, display it on a new screen.
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image.path,
                    ),
                  ),
                );
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: Icon(Icons.camera_alt,size: 60,color: Colors.white,),
          ),
          SizedBox(
            width: 90,
          ),
          FloatingActionButton(
            onPressed: () {
              print("dddd");

              _toggleCamera();
               // AspectRatio(
               //      aspectRatio: _controller.value.aspectRatio,
               //      child: CameraPreview(_controller),
               //    );

            },
            child: Icon(Icons.screen_rotation_alt_sharp),
          ),
        ],
      ),
    );

  }



  }


// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body:Container(

  padding: EdgeInsets.only(right: 20),
      child:Align(
        alignment: Alignment.center,

        child: Image.file(File(imagePath),

        fit: BoxFit.contain,),
      ),
      ),
    );
  }
}
