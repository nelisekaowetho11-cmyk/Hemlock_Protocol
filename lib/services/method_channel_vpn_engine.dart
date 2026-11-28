
import 'dart:async';

import 'package:flutter/services.dart';

import '../models/connection_stats.dart';
import '../models/vpn_profile.dart';
import 'vpn_engine.dart';

class MethodChannelVpnEngine implements VpnEngine {
  static const MethodChannel _methods =
      MethodChannel('com.primenetvpn/vpn');

  static const EventChannel _events =
      EventChannel('com.primenetvpn/vpn_events');

  final StreamController<ConnectionStats> _controller =
      StreamController<ConnectionStats>.broadcast();

  late final StreamSubscription<dynamic> _subscription;

  ConnectionStats _currentStats = const ConnectionStats();

  MethodChannelVpnEngine() {
    _subscription = _events
        .receiveBroadcastStream()
        .listen(_handleEvent, onError: _handleError);
  }

  @override
  Stream<ConnectionStats> get statsStream => _controller.stream;

  @override
  ConnectionStats get currentStats => _currentStats;

  @override
  Future<bool> get isAvailable async {
    try {
      return await _methods.invokeMethod<bool>('isAvailable') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<void> connect(VpnProfile profile) async {
    if (!await isAvailable) {
      throw const VpnEngineException(
        'Native VPN engine is not installed yet.',
      );
    }

    try {
      await _methods.invokeMethod<void>(
        'connect',
        profile.toJson(),
      );
    } on PlatformException catch (error) {
      throw VpnEngineException(
        error.message ?? 'Could not start VPN connection.',
      );
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _methods.invokeMethod<void>('disconnect');
    } on PlatformException catch (error) {
      throw VpnEngineException(
        error.message ?? 'Could not stop VPN connection.',
      );
    }
  }

  void _handleEvent(dynamic event) {
    if (event is! Map) return;

    final data = Map<String, dynamic>.from(event);

    final statusName =
        data['status']?.toString().toLowerCase() ?? 'disconnected';

    final status = VpnConnectionStatus.values.firstWhere(
      (value) => value.name == statusName,
      orElse: () => VpnConnectionStatus.error,
    );

    final stats = ConnectionStats(
      status: status,
      server: data['server']?.toString() ?? '',
      latencyMs: _number(data['latencyMs'], -1),
      uploadBytesPerSecond:
          _number(data['uploadBytesPerSecond']),
      downloadBytesPerSecond:
          _number(data['downloadBytesPerSecond']),
      totalUploadedBytes:
          _number(data['totalUploadedBytes']),
      totalDownloadedBytes:
          _number(data['totalDownloadedBytes']),
      connectedSince: _date(data['connectedSince']),
      errorMessage: data['errorMessage']?.toString(),
    );

    _currentStats = stats;

    if (!_controller.isClosed) {
      _controller.add(stats);
    }
  }

  void _handleError(Object error) {
    if (_controller.isClosed) return;

    _currentStats = _currentStats.copyWith(
      status: VpnConnectionStatus.error,
      errorMessage: error.toString(),
    );

    _controller.add(_currentStats);
  }

  int _number(dynamic value, [int fallback = 0]) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  DateTime? _date(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    return DateTime.tryParse(value.toString());
  }

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    await _controller.close();
  }
}
