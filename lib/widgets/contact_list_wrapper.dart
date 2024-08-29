import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart';
import '../common/text_styles.dart';
import '../data/blocs/contacts_bloc.dart';
import '../models/contact.dart';
import 'contact_list.dart';
import 'loader_widget.dart';

class ContactListWrapper extends StatelessWidget {
  const ContactListWrapper({super.key, this.isFavoritePage = false});

  final bool isFavoritePage;

  @override
  Widget build(BuildContext context) {
    context.read<ContactsBloc>().add(LoadContacts());

    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is ContactsLoading) {
          return const LoaderWidget();
        }

        if (state is ContactsLoadSuccess) {
          List<Contact> contacts = isFavoritePage
              ? state.items.where((contact) => contact.isFavorite).toList()
              : state.items;
          if (contacts.isNotEmpty) {
            return ContactList(
              contactList: contacts,
              onContactClicked: (contact) => _navigateToUpdateContactScreen(context, contact),
            );
          } else {
            return _buildErrorTextWidget(
                isFavoritePage ? 'No favorite contacts found' : 'No contacts found');
          }
        }

        if (state is ContactsLoadFailure) {
          return _buildErrorTextWidget(state.message);
        }

        return Container();
      },
    );
  }

  Widget _buildErrorTextWidget(String text) {
    return Center(
      child: Text(
        text,
        style: nameInitialsTextStyle,
      ),
    );
  }

  void _navigateToUpdateContactScreen(BuildContext context, Contact contact) =>
      Navigator.pushNamed(context, Routes.addContact.routeName, arguments: contact);
}
