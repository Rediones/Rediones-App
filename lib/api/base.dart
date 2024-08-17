import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart';

export 'package:dio/dio.dart';
import 'dart:developer' show log;
export 'dart:developer' show log;

const String baseURL = "http://192.168.0.58:4013";
// const String baseURL = "https://rediones.onrender.com";

const String imgPrefix = "data:image/jpeg;base64,";
const String vidPrefix = "data:image/mp4;base64,";

final Map<String, List<Function>> _socketManager = {};

Socket? _socket;

const String sendMessageSignal = "sendMessage";
const String receiveMessageSignal = "receiveMessage";
const String newPostSignal = 'newPost';
const String newStorySignal = 'newStory';
const String notificationSignal = 'notification';

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

String dioErrorResponse(DioException e) {
  if (e.type == DioExceptionType.connectionError) {
    return "A connection error occurred. Please try again later.";
  } else if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return "The connection timed out. Please try again later.";
  } else {
    return "${e.response!.data["message"]!}";
  }
}


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

void initSocket(String userID) {
  _socket = io(
    // 'ws://rediones.onrender.com',
    'ws://192.168.0.58:4013',
    OptionBuilder().setTransports(['websocket']).build(),
  );

  _socket?.onConnect((e) {
    log("Connected To WebSocket");
    emit("identify", userID);
  });

  _socket?.onConnectError((e) => log("Socket Connection Error: $e"));
  _socket?.onDisconnect((e) => log('Disconnected From WebSocket'));
  _socket?.onError((e) => log("WebSocket Error: $e"));

  setupSignalHandlers(newPostSignal);
  setupSignalHandlers(newStorySignal);
  setupSignalHandlers(notificationSignal);
  setupSignalHandlers(receiveMessageSignal);
}

void setupSignalHandlers(String signal) {
  _socketManager[signal] = [];
  _socket?.on(signal, (data) {
    if(data == null) return;
    List<Function> handlers = _socketManager[signal]!;
    for(Function handler in handlers) {
      handler(data);
    }
  });
}

void addHandler(String key, Function handler) => _socketManager[key]?.add(handler);

void removeHandler(String key, Function handler) => _socketManager[key]?.remove(handler);

void emit(String signal, dynamic data) => _socket?.emit(signal, data);

void shutdown() => _socket?.disconnect();