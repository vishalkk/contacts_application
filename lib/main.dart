import 'package:contacts_application/Util/colors.dart';
import 'package:contacts_application/Util/string_constants.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:contacts_application/features/contacts_list/presentation/pages/contacts_list_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: myContacts,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
        primarySwatch: Colors.grey,
      ),
      home: MultiBlocProvider(providers: [
        BlocProvider<ContactsBloc>(
          create: (context) => ContactsBloc(),
        ),
      ], child: const ContactsListPage()),
    );
  }
}
