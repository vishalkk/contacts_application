import 'package:contacts_application/Util/colors.dart';
import 'package:contacts_application/Util/string_constants.dart';
import 'package:contacts_application/Util/value_constant.dart';
import 'package:flutter/material.dart';

class ContactSearchBar extends StatefulWidget {
  const ContactSearchBar({super.key});

  @override
  State<ContactSearchBar> createState() => _ContactSearchBarState();
}

class _ContactSearchBarState extends State<ContactSearchBar> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: sizedBox5,
      decoration: BoxDecoration(
          color: deepPurpleShade, borderRadius: BorderRadius.circular(30)),
      child: TextField(
        cursorColor: Colors.grey,
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.menu),
          suffixIcon: SizedBox(
            width: sizedBox80,
            child: Row(
              children: const [
                //more vertical icon
                Icon(Icons.more_vert),
                //searchbar icon
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(
                    '${imageUrl}1',
                  ),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  width: sizedBox10,
                )
              ],
            ),
          ),
          hintText: searchContacts,
          hintStyle: const TextStyle(fontSize: font15, color: mainColor),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(radius50)),
        ),
      ),
    );
  }
}
