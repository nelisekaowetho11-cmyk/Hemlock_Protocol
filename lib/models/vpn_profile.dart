
class VpnProfile {
  final String id;
  String name;
  String protocol;
  String server;
  int port;
  String username;
  String password;
  String uuid;
  String transport;
  String security;
  String sni;
  String alpn;
  String fingerprint;
  String publicKey;
  String shortId;
  String flow;
  String encryption;
  String networkPath;
  String originalLink;
  bool muxEnabled;

  VpnProfile({
    required this.id,
    required this.name,
    required this.protocol,
    required this.server,
    required this.port,
    this.username = '',
    this.password = '',
    this.uuid = '',
    this.transport = 'TCP',
    this.security = 'None',
    this.sni = '',
    this.alpn = '',
    this.fingerprint = '',
    this.publicKey = '',
    this.shortId = '',
    this.flow = '',
    this.encryption = '',
    this.networkPath = '',
    this.originalLink = '',
    this.muxEnabled = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'protocol': protocol,
      'server': server,
      'port': port,
      'username': username,
      'password': password,
      'uuid': uuid,
      'transport': transport,
      'security': security,
      'sni': sni,
      'alpn': alpn,
      'fingerprint': fingerprint,
      'publicKey': publicKey,
      'shortId': shortId,
      'flow': flow,
      'encryption': encryption,
      'networkPath': networkPath,
      'originalLink': originalLink,
      'muxEnabled': muxEnabled,
    };
  }

  factory VpnProfile.fromJson(Map<String, dynamic> json) {
    return VpnProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unnamed Profile',
      protocol: json['protocol']?.toString() ?? 'VLESS',
      server: json['server']?.toString() ?? '',
      port: int.tryParse(json['port'].toString()) ?? 443,
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      transport: json['transport']?.toString() ?? 'TCP',
      security: json['security']?.toString() ?? 'None',
      sni: json['sni']?.toString() ?? '',
      alpn: json['alpn']?.toString() ?? '',
      fingerprint: json['fingerprint']?.toString() ?? '',
      publicKey: json['publicKey']?.toString() ?? '',
      shortId: json['shortId']?.toString() ?? '',
      flow: json['flow']?.toString() ?? '',
      encryption: json['encryption']?.toString() ?? '',
      networkPath: json['networkPath']?.toString() ?? '',
      originalLink: json['originalLink']?.toString() ?? '',
      muxEnabled: json['muxEnabled'] == true,
    );
  }
}
