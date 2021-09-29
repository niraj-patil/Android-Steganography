package com.niraj.audio_steganography

//Connection Helpers
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() { //https://flutter.dev/docs/development/platform-integration/platform-channels
    private val CHANNEL: String ="com.flutter.audioStego/audioStego"
    private val funCaller=FunCaller()
    var filePath:String?=null
    var key:Int=0
    var message:String?=null
    var successFlag:Int=0
    @ExperimentalStdlibApi
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->                                             // Note: this method is invoked on the main thread.
            var arguments=call.arguments<Map<String,Any>>()
            if(call.method=="encode"){
                filePath=arguments["filePath"] as String
                key= arguments["key"] as Int
                message=arguments["message"] as String
                successFlag=funCaller.encode(filePath=filePath,message = message,key = key)
                result.success(successFlag)
            }else if (call.method=="decode"){
                filePath=arguments["filePath"] as String
                key= arguments["key"] as Int
                message = funCaller.decode(filePath=filePath, key = key)
                result.success(message)
            }
        }
    }
}
