import 'package:audio_steganography/myWidgets.dart';
import 'functionCaller.dart';
import 'package:flutter/material.dart';
import 'myFunctions.dart';
// ignore: must_be_immutable
class DecodeActivity extends StatefulWidget {
  String message="Message will be displayed here";
  String filePath;
  String fileName="Select File";
  String filePickerErrorTextMessage="";
  int enDeKey;
  MyFunctions myFunctions=new MyFunctions();
  FunctionCaller functionCaller= new FunctionCaller();
  @override
  _DecodeActivityState createState() => _DecodeActivityState();
}

class _DecodeActivityState extends State<DecodeActivity> {
  final FocusNode focusNode=new FocusNode();
  final FocusNode focusNodeKey1=new FocusNode();
  final FocusNode focusNodeKey2=new FocusNode();
  final FocusNode focusNodeKey3=new FocusNode();
  final FocusNode focusNodeKey4=new FocusNode();

  @override
  void dispose() {
    // Disposes Focus Node when done
    focusNode.dispose();
    focusNodeKey1.dispose();
    focusNodeKey2.dispose();
    focusNodeKey3.dispose();
    focusNodeKey4.dispose();
    super.dispose();
  }
  dataBringer(String filePath,String errorMessage){
    setState(() {
      widget.filePath=filePath;
      widget.fileName=filePath.split("/").last;
      widget.filePickerErrorTextMessage=errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        title: Text("Decode"),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FilePickerButton(focusNode: focusNode,dataBringer:dataBringer,fileName: widget.fileName,errorMessage: widget.filePickerErrorTextMessage,), //dataBringer will bring back the file path from the child
            Container(
              constraints: BoxConstraints(minHeight: 270, minWidth: 400),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.grey[100],
              ),
              child: Text(widget.message,
                maxLines: 10,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyInputField(keySender:  widget.myFunctions.keyBringer1,focusBringerNode: focusNodeKey1,focusTakerNode: focusNodeKey2),
                    KeyInputField(keySender:  widget.myFunctions.keyBringer2,focusBringerNode: focusNodeKey2,focusTakerNode: focusNodeKey3),
                    KeyInputField(keySender:  widget.myFunctions.keyBringer3,focusBringerNode: focusNodeKey3,focusTakerNode: focusNodeKey4),
                    KeyInputField(keySender:  widget.myFunctions.keyBringer4,focusBringerNode: focusNodeKey4,focusTakerNode: null),
                  ],
                ),
                Text("Enter Secret Code",
                  style: TextStyle(
                    letterSpacing: 4,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Hero(
              tag: "Decode",

              child: EnDeButton(type:"decode",onPressed: () async {
                try {
                  widget.enDeKey=int.parse(widget.myFunctions.keySender());
                  setState(() {});
                }catch(e){
                  final snackBar= SnackBar(content: Text("Please Enter A Valid Numeric Key"));
                  Scaffold.of(context).showSnackBar(snackBar);
                }
                if(widget.fileName=="Select File"){
                  final snackBar= SnackBar(content: Text("Please Select File"));
                  Scaffold.of(context).showSnackBar(snackBar);
                }
                try {
                  widget.message = await widget.functionCaller.decode(filePath:widget.filePath, key: widget.enDeKey);
                  setState(() {});
                }catch(e)
                {print(e);}
                }),
            ),
          ],
        ),
      ),
    );
  }
}
