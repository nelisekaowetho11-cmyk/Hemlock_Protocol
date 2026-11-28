
import 'dart:async';

import '../models/connection_stats.dart';
import '../models/vpn_profile.dart';

abstract interface class VpnEngine {
  /// Current connection information from the VPN engine.
  Stream<ConnectionStats> get statsStream;

  /// Latest known connection information.
  ConnectionStats get currentStats;

  /// Whether the native VPN engine is available.
  Future<bool> get isAvailable;

  /// Requests Android VPN permission and starts the VPN.
  Future<void> connect(VpnProfile profile);

  /// Stops the active VPN connection.
  Future<void> disconnect();

  /// Releases engine resources.
  Future<void> dispose();
}

class VpnEngineException implements Exception {
  final String message;

  const VpnEngineException(this.message);

  @override
  String toString() => 'VpnEngineException: $message';
}
