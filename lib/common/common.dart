import 'package:flutter/material.dart';

String appTitle = 'Contacts List';

enum Routes {
  home('/'),
  addContact('add_contact'),
  favorites('favorites');

  final String routeName;

  const Routes(this.routeName);
}

showSnackBar(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

extension StringExtensions on String {
  String getNameInitials() => split(' ').map((e) => e[0]).take(2).join();
}

Color generateInitialsBackgroundColor(index) {
  return Colors.primaries[index % Colors.primaries.length];
}

T? castOrNull<T>(Object? object) => object is T ? object : null;
