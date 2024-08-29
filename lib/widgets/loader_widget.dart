import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 20,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Center(child: CircularProgressIndicator(strokeWidth: 4)),
          ),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
