import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _initConnectivity();
  }

  void _initConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      _updateStatus(result);
    });
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    var result = await _connectivity.checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(ConnectivityResult result) {
    final bool previousStatus = _isOnline;
    _isOnline = result != ConnectivityResult.none;
    if (_isOnline != previousStatus) {
      notifyListeners();
    }
  }
}
