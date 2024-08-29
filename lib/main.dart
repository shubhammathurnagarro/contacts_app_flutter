import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/common.dart';
import 'common/text_styles.dart';
import 'data/blocs/contacts_bloc.dart';
import 'data/database.dart';
import 'widgets/add_contact_screen.dart';
import 'widgets/contact_list_screen.dart';
import 'widgets/favorite_contacts_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ContactsBloc(DatabaseHelper()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          appBarTheme: AppBarTheme(
            titleTextStyle: appBarTitleStyle,
            centerTitle: true,
          ),
        ),
        initialRoute: Routes.home.routeName,
        routes: <String, WidgetBuilder>{
          Routes.home.routeName: (_) => const ContactListScreen(),
          Routes.addContact.routeName: (context) =>
              AddContactScreen(editContact: castOrNull(ModalRoute.of(context)?.settings.arguments)),
          Routes.favorites.routeName: (_) => const FavoriteContactsScreen(),
        },
      ),
    );
  }
}
