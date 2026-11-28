
import '../models/vpn_profile.dart';

class SshLinkParser {
  static VpnProfile parse(String input) {
    final link = input.trim();

    if (link.isEmpty) {
      throw const FormatException('SSH link is empty.');
    }

    final uri = Uri.tryParse(link);

    if (uri == null || uri.scheme.toLowerCase() != 'ssh') {
      throw const FormatException(
        'Invalid SSH link. Expected ssh:// format.',
      );
    }

    if (uri.host.isEmpty) {
      throw const FormatException('SSH server address is missing.');
    }

    if (uri.port < 1 || uri.port > 65535) {
      throw const FormatException('Invalid SSH port.');
    }

    final credentials = uri.userInfo.split(':');

    final username = Uri.decodeComponent(credentials.first);
    final password = credentials.length > 1
        ? Uri.decodeComponent(credentials.sublist(1).join(':'))
        : '';

    if (username.isEmpty) {
      throw const FormatException('SSH username is missing.');
    }

    final name = uri.fragment.isNotEmpty
        ? Uri.decodeComponent(uri.fragment)
        : 'SSH Profile';

    return VpnProfile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      protocol: 'SSH',
      server: uri.host,
      port: uri.port,
      username: username,
      password: password,
      originalLink: link,
    );
  }
}
