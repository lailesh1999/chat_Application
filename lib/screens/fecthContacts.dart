import 'package:flutter/material.dart';
//import 'package:anim_search_bar/anim_search_bar.dart';
//import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class contacts extends StatefulWidget {
  const contacts({Key? key}) : super(key: key);

  @override
  State<contacts> createState() => _contactsState();
}

class _contactsState extends State<contacts> {
  List<Contact> contacts = [];
  bool isLoading = true;
  bool send = true;
  var e="";
  @override
  void initState() {
    super.initState();
    getContactPermission();
    fetchContacts();
  }

  //bool isPermissionGranted = false;

  Future<void> getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      setState(() async {
        contacts = await fetchContacts();
      });
    } else {
      await Permission.contacts.request();
    }
  }

  Future<List<Contact>> fetchContacts() async {
    if (await Permission.contacts.isDenied) {
      await Permission.contacts.request();
    }
    // Check if the permission is granted
    if (await Permission.contacts.isGranted) {
      // Retrieve and return the contacts
      Iterable<Contact> contacts = await ContactsService.getContacts();

      return contacts.toList();
    } else {
      // Permission denied, handle accordingly (e.g., show an error message)
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("NEW  CHAT"),
          toolbarHeight: 70,
          backgroundColor: Colors.indigo[900],
          iconTheme: IconThemeData(color: Color.fromARGB(255, 237, 235, 235)),
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            // EdgeInsets.only(value),
            SizedBox(
              width: 30,
            ),
          ]),
      body: Container(
        constraints: BoxConstraints.expand(),

        child: ListView(
          padding: EdgeInsets.only(left: 38, top: 20),
          children: [
            Row(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.indigo[
                      900], // Set the background color of the avatar
                      radius: 20, // Set the radius of the avatar
                      child: Icon(
                        Icons.group,
                        color: Colors.white, // Set the color of the icon
                        size: 20, // Set the size of the icon
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "NEW GROUP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),

            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.indigo[
                      900], // Set the background color of the avatar
                      radius: 20, // Set the radius of the avatar
                      child: Icon(
                        Icons.contact_phone,
                        color: Colors.white, // Set the color of the icon
                        size: 20, // Set the size of the icon
                      ),
                    )),
                SizedBox(
                  width: 25,
                ),
                Text(
                  "NEW CONTACT",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'CONTACTS ON STRYA CHAT',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Container(
              height: 600,
              child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    //Contact contact = snapshot.data[index];

                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        radius: 20,
                        child: Icon(Icons.person,color: Colors.white
                            ),
                      ),
                      title: Text(contacts[index].displayName ?? ''),
                      subtitle: Text(contacts[index].phones?.isNotEmpty ?? false
                          ? contacts[index].phones![0].value.toString()
                          : 'EMPTY',),
                      trailing:Text(contacts[index].emails?.isNotEmpty ?? false
                          ? contacts[index].emails![0].value.toString()
                          : ' ',) ,
                      onTap: (){
                        //print("On Tap is fired");
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}