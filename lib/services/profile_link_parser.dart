
import 'dart:convert';

import '../models/vpn_profile.dart';

class ProfileLinkParser {
  static VpnProfile parse(String input) {
    final link = input.trim();

    if (link.isEmpty) {
      throw const FormatException('Account link is empty.');
    }

    if (link.startsWith('vmess://')) {
      return _parseVmess(link);
    }

    if (link.startsWith('vless://')) {
      return _parseUri(link, 'VLESS');
    }

    if (link.startsWith('trojan://')) {
      return _parseUri(link, 'Trojan');
    }

    if (link.startsWith('ss://')) {
      return _parseShadowsocks(link);
    }

    throw const FormatException(
      'Unsupported link. Supported formats: VLESS, VMess, Trojan and Shadowsocks.',
    );
  }

  static VpnProfile _parseUri(String link, String protocol) {
    final uri = Uri.parse(link);

    if (uri.host.isEmpty || uri.port == 0) {
      throw const FormatException('Invalid server address or port.');
    }

    final query = uri.queryParameters;
    final transport = _transport(
      query['type'] ?? query['network'] ?? 'tcp',
    );

    final security = _security(query['security'] ?? 'none');

    return VpnProfile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: Uri.decodeComponent(
        uri.fragment.isEmpty ? protocol : uri.fragment,
      ),
      protocol: protocol,
      server: uri.host,
      port: uri.port,
      uuid: protocol == 'VLESS' ? uri.userInfo : '',
      password: protocol == 'Trojan' ? uri.userInfo : '',
      transport: transport,
      security: security,
      sni: query['sni'] ?? query['host'] ?? '',
      alpn: query['alpn'] ?? '',
      fingerprint: query['fp'] ?? '',
      publicKey: query['pbk'] ?? '',
      shortId: query['sid'] ?? '',
      flow: query['flow'] ?? '',
      encryption: query['encryption'] ?? '',
      networkPath: query['path'] ?? query['serviceName'] ?? '',
      originalLink: link,
    );
  }

  static VpnProfile _parseVmess(String link) {
    final encoded = link.substring('vmess://'.length);
    final decoded = _decodeBase64(encoded);

    final data = jsonDecode(decoded);

    if (data is! Map) {
      throw const FormatException('Invalid VMess account data.');
    }

    final server = data['add']?.toString() ?? '';
    final port = int.tryParse(data['port'].toString()) ?? 0;
    final uuid = data['id']?.toString() ?? '';

    if (server.isEmpty || port < 1 || port > 65535 || uuid.isEmpty) {
      throw const FormatException('VMess account is missing required fields.');
    }

    return VpnProfile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: data['ps']?.toString().trim().isNotEmpty == true
          ? data['ps'].toString()
          : 'VMess Profile',
      protocol: 'VMess',
      server: server,
      port: port,
      uuid: uuid,
      transport: _transport(data['net']?.toString() ?? 'tcp'),
      security: _security(data['tls']?.toString() ?? 'none'),
      sni: data['sni']?.toString() ?? data['host']?.toString() ?? '',
      alpn: data['alpn']?.toString() ?? '',
      fingerprint: data['fp']?.toString() ?? '',
      networkPath: data['path']?.toString() ?? '',
      encryption: data['scy']?.toString() ?? 'auto',
      originalLink: link,
    );
  }

  static VpnProfile _parseShadowsocks(String link) {
    var address = link.substring('ss://'.length);
    address = address.split('#').first.split('?').first;

    if (!address.contains('@')) {
      address = _decodeBase64(address);
    }

    final at = address.lastIndexOf('@');

    if (at < 0) {
      throw const FormatException('Invalid Shadowsocks link.');
    }

    final credentials = address.substring(0, at);
    final serverAddress = address.substring(at + 1);
    final separator = credentials.indexOf(':');

    if (separator < 1) {
      throw const FormatException('Invalid Shadowsocks credentials.');
    }

    final method = credentials.substring(0, separator);
    final password = credentials.substring(separator + 1);
    final serverUri = Uri.parse('ss://$serverAddress');

    if (serverUri.host.isEmpty || serverUri.port == 0) {
      throw const FormatException('Invalid Shadowsocks server.');
    }

    return VpnProfile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: 'Shadowsocks Profile',
      protocol: 'Shadowsocks',
      server: serverUri.host,
      port: serverUri.port,
      password: password,
      encryption: method,
      originalLink: link,
    );
  }

  static String _decodeBase64(String value) {
    var normalized = value.replaceAll('-', '+').replaceAll('_', '/');

    while (normalized.length % 4 != 0) {
      normalized += '=';
    }

    try {
      return utf8.decode(base64.decode(normalized));
    } catch (_) {
      throw const FormatException('Invalid Base64 account data.');
    }
  }

  static String _transport(String value) {
    switch (value.toLowerCase()) {
      case 'ws':
      case 'websocket':
        return 'WebSocket';
      case 'grpc':
        return 'gRPC';
      case 'httpupgrade':
        return 'HTTPUpgrade';
      case 'xhttp':
        return 'XHTTP';
      default:
        return 'TCP';
    }
  }

  static String _security(String value) {
    switch (value.toLowerCase()) {
      case 'tls':
        return 'TLS';
      case 'reality':
        return 'REALITY';
      default:
        return 'None';
    }
  }
}
