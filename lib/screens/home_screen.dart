
import 'package:flutter/material.dart';

const Color homeBlue = Color(0xFF168BFF);
const Color homeCyan = Color(0xFF00C8FF);

class PrimeNetHomeScreen extends StatefulWidget {
  const PrimeNetHomeScreen({super.key});

  @override
  State<PrimeNetHomeScreen> createState() =>
      _PrimeNetHomeScreenState();
}

class _PrimeNetHomeScreenState extends State<PrimeNetHomeScreen> {
  String selectedServer = 'Brazil';

  final List<Map<String, String>> servers = [
    {'name': 'Brazil', 'flag': '🇧🇷'},
    {'name': 'USA', 'flag': '🇺🇸'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'United Kingdom', 'flag': '🇬🇧'},
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 12),

        Center(
          child: Container(
            width: 205,
            height: 205,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: homeBlue,
                width: 4,
              ),
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
                Text('👑', style: TextStyle(fontSize: 38)),
                Text(
                  'P',
                  style: TextStyle(
                    color: homeBlue,
                    fontSize: 76,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'DISCONNECTED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        const Center(
          child: Text(
            'PRIMENET VPN',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),

        const SizedBox(height: 6),

        const Center(
          child: Text(
            'VPN engine not configured',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          'SELECT SERVER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 12),

        ...servers.map((server) {
          final name = server['name']!;
          final selected = selectedServer == name;

          return Card(
            elevation: 0,
            color: selected
                ? homeBlue.withValues(alpha: 0.13)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: selected
                    ? homeBlue
                    : dark
                        ? Colors.white12
                        : Colors.black12,
              ),
            ),
            child: ListTile(
              onTap: () {
                setState(() => selectedServer = name);
              },
              leading: Text(
                server['flag']!,
                style: const TextStyle(fontSize: 27),
              ),
              title: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text('No profile assigned'),
              trailing: selected
                  ? const Icon(
                      Icons.check_circle,
                      color: homeBlue,
                    )
                  : const Text('-- ms'),
            ),
          );
        }),

        const SizedBox(height: 20),

        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.speed, color: homeBlue),
                    SizedBox(width: 9),
                    Text(
                      'LIVE CONNECTION SPEED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('↑ UPLOAD'),
                        SizedBox(height: 5),
                        Text(
                          '0 KB/s',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: homeBlue,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('↓ DOWNLOAD'),
                        SizedBox(height: 5),
                        Text(
                          '0 KB/s',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: homeCyan,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }
}
