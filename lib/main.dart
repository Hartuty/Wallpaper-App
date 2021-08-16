import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/data/pexel_data.dart';

import 'screens/homepage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Pexeldata()),
      ],
      child: Home(),
    ),
  );
}
