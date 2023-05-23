import 'package:chat_application/demo.dart';
import 'package:chat_application/screens/fecthContacts.dart';
import 'package:chat_application/screens/indivisualScreen.dart';
import 'package:flutter/material.dart';
//import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:fading_image_button/fading_image_button.dart';
import 'screens/chatScreen.dart';
import 'package:chat_application/utils/routs.dart';
import 'package:chat_application/database/sqlHelper.dart';
import 'package:chat_application/demos/camera.dart';

import 'package:chat_application/screens/Homescreen.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'STYRA CHAT';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}
class MyHomePage extends StatefulWidget {
 const  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home:homeScreen(), 
      initialRoute: "/",
      routes: {
       // myRoutes.chatScreen:(context) => chatScreen(),
        myRoutes.sqlHelper:(context) => FetchContacs(),
        myRoutes.fetchContacts:(context) => contacts(),
        //myRoutes.demoScreen:(context)=> My,
       // myRoutes.
        //myRoutes.indivisualScreen:(context)=>indivisual(),
      },
    );
  }
  
}
