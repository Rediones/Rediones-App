import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart';

export 'package:dio/dio.dart';
import 'dart:developer' show log;
export 'dart:developer' show log;

//const String baseURL = "http://192.168.81.168:4013";
const String baseURL = "https://rediones.onrender.com";

const String imgPrefix = "data:image/jpeg;base64,";
const String vidPrefix = "data:image/mp4;base64,";

final Map<String, List<Function>> _socketManager = {};

Socket? _socket;

const String messageSignal = "on-message";

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseURL,
    receiveTimeout: const Duration(seconds: 120),
    connectTimeout: const Duration(seconds: 120),
    sendTimeout: const Duration(seconds: 120),
  ),
);

Options configuration(String token, {ResponseType? type}) => Options(headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    },
  responseType: type
);

enum Status { failed, success }

class RedionesResponse<T> {
  final String message;
  final T payload;
  final Status status;

  const RedionesResponse({
    required this.message,
    required this.payload,
    required this.status,
  });
}

void init(String userID) {
  _socket = io(
    'ws://king-david-elites.onrender.com',
    //'ws://192.168.43.169:9099',
    OptionBuilder().setTransports(['websocket']).build(),
  );

  _socket?.onConnect((e) {
    log("Connected To WebSocket");
    _socket?.emit("addUser", {"_id" : userID});
  });
  _socket?.onConnectError((e) => log("Socket Connection Error: $e"));
  _socket?.onDisconnect((e) => log('Disconnected From WebSocket'));
  _socket?.onError((e) => log("WebSocket Error: $e"));

  _socketManager[messageSignal] = [];

  _socket?.on(messageSignal, (data) {
    if(data == null) return;
    List<Function> handlers = _socketManager[messageSignal]!;
    for(Function handler in handlers) {
      handler(data);
    }
  });
}

void addHandler(String key, Function handler) => _socketManager[key]?.add(handler);

void removeHandler(String key, Function handler) => _socketManager[key]?.remove(handler);

void emit(String signal, Map<String, dynamic> data) => _socket?.emit(signal, data);

void shutdown() => _socket?.disconnect();