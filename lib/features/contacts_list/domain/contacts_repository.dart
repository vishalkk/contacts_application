import 'package:contacts_application/features/contacts_list/data/sql_helper.dart';
import 'package:contacts_application/features/contacts_list/domain/contacts_details.dart';

class ContactsRepository {
  Future<List<ContactsDetail>> getContacts() async {
    final data = await SQLHelper.getItems();
    List<ContactsDetail> contactsDetails = [];

    for (var item in data) {
      contactsDetails.add(ContactsDetail(
          id: item['id'] as int,
          name: item['name'] as String,
          number: item['number'] as String));
    }
    return contactsDetails;
  }

  //To add new contact
  Future<dynamic> addToContacts(String name, String number) async {
    late int id;
    try {
      await SQLHelper.createItem(name, number);
    } catch (e) {}
  }

  Future<void> updateContact(int id, String name, String number) async {
    await SQLHelper.updateItem(id, name, number);
  }

  Future<void> deleteContact(int id) async {
    await SQLHelper.deleteItem(id);
  }
}
