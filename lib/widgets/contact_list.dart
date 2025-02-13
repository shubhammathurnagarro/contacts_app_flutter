import 'dart:io';

import 'package:contacts_demo/common/common.dart';
import 'package:contacts_demo/common/text_styles.dart';
import 'package:contacts_demo/models/contact.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  final List<Contact> contactList;
  final void Function(Contact contact) onContactClicked;

  const ContactList({super.key, required this.contactList, required this.onContactClicked});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildContactImageWidget(
                index, contactList[index].name, contactList[index].photoPath),
          ),
          title: _buildContactNameWidget(contactList[index].name),
          onTap: () => onContactClicked(contactList[index]),
        );
      },
    );
  }

  Widget _buildContactImageWidget(int index, String contactName, String? imagePath) {
    double size = 40;
    File imageFile = File(imagePath ?? '');

    if (imagePath != null && imagePath.isNotEmpty && imageFile.existsSync()) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: FileImage(imageFile),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: generateInitialsBackgroundColor(index),
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
        contactName.getNameInitials(),
        style: nameInitialsTextStyle,
        maxLines: 1,
      )),
    );
  }

  Widget _buildContactNameWidget(String name) => Text(
        name,
        style: contactNameTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
}
