
import 'package:flutter/material.dart';

const Color createBlue = Color(0xFF168BFF);
const Color createCyan = Color(0xFF00C8FF);

class PrimeNetCreateScreen extends StatefulWidget {
  const PrimeNetCreateScreen({super.key});

  @override
  State<PrimeNetCreateScreen> createState() =>
      _PrimeNetCreateScreenState();
}

class _PrimeNetCreateScreenState
    extends State<PrimeNetCreateScreen> {
  final nameController = TextEditingController();
  final serverController = TextEditingController();
  final portController = TextEditingController();
  final uuidController = TextEditingController();
  final passwordController = TextEditingController();
  final sniController = TextEditingController();
  final flowController = TextEditingController();

  String protocol = 'VLESS';
  String transport = 'TCP';
  String security = 'None';
  String pastedAccount = '';

  final protocols = [
    'VLESS',
    'VMess',
    'Trojan',
    'Shadowsocks',
    'SSH',
  ];

  final transports = [
    'TCP',
    'WebSocket',
    'gRPC',
    'HTTPUpgrade',
    'XHTTP',
  ];

  final securities = [
    'None',
    'TLS',
    'REALITY',
  ];

  @override
  void dispose() {
    nameController.dispose();
    serverController.dispose();
    portController.dispose();
    uuidController.dispose();
    passwordController.dispose();
    sniController.dispose();
    flowController.dispose();
    super.dispose();
  }

  void detectProtocol(String link) {
    final value = link.trim().toLowerCase();

    if (value.startsWith('vless://')) {
      protocol = 'VLESS';
    } else if (value.startsWith('vmess://')) {
      protocol = 'VMess';
    } else if (value.startsWith('trojan://')) {
      protocol = 'Trojan';
    } else if (value.startsWith('ss://')) {
      protocol = 'Shadowsocks';
    } else if (value.startsWith('ssh://')) {
      protocol = 'SSH';
    }
  }

  Future<void> pasteAccount() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import VPN Account'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Paste your VPN account link here',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );

    if (result == null || result.trim().isEmpty) return;

    setState(() {
      pastedAccount = result.trim();
      detectProtocol(pastedAccount);
    });

    controller.dispose();

    if (!protocols.contains(protocol) ||
        !RegExp(r'^(vless|vmess|trojan|ss|ssh)://',
                caseSensitive: false)
            .hasMatch(pastedAccount)) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unsupported account link format.'),
        ),
      );
    }
  }

  Widget inputField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget dropdownField(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void validateProfile() {
    if (nameController.text.trim().isEmpty ||
        pastedAccount.isEmpty &&
            (serverController.text.trim().isEmpty ||
                portController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete the required profile fields.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile details validated. Profile storage will be connected next.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MY PROFILES',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.add_circle,
                  color: createBlue,
                  size: 32,
                ),
                onSelected: (choice) {
                  if (choice == 'manual') {
                    setState(() {
                      pastedAccount = '';
                    });
                  } else if (choice == 'paste') {
                    pasteAccount();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$choice import will be implemented next.',
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'manual',
                    child: Text('Create Manually'),
                  ),
                  PopupMenuItem(
                    value: 'paste',
                    child: Text('Paste Account Link'),
                  ),
                  PopupMenuItem(
                    value: 'Trial Code',
                    child: Text('Import Trial Code'),
                  ),
                  PopupMenuItem(
                    value: 'PrimeNet Code',
                    child: Text('Import PrimeNet Code'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Create and manage your VPN profiles',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 22),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note, color: createBlue),
                      SizedBox(width: 9),
                      Text(
                        'PROFILE CONFIGURATION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (pastedAccount.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: createBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.link,
                            color: createBlue,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text('Account link imported'),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                pastedAccount = '';
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),

                  inputField(
                    'Profile Name',
                    nameController,
                    hint: 'My PrimeNet Profile',
                  ),

                  dropdownField(
                    'Protocol',
                    protocol,
                    protocols,
                    (value) {
                      if (value != null) {
                        setState(() => protocol = value);
                      }
                    },
                  ),

                  if (pastedAccount.isEmpty) ...[
                    if (protocol != 'SSH')
                      dropdownField(
                        'Transport',
                        transport,
                        transports,
                        (value) {
                          if (value != null) {
                            setState(() => transport = value);
                          }
                        },
                      ),

                    inputField(
                      'Server Address',
                      serverController,
                      hint: 'server.example.com',
                    ),

                    inputField(
                      'Port',
                      portController,
                      hint: '443',
                      keyboard: TextInputType.number,
                    ),

                    if (protocol == 'VLESS' ||
                        protocol == 'VMess')
                      inputField(
                        'UUID',
                        uuidController,
                        hint: 'Account UUID',
                      ),

                    if (protocol == 'Trojan' ||
                        protocol == 'Shadowsocks' ||
                        protocol == 'SSH')
                      inputField(
                        protocol == 'SSH'
                            ? 'SSH Password'
                            : 'Password',
                        passwordController,
                      ),

                    if (protocol == 'VLESS')
                      inputField(
                        'Flow',
                        flowController,
                        hint: 'xtls-rprx-vision (if required)',
                      ),

                    if (protocol != 'SSH' &&
                        protocol != 'Shadowsocks')
                      dropdownField(
                        'Security',
                        security,
                        securities,
                        (value) {
                          if (value != null) {
                            setState(() => security = value);
                          }
                        },
                      ),

                    if (security == 'TLS' ||
                        security == 'REALITY')
                      inputField(
                        'SNI / Server Name',
                        sniController,
                      ),
                  ],

                  if (pastedAccount.isNotEmpty)
                    const Text(
                      'The original account link is retained for the import step. Full parsing and validation will be added separately.',
                      style: TextStyle(color: Colors.grey),
                    ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: validateProfile,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('VALIDATE PROFILE'),
                      style: FilledButton.styleFrom(
                        backgroundColor: createBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Center(
            child: Text(
              'PrimeNet VPN • Profile Manager',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
