
import 'dart:async';

import '../models/connection_stats.dart';
import '../models/vpn_profile.dart';
import 'vpn_engine.dart';

class ConnectionController {
  final VpnEngine engine;

  ConnectionStats _stats = const ConnectionStats();

  StreamSubscription<ConnectionStats>? _subscription;

  final StreamController<ConnectionStats> _controller =
      StreamController<ConnectionStats>.broadcast();

  bool _busy = false;
  bool _disposed = false;

  ConnectionController(this.engine) {
    _subscription = engine.statsStream.listen(
      _updateStats,
      onError: _handleError,
    );

    _updateStats(engine.currentStats);
  }

  ConnectionStats get currentStats => _stats;

  Stream<ConnectionStats> get statsStream => _controller.stream;

  bool get isBusy => _busy;

  bool get isConnected => _stats.isConnected;

  void _updateStats(ConnectionStats stats) {
    if (_disposed) return;

    _stats = stats;

    if (!_controller.isClosed) {
      _controller.add(stats);
    }
  }

  void _handleError(Object error) {
    if (_disposed) return;

    _updateStats(
      _stats.copyWith(
        status: VpnConnectionStatus.error,
        errorMessage: error.toString(),
      ),
    );
  }

  Future<void> connect(VpnProfile profile) async {
    if (_disposed) {
      throw const VpnEngineException(
        'Connection controller is closed.',
      );
    }

    if (_busy || isConnected) return;

    _busy = true;

    _updateStats(
      _stats.copyWith(
        status: VpnConnectionStatus.connecting,
        server: profile.server,
        clearError: true,
      ),
    );

    try {
      await engine.connect(profile);
    } catch (error) {
      _updateStats(
        _stats.copyWith(
          status: VpnConnectionStatus.error,
          errorMessage: error.toString(),
        ),
      );

      rethrow;
    } finally {
      _busy = false;
    }
  }

  Future<void> disconnect() async {
    if (_disposed || _busy) return;

    if (_stats.status == VpnConnectionStatus.disconnected) {
      return;
    }

    _busy = true;

    _updateStats(
      _stats.copyWith(
        status: VpnConnectionStatus.disconnecting,
      ),
    );

    try {
      await engine.disconnect();
    } catch (error) {
      _updateStats(
        _stats.copyWith(
          status: VpnConnectionStatus.error,
          errorMessage: error.toString(),
        ),
      );

      rethrow;
    } finally {
      _busy = false;
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;

    _disposed = true;

    await _subscription?.cancel();
    await engine.dispose();
    await _controller.close();
  }
}
