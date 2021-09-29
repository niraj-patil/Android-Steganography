import 'package:flutter/material.dart';
import 'Decode_Activity.dart';
import 'Encode_Activity.dart';

import 'myWidgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Audio Steganography"),
          backgroundColor: Colors.grey[800],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: "Encode",
                child: EnDeButton(type:"encode", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EncodeActivity()));
                }),
              ),
              Hero(
                tag: "Decode",
                child: EnDeButton(type:"decode",onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DecodeActivity()));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
