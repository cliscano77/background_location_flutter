import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onbackground_location/native/background_location.dart';
import 'package:onbackground_location/pages/widget/nickname_form_widget.dart';
import 'package:onbackground_location/utils/socket_client.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? errorMessage;
  String? longitude;
  String? latitude;


  Future getCurrentPosition() async{
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    longitude = currentPosition.longitude.toString();
    latitude = currentPosition.latitude.toString();

    print('lat $latitude , lon $longitude');
  }

  Future statusPermiso() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.whileInUse){
      await getCurrentPosition();

      BackgroundLocation.instance.start();
      BackgroundLocation.instance.stream.listen((LatLng position) {
          SocketClient.instance.sendLocation(position);
      });
    }
  }

  Future getStatusPermission() async {
    // Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      errorMessage = 'Permission not given';
      await Geolocator.requestPermission();
      await statusPermiso();
    } else {
      errorMessage = 'Permission granted';
      await getCurrentPosition();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    //SocketClient.instance.connect();

    // WidgetsBinding.instance?.addPostFrameCallback((_){
    //   getStatusPermission();
    // });
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    await BackgroundLocation.instance.stop();
    SocketClient.instance.disconnect();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      // body: StreamBuilder<SocketStatus>(
      //   builder: (_ , snapshot){
      //     if(snapshot.hasData){
      //       if(snapshot.data == SocketStatus.connecting){
      //         return const Center(child: CircularProgressIndicator());
      //       }else if(snapshot.data == SocketStatus.connected){
      //         return const NickNameFormWidget();
      //       }else {
      //         return const Center(child: Text("Disconnected"));
      //       }
      //     }
      //
      //     return const Center(child: Text("Error"));
      //   },
      //   initialData: SocketStatus.connecting,
      //   stream: SocketClient.instance.status,
      // ),
    );
  }
}