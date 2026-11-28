
enum VpnConnectionStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error,
}

class ConnectionStats {
  final VpnConnectionStatus status;
  final String server;
  final int latencyMs;
  final int uploadBytesPerSecond;
  final int downloadBytesPerSecond;
  final int totalUploadedBytes;
  final int totalDownloadedBytes;
  final DateTime? connectedSince;
  final String? errorMessage;

  const ConnectionStats({
    this.status = VpnConnectionStatus.disconnected,
    this.server = '',
    this.latencyMs = -1,
    this.uploadBytesPerSecond = 0,
    this.downloadBytesPerSecond = 0,
    this.totalUploadedBytes = 0,
    this.totalDownloadedBytes = 0,
    this.connectedSince,
    this.errorMessage,
  });

  int get totalTransferredBytes =>
      totalUploadedBytes + totalDownloadedBytes;

  bool get isConnected =>
      status == VpnConnectionStatus.connected;

  String get statusLabel {
    switch (status) {
      case VpnConnectionStatus.disconnected:
        return 'DISCONNECTED';
      case VpnConnectionStatus.connecting:
        return 'CONNECTING';
      case VpnConnectionStatus.connected:
        return 'CONNECTED';
      case VpnConnectionStatus.disconnecting:
        return 'DISCONNECTING';
      case VpnConnectionStatus.error:
        return 'ERROR';
    }
  }

  String formatSpeed(int bytesPerSecond) {
    if (bytesPerSecond < 1024) {
      return '$bytesPerSecond B/s';
    }

    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    }

    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(2)} MB/s';
  }

  String formatDataUsage(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }

    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  ConnectionStats copyWith({
    VpnConnectionStatus? status,
    String? server,
    int? latencyMs,
    int? uploadBytesPerSecond,
    int? downloadBytesPerSecond,
    int? totalUploadedBytes,
    int? totalDownloadedBytes,
    DateTime? connectedSince,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ConnectionStats(
      status: status ?? this.status,
      server: server ?? this.server,
      latencyMs: latencyMs ?? this.latencyMs,
      uploadBytesPerSecond:
          uploadBytesPerSecond ?? this.uploadBytesPerSecond,
      downloadBytesPerSecond:
          downloadBytesPerSecond ?? this.downloadBytesPerSecond,
      totalUploadedBytes:
          totalUploadedBytes ?? this.totalUploadedBytes,
      totalDownloadedBytes:
          totalDownloadedBytes ?? this.totalDownloadedBytes,
      connectedSince: connectedSince ?? this.connectedSince,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
