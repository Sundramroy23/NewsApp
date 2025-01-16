import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;
  const HomePage({Key? key,required this.themeMode, required this.toggleTheme}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News MunchXX'),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print("Search Pressed");
            },
          ),
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: const Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: FlutterLogo(),
          )
        ],
      ),
    );
  }
}
