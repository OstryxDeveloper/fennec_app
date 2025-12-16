import 'package:fennac_app/app/app.dart';
import 'package:fennac_app/core/initialization/app_initalization.dart';
import 'package:flutter/material.dart';

void main() async {
  try {
    await AppInitalizer.init();
    runApp(const MyApp());
  } catch (error, stackTrace) {
    debugPrint('Initialization failed: $error');
    debugPrint('Stack trace: $stackTrace');
    runApp(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Initialization error'))),
      ),
    );
  }
}
