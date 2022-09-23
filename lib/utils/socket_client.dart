import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum SocketStatus { connecting , connected , joined , disconnected , error}

class SocketClient {
  SocketClient._internal();

  static final SocketClient _instance = SocketClient._internal();
  static SocketClient get instance => _instance;

  final StreamController<SocketStatus> _statusController = StreamController.broadcast();

  Stream<SocketStatus> get status => _statusController.stream;

  IO.Socket? _socket;

  void connect(){
    // _socket = IO.io('ws://mmgroup-socket.herokuapp.com/whole1',
    //         IO.OptionBuilder()
    //         .setTransports(['websocket'])  // optional
    //         .build());

    _socket = IO.io('ws://mmgroup-socket.herokuapp.com/whole1',
        IO.OptionBuilder()
            .setTransports(['websocket']).build());

    _socket!.on('connect', (_) {
      print('connect');
      _statusController.sink.add(SocketStatus.connected);
    });

    _socket!.on('connect_error', (_) {
      print(" error $_");
      _statusController.sink.add(SocketStatus.error);
    });

    _socket!.on('disconnect', (_) {
      print(" error $_");
      _statusController.sink.add(SocketStatus.disconnected);
    });

  }

  sendLocation(LatLng position){
    print('pos ${position.toJson()}');
    // if(this._socket != null){
      // this._socket!.emit('on-location', position.toJson());
    // }
  }

  void disconnect(){
    _socket!.disconnect();
  }

}