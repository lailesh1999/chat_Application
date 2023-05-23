import 'package:chat_application/main.dart';
import 'package:chat_application/model/chatModel.dart';
import 'package:chat_application/screens/indivisualScreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/utils/routs.dart';

class chatScreen extends StatelessWidget {
  const chatScreen({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/images/person.png"),
        radius: 35,
      ),
      title: Text(
        chatModel.name,
        style: TextStyle(
          fontSize: 16,
          // fontFamily: FontWeight.bold
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.done_all,
            color: Colors.blue,
          ),
          Text(chatModel.currentMessage)
        ],
      ),
      trailing: Text(chatModel.time),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => indivisual(
                      chatModel: chatModel,
                    )));
      },
    );
  }
}
