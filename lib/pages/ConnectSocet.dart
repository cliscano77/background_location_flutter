import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';

class ConnectSocket extends StatefulWidget {
  const ConnectSocket({Key? key}) : super(key: key);

  @override
  State<ConnectSocket> createState() => _ConnectSocketState();
}

class _ConnectSocketState extends State<ConnectSocket> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final channel = IOWebSocketChannel.connect('ws://mmgroup-socket.herokuapp.com/whole1/');
    channel.stream.listen((message) {
      print('entro');
      print(message);
      print(status.goingAway);
   //   channel.sink.add('received!');
  //    channel.sink.close(status.goingAway);
    });
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
    );
  }
}
