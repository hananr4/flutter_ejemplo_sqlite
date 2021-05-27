import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'data/dog-provider.dart';
import 'pages/home-page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DogManager()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<DogManager>(context)..init();

    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}
