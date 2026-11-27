
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimeNetLogsScreen extends StatefulWidget {
  const PrimeNetLogsScreen({super.key});

  @override
  State<PrimeNetLogsScreen> createState() =>
      _PrimeNetLogsScreenState();
}

class _PrimeNetLogsScreenState extends State<PrimeNetLogsScreen> {
  final List<String> logs = [];

  Future<void> copyLogs() async {
    if (logs.isEmpty) return;

    await Clipboard.setData(
      ClipboardData(text: logs.join('\n')),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logs copied')),
    );
  }

  void clearLogs() {
    setState(() => logs.clear());
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final green = const Color(0xFF00D68F);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CONNECTION LOGS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear logs',
            onPressed: logs.isEmpty ? null : clearLogs,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: dark
                    ? const Color(0xFF101820)
                    : const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: green.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.terminal, color: green, size: 25),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'PRIMENET TERMINAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Text(
                    'READY',
                    style: TextStyle(
                      color: green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF080D12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: logs.isEmpty
                    ? Center(
                        child: Text(
                          'No connection logs yet.\n\n'
                          'Engine messages will appear here '
                          'when logging is connected.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            height: 1.7,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              logs[index],
                              style: TextStyle(
                                color: green,
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: logs.isEmpty ? null : copyLogs,
                    icon: const Icon(Icons.copy),
                    label: const Text('COPY LOGS'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: logs.isEmpty ? null : clearLogs,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('CLEAR LOGS'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
