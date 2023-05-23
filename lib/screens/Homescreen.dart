import 'package:chat_application/Pages/chatPage.dart';
import 'package:chat_application/demo.dart';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:fading_image_button/fading_image_button.dart';
import 'package:chat_application/utils/routs.dart';
import 'package:chat_application/screens/Homescreen.dart';
import 'package:chat_application/screens/chatScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> with SingleTickerProviderStateMixin {
 late TabController _controller;
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
     TextEditingController textController = TextEditingController();


  @override
    void initState() {  
      super.initState();
        _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    }    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("STYRA CHAT"),
            toolbarHeight: 100,
            backgroundColor: Colors.indigo[900],
            iconTheme: IconThemeData(color: Color.fromARGB(255, 237, 235, 235)),
            bottom:  TabBar(

            controller: _controller, 
            indicatorColor: Color.fromARGB(255, 67, 162, 203),
              tabs: [
            
              Tab(
                text: "CHATS",
              ),

              Tab(
                text: "CALLS",
              ),
             
            ]),
            actions: <Widget>[
              //IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              //IconButton(onPressed: () {}, icon: Icon(Icons.dangerous)),
         // EdgeInsets.only(value),
               AnimSearchBar(
                             width: 250,

                             textController: textController,
                             onSuffixTap: () {

                             }, onSubmitted: (String ) {

                              },
                           ),
              SizedBox(
                width: 30,
              ),
              // IconButton(onPressed: () {
              //  // ignore: unused_local_variable
              //    //Scaffold sc = Scaffold.of(context).openDrawer();
              // }, icon: Icon(Icons.account_box),iconSize: 50,)

              //Drawer()
            ],
            //title
            // title: Text(widget.title),
            leading:IconButton(
              icon: Icon(Icons.person),
              iconSize: 35,
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
               tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,

            ),
          ),
          body: TabBarView(
            controller: _controller,
            children: [
              chatpage(),
              Text("CALLS"),
            ],
          ),
          //endDrawer
         drawer: Drawer(  
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // bottomNavigationBar:CurvedNavigationBar(
          //   backgroundColor: Colors.transparent,
          //   color:Colors.indigo,
          //   //animationDuration: Duration(microseconds:300 ),
          //   items: [
          //     Icon(Icons.chat,color: Colors.white,),
          //     Icon(Icons.group,color: Colors.white),
          //     Icon(Icons.call,color: Colors.white),
          //
          //
          //   ],
          // ) ,
        
);
  

  
  }
}