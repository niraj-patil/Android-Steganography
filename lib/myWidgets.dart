import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//FilePickerButton
import 'package:file_picker/file_picker.dart';
import 'dart:io';                                 //File Class

// ignore: must_be_immutable
class KeyInputField extends StatefulWidget {
  var keySender;
  var errorShower;
  var focusBringerNode=new FocusNode();
  var focusTakerNode=new FocusNode();
  var keyBorderColor;
  var errorMessage;
  KeyInputField({@required keySender, focusBringerNode, focusTakerNode}){
    this.keySender=keySender;
    this.focusBringerNode=focusBringerNode;
    this.focusTakerNode=focusTakerNode;
  }

  @override
  _KeyInputFieldState createState() => _KeyInputFieldState();
}

class _KeyInputFieldState extends State<KeyInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
          constraints: BoxConstraints(minHeight: 100, minWidth: 50, maxHeight:100, maxWidth: 50),
          padding: EdgeInsets.all(0.0),
          child:TextField(
            textAlign:TextAlign.center,
            maxLength: 1,
            focusNode:widget.focusBringerNode,
            keyboardType: TextInputType.number,
            cursorColor:Colors.black,
            style: TextStyle(
              fontSize: 20
            ),
            decoration: InputDecoration(
              fillColor: Colors.grey[100],
              filled: true,
              counter: Offstage(),
              focusedBorder: OutlineInputBorder(
                borderSide:BorderSide(color: Colors.grey[800]),     //Sets Color When Focused
              ),
              border: OutlineInputBorder(
                borderSide:BorderSide(color: Colors.grey[800]),
              ),
            ),
            onChanged:(text){
              widget.keySender(text);
              if(widget.focusTakerNode!=null) {
                  widget.focusTakerNode.requestFocus();
              }
              else
                FocusScope.of(context).unfocus();
              },
          ),
    );
  }
}

// ignore: must_be_immutable
class EnDeButton extends StatefulWidget {
  String labelText;
  var startColor,endColor, onPressed;
  EnDeButton({@required onPressed, String type})
  {
    this.onPressed=onPressed;
    if(type=="encode"){
      this.labelText="Encode";
      this.startColor=0xbe36383d;
      this.endColor=0xf3000000;
    }
    else{
      this.labelText="Decode";
      this.startColor=0xf3000000;
      this.endColor=0xbe36383d;
    }
  }

  @override
  _EnDeButtonState createState() => _EnDeButtonState();
}

class _EnDeButtonState extends State<EnDeButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        widget.onPressed();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(widget.startColor), Color(widget.endColor)],     //[Color(0xbe36383d), Color(0xf3000000)]
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints:
          BoxConstraints(maxWidth: 380.0, minHeight: 75.0),
          alignment: Alignment.center,
          child: Text(
            widget.labelText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FilePickerButton extends StatefulWidget {
 var fileName;
 var focusNode;
 var dataBringer;
 var filePath;
 var errorMessage="";
 final supportedFormats=["wav","mp3","bmp","gif","png"];
  @override
  _FilePickerButtonState createState() => _FilePickerButtonState();
  FilePickerButton({focusNode, dataBringer,fileName,errorMessage}){
    this.fileName=fileName;
    this.focusNode=focusNode;
    this.errorMessage=errorMessage;
    this.dataBringer=dataBringer;                 //https://youtu.be/H5-e6M7SjL8
  }
}
class _FilePickerButtonState extends State<FilePickerButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RaisedButton(onPressed:() async {
          FilePickerResult result = await FilePicker.platform.pickFiles(
            type: FileType.any,
          );
          if(result != null) {
            File fileToBeEncoded =new File(result.files.single.path);
            widget.filePath=fileToBeEncoded.path;
            //TODO:Split at last "." and use continue statement
            if(!widget.supportedFormats.contains(widget.filePath.split(".").last)){
              widget.errorMessage="File Format Not Supported \n Output File Content May Not Be Accessible";
            }
            else{
              widget.errorMessage="";
            }
            //audioFileName=basename(fileToBeEncoded.path);  ...   given by import 'package:path/path.dart';
            widget.dataBringer(widget.filePath,widget.errorMessage);
            fileToBeEncoded=null;                 //free up the space
            widget.focusNode.requestFocus();
          } else {
            // User canceled the picker
          }
        },
          padding: EdgeInsets.all(2.0),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 350.0, minHeight: 75.0),
              alignment: Alignment.center,
              child: Text(widget.fileName,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
          ),
        ),
        Text(
          widget.errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 3,
            color: Colors.red,
          ),
        )
      ],
    );
  }
}
