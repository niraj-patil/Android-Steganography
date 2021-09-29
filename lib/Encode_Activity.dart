import 'package:audio_steganography/functionCaller.dart';
import 'package:audio_steganography/myFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_steganography/myWidgets.dart';

import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class EncodeActivity extends StatefulWidget {
  String filePath;
  String fileName="Select File";
  String filePickerErrorTextMessage="";
  FunctionCaller functionCaller=new FunctionCaller();
  int enDeKey;
  int successFlag=0;
  bool buttonFlag=true;
  MyFunctions myFunctions=new MyFunctions();
  String createdMessage="File Created At /Audix/";
  
  @override
  _EncodeActivityState createState() => _EncodeActivityState();
}
class _EncodeActivityState extends State<EncodeActivity> {
  final FocusNode focusNodeTextBox=new FocusNode();
  final FocusNode focusNodeKey1=new FocusNode();
  final FocusNode focusNodeKey2=new FocusNode();
  final FocusNode focusNodeKey3=new FocusNode();
  final FocusNode focusNodeKey4=new FocusNode();
  final TextEditingController messageBoxController= TextEditingController();
  @override
  void dispose() {
    // Disposes Focus Node and Controller when done
    focusNodeTextBox.dispose();
    focusNodeKey1.dispose();
    focusNodeKey2.dispose();
    focusNodeKey3.dispose();
    focusNodeKey4.dispose();
    messageBoxController.dispose();
    super.dispose();
  }
  filePickerDataBringer(String audioFilePath, String errorMessage){
    setState(() {
      widget.filePath=audioFilePath;
      widget.fileName=audioFilePath.split("/").last;
      widget.filePickerErrorTextMessage=errorMessage;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder:(context)=>Scaffold(
        backgroundColor:Colors.white,
        appBar: AppBar(
          title: Text("Encode"),
          backgroundColor: Colors.grey[800],
        ),
        body: Builder(
          builder:(context)=>Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FilePickerButton(focusNode:focusNodeTextBox,dataBringer: filePickerDataBringer,fileName:widget.fileName,errorMessage: widget.filePickerErrorTextMessage,),
                Container(
                  width: 400,
                  child: TextField(//https://material.io/components/text-fields#usage
                    maxLength: 256,
                    maxLines: 10,
                    textAlign: TextAlign.justify,
                    autocorrect: true,
                    focusNode: focusNodeTextBox,
                    controller: messageBoxController,
                    decoration: InputDecoration(
                      hintText: "Don't Worry! I'll Hide it Well",
                      labelText: "Enter Your Message Here",
                      fillColor: Colors.grey[100],
                      filled: true,
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(
                        fontSize: 27,
                        color: Colors.grey[800],
                        letterSpacing: 2,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:BorderSide(color: Colors.grey[800]),     //Sets Color When Focused
                      ),
                      border: OutlineInputBorder(
                        borderSide:BorderSide(color: Colors.grey[200]),
                      ),
                    ),
                    cursorColor: Colors.black,
                    onEditingComplete: (){
                      focusNodeKey1.requestFocus();
                    },
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
                  tag: "Encode",
                  child: EnDeButton(type:"encode",onPressed:() async {
                    try {
                      widget.enDeKey=int.parse(widget.myFunctions.keySender());
                    }catch(e){
                      widget.buttonFlag==false;
                      final snackBar= SnackBar(content: Text("Please Enter A Valid Numeric Key"));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                    if(messageBoxController.text==null || messageBoxController.text==""){
                      widget.buttonFlag==false;
                      final snackBar= SnackBar(content: Text("Please Enter Message"));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                    if(widget.fileName=="Select File"){
                      widget.buttonFlag==false;
                      final snackBar= SnackBar(content: Text("Please Select File"));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                    if(widget.buttonFlag==true) {
                      try {
                        widget.successFlag = await widget.functionCaller.encode(
                            filePath: widget.filePath,
                            message: messageBoxController.text,
                            key: widget.enDeKey);
                      } catch (e) {
                        print(e);
                      }
                      if (widget.successFlag == 1) {
                        final snackBar = SnackBar(
                            content: Text(widget.createdMessage));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                      else if (widget.successFlag == 2) {
                        final snackBar = SnackBar(
                            content: Text("Please Select a Larger File"));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    }
                  },),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
