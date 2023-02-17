import 'package:contacts_application/features/contacts_list/domain/contacts_details.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_events.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_states.dart';
import 'package:contacts_application/features/contacts_list/presentation/pages/profile_page.dart';
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
  @override
  void initState() {
    print("--------------------------------------call get contacts event");
    _contactsBloc.add(GetContactsEvent());
    // context.read<ContactsBloc>().add(GetContactsEvent());
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 120,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            //contact number serachbar
            contactsSearchBar(),
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
                /*
                                List of contacts
                                */
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: contactList.length,
                      itemBuilder: (context, index) {
                        final contact = contactList[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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

                              // Shows the information on Snackbar
                              // Scaffold.of(context).showSnackBar(
                              //     SnackBar(content: Text(" dismissed")));
                            },
                            background: Container(
                                color: Colors.red,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          "DELETE",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=$index'),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contact.name,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          contact.number,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          _makingPhoneCall(contact.number);
                                        },
                                        icon: const Icon(Icons.phone)),
                                    IconButton(
                                        onPressed: () {
                                          _showForm(contact.id, context);
                                        },
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          _contactsBloc.add(RemoveContactEvent(
                                            id: contact.id,
                                          ));
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                              contactsDetail: contact,
                                              imageUrl:
                                                  'https://i.pravatar.cc/150?img=$index',
                                            )));
                              },
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade50,
        onPressed: () => _showForm(null, context),
        child: const Icon(Icons.add),
      ),
      // ),
    );
  }

  Container contactsSearchBar() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        cursorColor: Colors.grey,
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.menu),
          suffixIcon: SizedBox(
            width: 80,
            child: Row(
              children: const [
                //more vertical icon
                Icon(Icons.more_vert),
                //searchbar icon
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=1',
                  ),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          hintText: 'Search contacts',
          hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }

  final customEnableBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1));
  final customFocusBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54, width: 1.5));
  final customLableStyle = const TextStyle(
      color: Colors.black54, fontSize: 13, fontWeight: FontWeight.bold);
  //show bottomsheet
  void _showForm(int? id, context) {
    //if id is present in db update this contact
    if (id != null) {
      final existingContact =
          contactList.firstWhere((element) => element.id == id);
      contactNumberController.text = existingContact.number;
      firstNameController.text = existingContact.name.split(" ").first;
      lastNameController.text = existingContact.name.split(" ").last;
    }

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    color: Colors.deepPurple.shade50,
                    height: 350,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50, right: 10.0, top: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Add new contact",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.clear_sharp)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 180,
                          width: 300,
                          child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 43,
                                    child: TextFormField(
                                      controller: contactNumberController,
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Mobile Number",
                                        labelStyle: customLableStyle,
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 12.0, left: 10),
                                          child: Text(
                                            "+91",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        enabledBorder: customEnableBorder,
                                        focusedBorder: customFocusBorder,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 43,
                                        width: 120,
                                        child: TextFormField(
                                          controller: firstNameController,
                                          // onSubmitted: (value) {},
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "First Name",
                                            labelStyle: customLableStyle,
                                            enabledBorder: customEnableBorder,
                                            focusedBorder: customFocusBorder,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        height: 43,
                                        width: 150,
                                        child: TextFormField(
                                          controller: lastNameController,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "Last Name",
                                            labelStyle: customLableStyle,
                                            enabledBorder: customEnableBorder,
                                            focusedBorder: customFocusBorder,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                String name = firstNameController.text +
                                    " " +
                                    lastNameController.text;
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
                                fixedSize: const Size(200, 50),
                                backgroundColor: Colors.deepPurple),
                            child: Text(
                              id == null ? 'Create New' : 'Update',
                              style: const TextStyle(color: Colors.white),
                            ))
                      ],
                    )),
              ],
            ),
          );
        });
  }
}

class MainUserInfoWidget extends StatelessWidget {
  final int contactCount;
  const MainUserInfoWidget({
    required this.contactCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Icon(
            Icons.person,
            color: Colors.grey,
          ),
          const SizedBox(width: 10),

          /*
        User email id 
        */
          const Text(
            "vishalkajales@gmail.com",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          SizedBox(width: 10),
          /*
        contacts count
        */
          Text(
            "$contactCount",
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          const Text(
            "contacts",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
