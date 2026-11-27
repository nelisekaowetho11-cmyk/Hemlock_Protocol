
import '../models/vpn_profile.dart';

class ProfileValidator {
  static List<String> validate(VpnProfile profile) {
    final errors = <String>[];

    if (profile.name.trim().isEmpty) {
      errors.add('Profile name is required.');
    }

    if (profile.server.trim().isEmpty) {
      errors.add('Server address is required.');
    } else if (profile.server.contains(' ')) {
      errors.add('Server address cannot contain spaces.');
    }

    if (profile.port < 1 || profile.port > 65535) {
      errors.add('Port must be between 1 and 65535.');
    }

    const protocols = [
      'VLESS',
      'VMess',
      'Trojan',
      'Shadowsocks',
      'SSH',
    ];

    if (!protocols.contains(profile.protocol)) {
      errors.add('Unsupported VPN protocol.');
    }

    switch (profile.protocol) {
      case 'VLESS':
      case 'VMess':
        if (profile.uuid.trim().isEmpty) {
          errors.add('A UUID is required.');
        }
        break;

      case 'Trojan':
        if (profile.password.isEmpty) {
          errors.add('A Trojan password is required.');
        }
        break;

      case 'Shadowsocks':
        if (profile.password.isEmpty) {
          errors.add('A Shadowsocks password is required.');
        }
        if (profile.encryption.trim().isEmpty) {
          errors.add('Encryption method is required.');
        }
        break;

      case 'SSH':
        if (profile.username.trim().isEmpty) {
          errors.add('SSH username is required.');
        }
        if (profile.password.isEmpty) {
          errors.add('SSH password is required.');
        }
        break;
    }

    const transports = [
      'TCP',
      'WebSocket',
      'gRPC',
      'HTTPUpgrade',
      'XHTTP',
    ];

    if (!transports.contains(profile.transport)) {
      errors.add('Unsupported transport.');
    }

    const securityOptions = [
      'None',
      'TLS',
      'REALITY',
    ];

    if (!securityOptions.contains(profile.security)) {
      errors.add('Unsupported security option.');
    }

    if (profile.security == 'REALITY') {
      if (profile.publicKey.trim().isEmpty) {
        errors.add('REALITY public key is required.');
      }

      if (profile.shortId.trim().isEmpty) {
        errors.add('REALITY short ID is required.');
      }
    }

    if (profile.security == 'TLS' &&
        profile.sni.trim().isEmpty) {
      errors.add('TLS server name (SNI) is required.');
    }

    return errors;
  }

  static bool isValid(VpnProfile profile) {
    return validate(profile).isEmpty;
  }
}
