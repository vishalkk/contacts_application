import 'package:equatable/equatable.dart';

class ContactsDetail extends Equatable {
  final int id;
  final String name;
  final String number;

  const ContactsDetail({
    required this.id,
    required this.name,
    required this.number,
  });

  @override
  List<Object> get props => [id, name, number];
}
