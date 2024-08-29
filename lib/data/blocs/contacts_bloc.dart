import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/contact.dart';
import '../database.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final DatabaseHelper _databaseHelper;

  ContactsBloc(this._databaseHelper) : super(ContactsInitial()) {
    on<LoadContacts>(_onLoadContacts);
    on<AddContact>(_onAddContact);
    on<UpdateContact>(_onUpdateContact);
    on<DeleteContact>(_onDeleteContact);
    on<UpsertContact>(_onUpsertContact);
  }

  void _onLoadContacts(LoadContacts event, Emitter<ContactsState> emitter) async {
    emitter(ContactsLoading());
    try {
      final items = await _databaseHelper.getAllContacts();
      emitter(ContactsLoadSuccess(items));
    } catch (_) {
      emitter(const ContactsLoadFailure('Failed to load contacts from the database'));
    }
  }

  void _onAddContact(AddContact event, Emitter<ContactsState> emitter) async {
    await _databaseHelper.insertContact(event.contact);
    add(LoadContacts());
  }

  void _onUpdateContact(UpdateContact event, Emitter<ContactsState> emitter) async {
    await _databaseHelper.updateContact(event.contact);
    add(LoadContacts());
  }

  void _onDeleteContact(DeleteContact event, Emitter<ContactsState> emitter) async {
    await _databaseHelper.deleteContact(event.contactId);
    add(LoadContacts());
  }

  void _onUpsertContact(UpsertContact event, Emitter<ContactsState> emitter) async {
    event.contact.id > 0 ? add(UpdateContact(event.contact)) : add(AddContact(event.contact));
  }
}

sealed class ContactsEvent {
  const ContactsEvent();
}

class LoadContacts extends ContactsEvent {}

class AddContact extends ContactsEvent {
  final Contact contact;

  const AddContact(this.contact);
}

class UpdateContact extends ContactsEvent {
  final Contact contact;

  const UpdateContact(this.contact);
}

class UpsertContact extends ContactsEvent {
  final Contact contact;

  const UpsertContact(this.contact);
}

class DeleteContact extends ContactsEvent {
  final int contactId;

  const DeleteContact(this.contactId);
}

sealed class ContactsState {
  const ContactsState();
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoadSuccess extends ContactsState {
  final List<Contact> items;

  const ContactsLoadSuccess(this.items);
}

class ContactsLoadFailure extends ContactsState {
  final String message;

  const ContactsLoadFailure(this.message);
}
