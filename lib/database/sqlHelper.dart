import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



// class Users {
//   final String name;
//   final String phone;
//   final String large;
//
//   const Users({
//     required this.name,
//     required this.phone,
//     required this.large,
//   });
//
//   factory Users.fromJson(Map<String, dynamic> json) {
//     return Users(
//       name: json['name'],
//       phone: json['phone'],
//       large: json['large'],
//     );
//   }
// }

class FetchContacs extends StatefulWidget {

  const FetchContacs({Key? key}) : super(key: key);

  @override
  State<FetchContacs> createState() => _FetchContacsState();
}

class _FetchContacsState extends State<FetchContacs> {
    Map mapResponse ={};
    String stringResponse=" ";
   //Map dataResponse ={};
    Future fetchUsers() async {

    http.Response response = await http.get(
        Uri.parse('https://randomuser.me/api/'));
    if (response.statusCode == 200) {
      setState(() {
        //stringResponse = response.body;

        mapResponse = jsonDecode(response.body);
        if(mapResponse==null){
          print("dddd");
        }else{
          print('ERROR');
        }
        //dataResponse = mapResponse?['results'];

        //print(dataResponse!['results']);
      });
    }
  }
    @override
    void initState() {
      super.initState();
      fetchUsers();
      //futureUsers = fetchUsers();
    }
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Fetch Data Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Fetch Data Example'),
          ),
          body: Center(
            child:SizedBox(
              height: 600,
              width: 500,
              child: Center(
               child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 70,
                    ),
                    Text(mapResponse['results'][0]['name']['first'].toString()),
                    Text(mapResponse['results'][0]['phone'].toString()),
                  ],
                ),
                //child: Text(mapResponse!['results'][0]['phone'].toString()),

              )
            ),
          ),
        ),
      );
    }


  }




