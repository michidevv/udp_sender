import 'package:flutter/material.dart';
import 'dart:io' show RawDatagramSocket, InternetAddress;
// import 'dart:convert' show utf8;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

void main() => runApp(MyApp());

const PORT = 8000;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDP Socket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'UDP Socket Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void sendMessage() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, PORT)
        .then((RawDatagramSocket datagramSocket) {
      // int eventReceivedTimes = 0;
      // datagramSocket.listen((RawSocketEvent event) {
      //   print('Event received - ${++eventReceivedTimes}');
      // });

      datagramSocket.broadcastEnabled = true;
      Clipboard.getData('text/plain').then((ClipboardData text) {
        final textData = text.text;
        print('Text from clipboard ---\n $textData \n ---');
        datagramSocket.send(
            textData.codeUnits, InternetAddress('255.255.255.255'), PORT);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Press the button to send text from a Clipboard',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendMessage,
        tooltip: 'Send',
        child: Icon(Icons.send),
      ),
    );
  }
}
