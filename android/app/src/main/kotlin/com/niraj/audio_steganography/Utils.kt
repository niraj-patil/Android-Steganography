package com.niraj.audio_steganography

import android.os.Environment
import java.io.File

class Utils {
    companion object{

        internal const val REMOVE_LSB:Int= 254
        internal const val EXTRACT_MSB:Int= 128
        internal const val JUST_LSB: Int = 1
        internal const val messageLengthLength: Int=4
        internal const val messageCounter:Int=0
        internal const val messageLengthCounter:Int=0
        internal const val bitCounter:Int =0
        internal val directoryPath=File(Environment.getExternalStorageDirectory(),"Audix")
        internal fun byteToInt(audioFile:ByteArray): IntArray{
            val audioFileInt = IntArray(audioFile.size)
            for (i in audioFile.indices) {
                audioFileInt[i]=audioFile[i].toInt()
            }
            return audioFileInt
        }
        internal fun intToByte(audioFileInt:IntArray): ByteArray {
            val audioFileSize=audioFileInt.size
            val audioFile=ByteArray(audioFileSize)
            for (i in 0 until audioFileSize) {
                audioFile[i]= audioFileInt[i].toByte()
            }
            return audioFile
        }

        fun intToIntArray(messageLength: Int): IntArray {
            val messageLengthInArray =IntArray(4)
            var i=3
            var len=messageLength
            while (i>=0 && len>0){
                messageLengthInArray[i]=len%10
                len/=10
                i--
            }
            return messageLengthInArray
        }
        fun intArrayToInt(messageLengthInArray: IntArray): Int {
            var messageLength=0
            var i=0
            while (i<4){
                messageLength= messageLength * 10 + messageLengthInArray[i]
                i++
            }
            return messageLength
        }
    }
}