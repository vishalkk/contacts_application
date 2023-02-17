import 'package:contacts_application/features/contacts_list/domain/contacts_details.dart';

abstract class ContactsStates {
  const ContactsStates();
}

class InitialState extends ContactsStates {}

//get contacts from DB
class GetContacts extends ContactsStates {
  final List<ContactsDetail> contacts;
  GetContacts({
    required this.contacts,
  });
}

class ErrorState extends ContactsStates {
  final String errorMessage;

  ErrorState({required this.errorMessage});
}

class AddContactsState extends ContactsStates {}

class RemovedContacts extends ContactsStates {}
