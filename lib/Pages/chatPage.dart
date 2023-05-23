import 'package:chat_application/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/utils/routs.dart';

import 'package:chat_application/model/chatModel.dart';
class chatpage extends StatefulWidget {
  const chatpage({super.key});

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {

  List<ChatModel> chats =[
    ChatModel(name: "LAILESH", icon: "gg", isGroup: false, time: '5:00 AM', currentMessage: 'hi hello'),
    ChatModel(name: "RIFAZ", icon: 'hh', isGroup: false, time: '3:00 PM', currentMessage: 'I LOVE ERLANG'),
    ChatModel(name: "HARDIK PANDYA", icon: 'hh', isGroup: false, time: '7:34 AM', currentMessage: 'Jai '),
    ChatModel(name: "VIRAT KHOLI", icon: 'hh', isGroup: false, time: '7:34 AM', currentMessage: 'E SALA CUP NAMDE'),
    ChatModel(name: "MS DHONI", icon: 'hh', isGroup: false, time: '7:34 AM', currentMessage: 'Definitely NOT'),
    ChatModel(name: "FAF", icon: 'hh', isGroup: true, time: '7:34 AM', currentMessage: 'Orange Cap Mera'),
    ChatModel(name: "ROHIT", icon: 'hh', isGroup: true, time: '7:34 AM', currentMessage: 'Lets Buy Umpire'),
    ChatModel(name: "LAILESH", icon: "gg", isGroup: false, time: '5:00', currentMessage: 'hi hello'),
    ChatModel(name: "RIFAZ", icon: 'hh', isGroup: false, time: '7:34 AM', currentMessage: 'I LOVE ERLANG'),
    ChatModel(name: "HARDIK PANDYA", icon: 'hh', isGroup: false, time: '7:34 AM', currentMessage: 'Jai '),
    ChatModel(name: "VIRAT KHOLI", icon: 'hh', isGroup: false, time: '7:34 AM', currentMessage: 'E SALA CUP NAMDE'),
    ChatModel(name: "MS DHONI", icon: 'hh', isGroup: false, time: '7:34 AM', currentMessage: 'Definitely NOT'),
    ChatModel(name: "FAF", icon: 'hh', isGroup: true, time: '7:34 AM', currentMessage: 'Orange Cap Mera'),
    ChatModel(name: "ROHIT", icon: 'hh', isGroup: true, time: '7:34 AM', currentMessage: 'Lets Buy Umpire')




  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context,myRoutes.fetchContacts );
            },
            backgroundColor: Colors.indigo[900],
            child: const Icon(Icons.chat),
          ),
          body: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context,index)=>chatScreen(
              chatModel: chats[index],
            ),

            // children: [
            //   chatScreen(),
            //   chatScreen(),
            // ],
          ),
    );
  }
}