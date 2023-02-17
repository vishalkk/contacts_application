import 'package:contacts_application/Util/colors.dart';
import 'package:contacts_application/Util/string_constants.dart';
import 'package:contacts_application/Util/value_constant.dart';
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
  final iconColor = deepPurple;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
        elevation: 0,
        backgroundColor: white,
        toolbarHeight: toolbarHeight80,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: sizedBox5,
            ),
            CircleAvatar(
              radius: radius50,
              backgroundImage: NetworkImage(widget.imageUrl),
              backgroundColor: transparent,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.contactsDetail.name,
              style: const TextStyle(fontSize: font25),
            ),
            const SizedBox(
              height: sizedBox20,
            ),
            const Divider(),
            contactInfoWidgetTop(),
            const Divider(),
            contactInfoWidget(),
            const SizedBox(
              height: sizedBox20,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox contactInfoWidgetTop() {
    return SizedBox(
      height: sizedBox100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.call, color: iconColor)),
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
    );
  }

  Padding contactInfoWidget() {
    return Padding(
      padding: const EdgeInsets.all(padding10),
      child: SizedBox(
        height: 130,
        child: Card(
            color: deepPurpleShade,
            child: Padding(
              padding: const EdgeInsets.all(padding10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        contactInfo,
                        style: TextStyle(
                            fontSize: font15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                    height: sizedBox80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.call, color: iconColor)),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: padding8, top: padding30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "$countryCode ${widget.contactsDetail.number}"),
                              const Text(mobile)
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon:
                                Icon(Icons.message_outlined, color: iconColor)),
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
    );
  }
}
