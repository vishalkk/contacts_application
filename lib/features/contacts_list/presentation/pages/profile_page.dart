import 'package:contacts_application/features/contacts_list/domain/contacts_details.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final ContactsDetail contactsDetail;
  final String imageUrl;
  const ProfilePage(
      {super.key, required this.contactsDetail, required this.imageUrl});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final iconColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              // height: 300,

              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.imageUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.contactsDetail.name,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.call, color: iconColor)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.message_outlined, color: iconColor)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.videocam_outlined, color: iconColor)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.email_outlined, color: iconColor))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 130,
                child: Card(
                    color: Colors.deepPurple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Contact Info",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.call, color: iconColor)),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          "+91 ${widget.contactsDetail.number}"),
                                      Text("Moble")
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.message_outlined,
                                        color: iconColor)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.videocam_outlined,
                                        color: iconColor)),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
