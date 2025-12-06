import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionService {
  // Singleton
  static final ConnectionService _instance = ConnectionService._internal();
  factory ConnectionService() => _instance;
  ConnectionService._internal() {
    _init();
  }

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  void _init() {
    // Listen to connectivity changes (wifi/mobile)
    Connectivity().onConnectivityChanged.listen((result) async {
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      _connectionController.add(hasInternet);
    });

    // Initial check
    InternetConnectionChecker().hasConnection.then((status) {
      _connectionController.add(status);
    });
  }

  void dispose() {
    _connectionController.close();
  }
}
