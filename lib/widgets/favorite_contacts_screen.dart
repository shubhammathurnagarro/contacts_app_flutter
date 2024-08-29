import 'package:flutter/material.dart';

import '../common/widgets_common.dart';
import 'contact_list_wrapper.dart';

class FavoriteContactsScreen extends StatelessWidget {
  const FavoriteContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Contacts'),
        leading: buildBackButtonWidget(context),
      ),
      body: _buildFavoriteContactsListWidget(context),
    );
  }

  Widget _buildFavoriteContactsListWidget(BuildContext context) {
    return const ContactListWrapper(
      isFavoritePage: true,
    );
  }
}
