abstract class ContactsEvents {
  const ContactsEvents();
}

class GetContactsEvent extends ContactsEvents {
  // @override
  // List<Object> get props => [];
}

class AddToContactsEvent extends ContactsEvents {
  final String name;
  final String number;

  AddToContactsEvent({required this.name, required this.number});
}

class RemoveContactEvent extends ContactsEvents {
  final int id;

  RemoveContactEvent({required this.id});
}

class UpdateContactEvent extends ContactsEvents {
  final int id;
  final String name;
  final String number;

  UpdateContactEvent(
      {required this.id, required this.name, required this.number});
}
