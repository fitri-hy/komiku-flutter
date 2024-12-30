import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/ThemeProvider.dart';
import 'components/ThemeSwitcher.dart';
import 'components/Navbar.dart';
import 'screen/Search.dart';
import 'screen/Landing.dart';
import 'screen/Genre.dart';
import 'screen/Info.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Komiku',
      theme: themeProvider.themeData,
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: const MyHomePage(title: 'Komiku'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Landing(),
    Genre(),
    Info(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
	appBar: AppBar(
		leading: Padding(
		  padding: EdgeInsets.only(left: 16.0),
		  child: Image.asset('assets/logo.png', height: 20),
		),
		title: Text(
		  widget.title,
		  style: TextStyle(fontWeight: FontWeight.bold),
		),
		actions: [
		  IconButton(
			icon: Icon(Icons.search),
			onPressed: () {
			  Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => SearchScreen()),
			  );
			},
		  ),
		  ThemeSwitcher(),
		],
	  ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
