import 'package:contacts_demo/common/common.dart';
import 'package:flutter/material.dart';

import 'contact_list_wrapper.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appTitle)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeaderWidget(context),
            ListTile(
              title: Text(appTitle),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Favorites'),
              selected: false,
              onTap: () {
                Navigator.pop(context);
                _navigateToFavoriteContactsScreen(context);
              },
            ),
            ListTile(
              title: const Text('Add new contact'),
              selected: false,
              onTap: () {
                Navigator.pop(context);
                _navigateToAddContactScreen(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => _navigateToAddContactScreen(context),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: _buildContactListWidget(context),
    );
  }

  Widget _buildDrawerHeaderWidget(BuildContext context) => DrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
        padding: const EdgeInsets.all(10),
        child: const Column(
          children: [
            CircleAvatar(child: Text('SM')),
            Text('Shubham Mathur'),
            Text('Flutter Advanced Assignment'),
            Text('Nagarro'),
          ],
        ),
      );

  Widget _buildContactListWidget(BuildContext context) {
    return const ContactListWrapper();
  }

  void _navigateToAddContactScreen(BuildContext context) =>
      Navigator.pushNamed(context, Routes.addContact.routeName);

  void _navigateToFavoriteContactsScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.favorites.routeName);
  }
}
