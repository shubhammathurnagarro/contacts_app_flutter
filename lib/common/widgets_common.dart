import 'package:flutter/material.dart';

Widget verticalSpacing(double height) => SizedBox(height: height);

Widget horizontalSpacing(double width) => SizedBox(width: width);

Widget buildBackButtonWidget(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => Navigator.pop(context),
    );
