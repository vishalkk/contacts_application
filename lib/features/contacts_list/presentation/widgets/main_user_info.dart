import 'package:contacts_application/Util/colors.dart';
import 'package:contacts_application/Util/string_constants.dart';
import 'package:contacts_application/Util/value_constant.dart';
import 'package:flutter/material.dart';

class MainUserInfoWidget extends StatelessWidget {
  final int contactCount;
  const MainUserInfoWidget({
    required this.contactCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizedBox5,
      child: Row(
        children: [
          const Icon(
            Icons.person,
            color: mainColor,
          ),
          const SizedBox(width: sizedBox10),

          /*
        User email id 
        */
          const Text(
            fixEmailUser,
            style: TextStyle(fontSize: font15, color: mainColor),
          ),
          const SizedBox(width: sizedBox10),
          /*
        contacts count
        */
          Text(
            "$contactCount",
            style: const TextStyle(fontSize: font15, color: mainColor),
          ),
          const SizedBox(width: sizedBox10),
          const Text(
            contactsHeading,
            style: TextStyle(fontSize: font15, color: mainColor),
          ),
        ],
      ),
    );
  }
}
