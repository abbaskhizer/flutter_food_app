import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  static const pagename = '/errorScreen';
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Error 404'),
    ));
  }
}
