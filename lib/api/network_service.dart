import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';


class NetworkConnection
{
  static final _instance = NetworkConnection();
  static NetworkConnection get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream<dynamic> get myStream => _controller.stream;

  void initialize() async
  {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((res) {});
  }

  void _checkStatus(ConnectivityResult result) async
  {
    bool isOnline = false;
    try
        {
          final result = await InternetAddress.lookup("google.com");
          isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        }
        on SocketException catch(_)
    {
      isOnline = false;
    }

    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}