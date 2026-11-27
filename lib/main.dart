
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/create_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PrimeNetApp());
}

const Color primeBlue = Color(0xFF168BFF);
const Color primeCyan = Color(0xFF00C8FF);
const Color primeNavy = Color(0xFF050918);

class PrimeNetApp extends StatefulWidget {
  const PrimeNetApp({super.key});

  @override
  State<PrimeNetApp> createState() => _PrimeNetAppState();
}

class _PrimeNetAppState extends State<PrimeNetApp> {
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrimeNet VPN',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primeNavy,
        colorScheme: const ColorScheme.dark(
          primary: primeBlue,
          secondary: primeCyan,
          surface: Color(0xFF101B32),
        ),
        useMaterial3: true,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primeBlue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: PrimeNetShell(
        darkMode: darkMode,
        onThemeChanged: (value) {
          setState(() => darkMode = value);
        },
      ),
    );
  }
}

class PrimeNetShell extends StatefulWidget {
  const PrimeNetShell({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<PrimeNetShell> createState() => _PrimeNetShellState();
}

class _PrimeNetShellState extends State<PrimeNetShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const PrimeNetHomeScreen(),
      const PrimeNetCreateScreen(),
      const LogsScreen(),
      SettingsScreen(
        darkMode: widget.darkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '👑 PrimeNet VPN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.shield_outlined, color: primeBlue),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Logs',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Connection logs will appear here.'),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'APPEARANCE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Choose your app appearance'),
            value: darkMode,
            onChanged: onThemeChanged,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'APP INFORMATION',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Card(
          child: Column(
            children: [
              ListTile(
                title: Text('Application'),
                trailing: Text('PrimeNet VPN'),
              ),
              ListTile(
                title: Text('Version'),
                trailing: Text('1.0.0'),
              ),
              ListTile(
                title: Text('Developer'),
                trailing: Text('Hemlock Protocol'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
