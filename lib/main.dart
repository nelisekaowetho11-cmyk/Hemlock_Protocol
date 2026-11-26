
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PrimeNetApp());
}

const Color primeBlue = Color(0xFF168BFF);
const Color primeBackground = Color(0xFF050918);

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
        scaffoldBackgroundColor: primeBackground,
        colorScheme: const ColorScheme.dark(
          primary: primeBlue,
          secondary: Color(0xFF00C8FF),
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
      home: PrimeNetHome(
        darkMode: darkMode,
        onThemeChanged: (value) {
          setState(() => darkMode = value);
        },
      ),
    );
  }
}

class PrimeNetHome extends StatefulWidget {
  const PrimeNetHome({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<PrimeNetHome> createState() => _PrimeNetHomeState();
}

class _PrimeNetHomeState extends State<PrimeNetHome> {
  int selectedTab = 0;

  final List<String> titles = [
    'Home',
    'Create Profile',
    'Connection Logs',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const CreateScreen(),
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
        centerTitle: false,
      ),
      body: pages[selectedTab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 20),
        Container(
          height: 205,
          width: 205,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primeBlue, width: 4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x552695FF),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('👑', style: TextStyle(fontSize: 42)),
              Text(
                'P',
                style: TextStyle(
                  fontSize: 76,
                  fontWeight: FontWeight.w900,
                  color: primeBlue,
                ),
              ),
              Text(
                'DISCONNECTED',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Choose a profile to get started',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'SERVERS',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        for (final country in ['Brazil', 'USA', 'Germany', 'United Kingdom'])
          Card(
            child: ListTile(
              leading: const Icon(Icons.public, color: primeBlue),
              title: Text(country),
              subtitle: const Text('No profile configured'),
              trailing: const Text('-- ms'),
            ),
          ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'LIVE SPEED',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('↑ Upload: 0 KB/s'),
                    Text('↓ Download: 0 KB/s'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Your VPN profiles will appear here.'),
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
            subtitle: const Text('Switch between dark and light themes'),
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
                trailing: Text('0.1.0'),
              ),
              ListTile(
                title: Text('Developer'),
                trailing: Text('PrimeNet'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
