import 'package:contacts_application/Util/colors.dart';
import 'package:contacts_application/Util/string_constants.dart';
import 'package:contacts_application/Util/value_constant.dart';
import 'package:contacts_application/features/contacts_list/domain/contacts_details.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_events.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_states.dart';
import 'package:contacts_application/features/contacts_list/presentation/pages/profile_page.dart';
import 'package:contacts_application/features/contacts_list/presentation/widgets/contact_search_bar.dart';
import 'package:contacts_application/features/contacts_list/presentation/widgets/main_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  List<ContactsDetail> contactList = [];
  final ContactsBloc _contactsBloc = ContactsBloc();
  final contactNumberController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final String url = imageUrl;
  @override
  void initState() {
    _contactsBloc.add(GetContactsEvent());
    super.initState();
  }

  _makingPhoneCall(String number) async {
    var url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        toolbarHeight: toolbarHeight120,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: sizedBox20,
            ),
            //contact number serachbar
            const ContactSearchBar(),

            //login user info
            MainUserInfoWidget(
              contactCount: contactList.length,
            ),
          ],
        ),
      ),
      body: BlocListener<ContactsBloc, ContactsStates>(
          bloc: _contactsBloc,
          listener: (context, state) {
            if (state is GetContacts) {
              setState(() {
                contactList = state.contacts;
              });
            }
          },
          child: Center(
            child: Column(
              children: [
                //List of contacts

                contactsListView(),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: deepPurpleShade,
        onPressed: () => _showForm(null, context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Expanded contactsListView() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            final contact = contactList[index];
            return Padding(
              padding: const EdgeInsets.only(top: padding8),
              child: Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(contact.name),
                onDismissed: (direction) {
                  // Removes that item the list on swipwe
                  setState(() {
                    contactList.removeAt(index);
                  });
                  _contactsBloc.add(RemoveContactEvent(
                    id: contact.id,
                  ));
                },
                background: dismssibleBackgroudWidget(),
                child: contactTile(index, contact, context),
              ),
            );
          }),
    );
  }

  Container dismssibleBackgroudWidget() {
    return Container(
      color: red,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Padding(
              padding: EdgeInsets.only(right: padding8),
              child: Text(
                delete,
                style: TextStyle(
                    color: white,
                    fontSize: font20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile contactTile(
      int index, ContactsDetail contact, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          radius: radius25,
          backgroundImage: NetworkImage('$url$index'),
          backgroundColor: transparent),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          contactDetail(contact),
          const Spacer(),
          IconButton(
              onPressed: () {
                _makingPhoneCall(contact.number);
              },
              icon: const Icon(
                Icons.phone,
                color: deepPurple,
              )),
          IconButton(
              onPressed: () {
                _showForm(contact.id, context);
              },
              icon: const Icon(Icons.edit, color: deepPurple)),
          IconButton(
              onPressed: () {
                _contactsBloc.add(RemoveContactEvent(
                  id: contact.id,
                ));
              },
              icon: const Icon(Icons.delete, color: deepPurple)),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      contactsDetail: contact,
                      imageUrl: '$url$index',
                    )));
      },
    );
  }

  Column contactDetail(ContactsDetail contact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contact.name,
          style:
              const TextStyle(fontSize: font20, fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: sizedBox10,
        ),
        Text(
          contact.number,
          style:
              const TextStyle(fontSize: font13, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  final customEnableBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: mainColor, width: width1));
  final customFocusBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: black54, width: width2));
  final customLableStyle = const TextStyle(
      color: black54, fontSize: font13, fontWeight: FontWeight.bold);

  //show bottomsheet for adding or updating contacts
  void _showForm(int? id, context) {
    //if id is  present in db update this contact
    //else create new one
    if (id != null) {
      final existingContact =
          contactList.firstWhere((element) => element.id == id);
      contactNumberController.text = existingContact.number;
      //separatin full name in two half
      firstNameController.text = existingContact.name.split(" ").first;
      lastNameController.text = existingContact.name.split(" ").last;
    }

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius30),
                topRight: Radius.circular(radius30))),
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    color: deepPurpleShade,
                    height: sizedBox350,
                    child: Column(
                      children: [
                        contactBottomsheetTopHeading(context),
                        SizedBox(
                          height: sizedBox180,
                          width: sizedBox300,
                          child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  contactNumberField(),
                                  const SizedBox(
                                    height: sizedBox20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      firstNameField(),
                                      const SizedBox(
                                        width: sizedBox20,
                                      ),
                                      lastNameField(),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        contactButton(id, context)
                      ],
                    )),
              ],
            ),
          );
        });
  }

  Padding contactBottomsheetTopHeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: padding50, right: padding10, top: padding10, bottom: padding10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            addNewContact,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear_sharp)),
        ],
      ),
    );
  }

  Container lastNameField() {
    return Container(
      margin: const EdgeInsets.all(margin5),
      width: sizedBox120,
      child: TextFormField(
        controller: lastNameController,
        style: const TextStyle(
          color: black,
          fontSize: font13,
        ),
        decoration: InputDecoration(
          labelText: lastName,
          labelStyle: customLableStyle,
          enabledBorder: customEnableBorder,
          focusedBorder: customFocusBorder,
          contentPadding: const EdgeInsets.symmetric(
              vertical: padding10, horizontal: padding10),
          border: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
            borderRadius: BorderRadius.circular(radius10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return nameValidator;
          }
          return null;
        },
      ),
    );
  }

  Container firstNameField() {
    return Container(
      margin: const EdgeInsets.all(margin5),
      width: sizedBox120,
      child: TextFormField(
        controller: firstNameController,
        style: const TextStyle(
          color: black,
          fontSize: font13,
        ),
        decoration: InputDecoration(
          labelText: firstName,
          labelStyle: customLableStyle,
          enabledBorder: customEnableBorder,
          focusedBorder: customFocusBorder,
          contentPadding: const EdgeInsets.symmetric(
              vertical: padding10, horizontal: padding10),
          border: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
            borderRadius: BorderRadius.circular(radius10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return nameValidator;
          }
          return null;
        },
      ),
    );
  }

  Container contactNumberField() {
    return Container(
      margin: const EdgeInsets.all(margin5),
      child: TextFormField(
        controller: contactNumberController,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          color: black,
          fontSize: font13,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          labelText: mobileNumber,
          labelStyle: customLableStyle,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(top: padding12, left: padding10),
            child: Text(
              countryCode,
              style: TextStyle(fontSize: font13),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius10),
          ),
          enabledBorder: customEnableBorder,
          focusedBorder: customFocusBorder,
        ),
        validator: (value) {
          if (value == null || value.isEmpty || value.length > value10) {
            return contactNumberValidator;
          }
          return null;
        },
      ),
    );
  }

  ElevatedButton contactButton(int? id, BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState != null &&
              _formKey.currentState!.validate()) {
            String name =
                "${firstNameController.text} ${lastNameController.text}";
            String number = contactNumberController.text;
            //if id is not present in db create new contact
            if (id == null) {
              _contactsBloc.add(AddToContactsEvent(
                number: number,
                name: name,
              ));
            }
            if (id != null) {
              _contactsBloc.add(UpdateContactEvent(
                id: id,
                number: number,
                name: name,
              ));
            }

            // Clear the text fields
            firstNameController.text = "";
            lastNameController.text = "";
            contactNumberController.text = "";

            // Close the bottom sheet
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(sizedBox200, sizedBox5),
            backgroundColor: deepPurple),
        child: Text(
          id == null ? createNew : update,
          style: const TextStyle(color: white),
        ));
  }
}
