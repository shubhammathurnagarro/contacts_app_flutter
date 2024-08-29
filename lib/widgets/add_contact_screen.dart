import 'package:contacts_demo/common/widgets_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/text_styles.dart';
import '../data/blocs/contacts_bloc.dart';
import '../models/contact.dart';
import 'add_contact_form.dart';

class AddContactScreen extends StatefulWidget {
  final Contact? editContact;

  const AddContactScreen({super.key, this.editContact});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  bool _isFavorite = false;
  bool _isInEditMode = false;

  @override
  void initState() {
    super.initState();
    _isInEditMode = widget.editContact != null;
    _isFavorite = widget.editContact?.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isInEditMode ? 'Update Contact' : 'Add Contact'),
        leading: buildBackButtonWidget(context),
        actions: _buildActionIcons(),
      ),
      body: AddContactForm(
        editContact: widget.editContact,
        onSaved: (contact) {
          contact.isFavorite = _isFavorite;
          context.read<ContactsBloc>().add(UpsertContact(contact));
          Navigator.pop(context);
        },
      ),
    );
  }

  List<Widget> _buildActionIcons() {
    List<Widget> actions = [
      IconButton(
        onPressed: () {
          setState(() => _isFavorite = !_isFavorite);
        },
        icon: Icon(
          _isFavorite ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
      ),
    ];

    if (_isInEditMode) {
      actions.add(IconButton(
        onPressed: () {
          _showDeleteContactDialog(() {
            context.read<ContactsBloc>().add(DeleteContact(widget.editContact!.id));
            Navigator.pop(context);
          });
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ));
    }

    return actions;
  }

  Future<void> _showDeleteContactDialog(void Function() onDelete) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: const Text(
            'Do you want to delete this contact?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: popupDialogButtonTextStyle,
                )),
          ],
        );
      },
    );
  }
}
