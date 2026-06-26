import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.errorText});
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorText));
  }
}
