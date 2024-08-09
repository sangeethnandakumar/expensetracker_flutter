import 'package:expences/pages/profile_page.dart';
import 'package:expences/pages/tours/base/tour_manager.dart';
import 'package:flutter/material.dart';
import 'package:expences/bl/repos/config_repo.dart';
import 'package:expences/models/config_model.dart';
import 'package:expences/widgets/sync_appbar.dart';
import 'package:expences/pages/track_page.dart';
import 'package:expences/pages/records_page.dart';
import 'package:expences/pages/report_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final configRepository = ConfigRepository();
  final config = await configRepository.getById('defaultInstance');
  runApp(Home(config: config));
}

class Home extends StatelessWidget {
  final ConfigModel? config;

  const Home({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: AppWrapper(config: config),
    );
  }
}

class AppWrapper extends StatefulWidget {
  final ConfigModel? config;

  const AppWrapper({Key? key, required this.config}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late bool _showTour;

  @override
  void initState() {
    super.initState();
    _showTour = widget.config!.isFirstRun;
  }

  void _onTourComplete() async {
    setState(() {
      _showTour = false;
    });
    // Update config to set isFirstRun to false
    widget.config!.isFirstRun = false;
    // Save the updated config
    await ConfigRepository().update(widget.config!);
  }

  @override
  Widget build(BuildContext context) {
    return _showTour
        ? TourManager(onTourComplete: _onTourComplete)
        : MainApp(config: widget.config);
  }
}

class MainApp extends StatefulWidget {
  final ConfigModel? config;

  const MainApp({Key? key, required this.config}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  bool _isSyncing = false;
  static const int _syncDuration = 4;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
    _startSyncOnStartup();
  }

  void _initializePages() {
    _pages = [
      TrackPage(onSuccess: () => setState(() => _currentIndex = 1)),
      RecordsPage(),
      ProfilePage(),
    ];
  }

  void _startSyncOnStartup() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSync());
  }

  void _startSync() {
    setState(() => _isSyncing = true);
    Future.delayed(const Duration(seconds: _syncDuration),
            () => setState(() => _isSyncing = false));
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index);

  void _onMenuItemSelected(String value) => print("Selected menu item: $value");

  void _onAccountPressed() => print("Account icon pressed");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SyncAppBar(
        isSyncing: _isSyncing,
        syncDuration: _syncDuration,
        onMenuPressed: () => _onMenuItemSelected("Menu"),
        onAccountPressed: _onAccountPressed,
        appVersion: 'Free Version',
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}