import 'package:contacts_application/features/contacts_list/domain/contacts_details.dart';
import 'package:contacts_application/features/contacts_list/domain/contacts_repository.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_events.dart';
import 'package:contacts_application/features/contacts_list/presentation/bloc/contacts_bloc/contacts_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactsEvents, ContactsStates> {
  final repository = ContactsRepository();
  ContactsBloc() : super(InitialState()) {
    //event fetch contacts from Database
    //emit GetContacts state with [List<ContactsDetail>]
    
    on<GetContactsEvent>((event, emit) async {
      try {
        List<ContactsDetail> contacts = await repository.getContacts();
        emit(GetContacts(contacts: contacts));
      } catch (e) {
        emit(ErrorState(errorMessage: "Error in fetching contacts"));
      }
    });

    on<AddToContactsEvent>((event, emit) async {
      try {
        final name = event.name;
        final number = event.number;

        await repository.addToContacts(name, number);
        List<ContactsDetail> contacts = await repository.getContacts();
        emit(GetContacts(contacts: contacts));
      } catch (e) {
        emit(ErrorState(errorMessage: "Fail to add contact!"));
      }
    });
    on<RemoveContactEvent>((event, emit) async {
      try {
        final id = event.id;
        await repository.deleteContact(id);
        List<ContactsDetail> contacts = await repository.getContacts();
        emit(GetContacts(contacts: contacts));
      } catch (e) {
        emit(ErrorState(errorMessage: "Error in removing contacts"));
      }
    });
    on<UpdateContactEvent>((event, emit) async {
      try {
        final id = event.id;
        final name = event.name;
        final number = event.number;
        repository.updateContact(id, name, number);
        List<ContactsDetail> contacts = await repository.getContacts();

        emit(GetContacts(contacts: contacts));
      } catch (e) {
        emit(ErrorState(errorMessage: "Error in updating contacts"));
      }
    });
  }
}
