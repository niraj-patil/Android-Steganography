package com.niraj.audio_steganography

class FunCaller {
    @ExperimentalStdlibApi
    fun encode(filePath: String?, message:String?, key: Int?): Int {
        val encodeObj=Encode(filePath!!,message!!,key!!)
        return encodeObj.encode()
    }
    @ExperimentalStdlibApi
    fun decode(filePath: String?, key: Int?): String {
        val decodeObj= Decode(filePath!!, key!!)
        return decodeObj.decode()
    }
}
