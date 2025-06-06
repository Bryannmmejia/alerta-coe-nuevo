import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as client;
import '../helper/globalState.dart';
import 'package:eventify/eventify.dart';

class SocketClient {
  static client.Socket? _socket;
  static EventEmitter? _eventEmitter;

  SocketClient() {
    _initialize();
  }

  static void _initialize() {
    if (_socket != null) return;

    _socket = client.io(
      GlobalState.getInstance().chatUrl,
      <String, dynamic>{
        'transports': ['websocket']
      },
    );
    _eventEmitter ??= EventEmitter();

    _socket!.on('connect', (_) {
      print('Connected');
      var _join = {
        "data": GlobalState.getInstance().logonResult.toJson(),
        "event": "connect",
        "id": DateTime.now().toString(),
      };
      var _obj = jsonEncode(_join);
      _socket!.emit("joinMe", _obj);
    });
    _socket!.connect();
    _socket!.on('connect_error', (ev) {
      print("connect_error");
      _eventEmitter?.emit("disconnect");
    });
    _socket!.on('connect_timeout', (ev) {
      print("connect_timeout");
    });
    _socket!.on('disconnect', (ev) {
      print("disconnect");
    });
    _socket!.on('error', (ev) {
      print("error connection");
    });
    _socket!.on('reconnect_attempt', (ev) {
      print("reconnect_attempt");
    });
    _socket!.on('reconnect_failed', (ev) {
      print("reconnect_failed");
    });
  }

  static void emit(String event, {dynamic arguments}) {
    _initialize();
    _socket?.emit(event, arguments ?? {});
  }

  static void subscribe(String event, void Function(dynamic) function) {
    _initialize();
    _socket?.on(event, function);
  }

  static void unsubscribe(String event, void Function(dynamic) function) {
    _initialize();
    _socket?.off(event, function);
  }

  static EventEmitter getEmitter() {
    _initialize();
    return _eventEmitter!;
  }
}
