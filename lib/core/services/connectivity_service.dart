import 'dart:async';
import 'dart:developer' as dev;
import 'package:connectivity_plus/connectivity_plus.dart';

enum AppConnectivityStatus {
  online,
  offline,
}

class ConnectivityService {
  ConnectivityService._() {
    _init();
  }

  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final _statusController = StreamController<AppConnectivityStatus>.broadcast();

  Stream<AppConnectivityStatus> get statusStream => _statusController.stream;

  AppConnectivityStatus _currentStatus = AppConnectivityStatus.online;
  AppConnectivityStatus get currentStatus => _currentStatus;

  Future<void> _init() async {
    // Initial check
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);

    // Listen for changes
    _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // connectivity_plus 6.0+ returns a List. We consider "online" if ANY 
    // interface is available (wifi, mobile, ethernet).
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    final newStatus = isOnline ? AppConnectivityStatus.online : AppConnectivityStatus.offline;

    if (newStatus != _currentStatus) {
      dev.log('Network Transition: $_currentStatus → $newStatus (Results: $results)');
      _currentStatus = newStatus;
      _statusController.add(newStatus);
    }
  }

  Future<bool> checkIsOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }
}
