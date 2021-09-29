import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FunctionCaller{
  static const platform= const MethodChannel('com.flutter.audioStego/audioStego');
  Future<String> decode({@required String filePath,@required int key}) async {
    Map decodeMap={
      "filePath":filePath,
      "key":key,
    };
    String message= await platform.invokeMethod("decode",decodeMap); //calls decode method from Kotlin
    return message;
  }
  Future<int> encode({@required filePath,@required message,@required key}) async {
    int flag=0;
    Map encodeMap={
      "filePath":filePath,
      "message":message,
      "key":key,
    };
    flag=await platform.invokeMethod("encode",encodeMap);
    return flag;
  }
}