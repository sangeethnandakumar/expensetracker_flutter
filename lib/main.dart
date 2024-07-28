import 'package:expences/widgets/sync_appbar.dart';
import 'package:flutter/material.dart';
import 'pages/track_page.dart';
import 'pages/records_page.dart';
import 'pages/tools_page.dart';
import 'pages/report_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool _isSyncing = false;
  int _syncDuration = 4; // Default sync duration in seconds

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TrackPage(
        onSuccess: () {
          setState(() {
            _currentIndex = 1; // Index of Records page
          });
        },
      ),
      RecordsPage(),
      ToolsPage(),
      ReportPage(),
    ];

    // Show sync bar for the specified duration on startup for demonstration
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSync(_syncDuration);
    });
  }

  void _startSync(int duration) {
    setState(() {
      _isSyncing = true;
    });

    Future.delayed(Duration(seconds: duration), () {
      setState(() {
        _isSyncing = false;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onMenuItemSelected(String value) {
    // Handle menu item selection here
    print("Selected menu item: $value");
  }

  void _onAccountPressed() {
    // Handle account icon press here
    print("Account icon pressed");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: Scaffold(
        appBar: SyncAppBar(
          isSyncing: _isSyncing,
          syncDuration: _syncDuration, // Pass the sync duration
          onMenuPressed: () => _onMenuItemSelected("Menu"),
          onAccountPressed: _onAccountPressed,
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Track',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Records',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
