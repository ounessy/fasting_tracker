import 'package:flutter/material.dart';

class ErrorUI extends StatelessWidget {
  final String error_text;
  const ErrorUI({super.key, required this.error_text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error_text),
    );
  }
}
