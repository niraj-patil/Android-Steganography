package com.niraj.audio_steganography

import android.util.Log
import java.io.File

class Decode(filePath: String, key: Int) {
    private val JUST_LSB: Int = Utils.JUST_LSB
    private var messageLengthCounter:Int= Utils.messageLengthCounter
    private var messageCounter:Int=Utils.messageCounter
    private var fileCounter:Int=Header.headerLengthGiver(filePath.substringAfterLast("."))
    private var bitCounter:Int=Utils.bitCounter
    private var fileToBeDecoded: ByteArray =File(filePath).readBytes()
    private val fileLength= fileToBeDecoded.size
    private var messageLengthLength=Utils.messageLengthLength
    private val messageLengthInArray:IntArray= IntArray(messageLengthLength)
    private val enDeKey=key


    @ExperimentalStdlibApi
    fun decode():String{
        for (i in 77..88)
            Log.d("Val",fileToBeDecoded[i].toString())
        while (fileCounter<fileLength && messageLengthCounter<messageLengthLength){
            if(fileToBeDecoded[fileCounter]%2!=0)
            {
                messageLengthInArray[messageLengthCounter]=messageLengthInArray[messageLengthCounter].or(JUST_LSB)
            }
            fileCounter++
            if (bitCounter<7){
                messageLengthInArray[messageLengthCounter]=messageLengthInArray[messageLengthCounter].shl(1)
                bitCounter++
            }
            else {
                messageLengthCounter++
                bitCounter=0
            }
        }
        bitCounter=0                                                                                //Resetting Bit Counter
        val messageLength:Int=Utils.intArrayToInt(messageLengthInArray)
        var messageStream:ByteArray= ByteArray(messageLength)
        val messageStreamInt= IntArray(messageLength)

        Log.d("Audio Counter",fileCounter.toString())

        while (fileCounter<fileLength && messageCounter<messageLength) {
            if(fileToBeDecoded[fileCounter]%2!=0)
            {
                messageStreamInt[messageCounter]=messageStreamInt[messageCounter].or(JUST_LSB)
            }
            fileCounter++
            if (bitCounter<7){
                messageStreamInt[messageCounter]=messageStreamInt[messageCounter].shl(1)
                Log.d(messageCounter.toString(),messageStreamInt[messageCounter].toString())
                bitCounter++
            }
            else {
                messageCounter++
                bitCounter=0
            }
        }
        messageStream=Utils.intToByte(EnDecrypt.enDecrypt(messageStreamInt,enDeKey))
        return messageStream.toString(Charsets.UTF_8)
    }
}

/*
Algorithm
____________________________________________________
Separate Header and Data                                //First 50bytes
Divide the Data into Bytes
Select which bytes to Decode using RC4
Store their LSBs into an Array
Convert Array from Binary->ASCII and Give Message
*/
