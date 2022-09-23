import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BackgroundLocation {

  BackgroundLocation._internal();
  static BackgroundLocation _instance = BackgroundLocation._internal();
  static BackgroundLocation get instance => _instance;

  final _methodChannel = MethodChannel("app.meedu/background-location");
  final _eventChannel = EventChannel("app.meedu/background-location-events");

  final StreamController<LatLng> _controller = StreamController.broadcast();
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  StreamSubscription? _geolocatorSubs, _iosSubs;
  bool _running = false;
  Stream<LatLng> get stream => _controller.stream;

  Future<void> start() async {
    if (_running) throw Exception('background location running');
    const _eventChannel = EventChannel("geeks/background-location-events");

    if (!Platform.isIOS) {
      _geolocatorSubs = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) {
          if (position != null) {
            _controller.sink.add(LatLng(position.latitude, position.longitude));
          }
        },
      );
    }
    _methodChannel.invokeMethod('start');

    _running = true;
  }

  Future<void> stop() async {
    await _geolocatorSubs?.cancel();
    _controller.close();
    _running = false;
  }

}