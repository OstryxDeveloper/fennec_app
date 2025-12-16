import 'package:flutter/material.dart';

import '../di_container.dart';

class AppInitalizer {
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    Di().init();
  }
}
