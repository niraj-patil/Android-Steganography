package com.niraj.audio_steganography



import java.io.File
import android.os.Build

/*
Scoped Storage Implementation: Android 10 and above

import android.content.ContentResolver
import android.content.ContentValues
import android.content.Context
import android.provider.MediaStore
*/

class Encode(private val filePath: String, message: String, private val enDeKey: Int) {

   private val EXTRACT_MSB=Utils.EXTRACT_MSB
   private val REMOVE_LSB=Utils.REMOVE_LSB
   //Counters
   private var messageCounter:Int=Utils.messageCounter
   private var fileCounter:Int=Header.headerLengthGiver(filePath.substringAfterLast("."))
   private var messageLengthCounter:Int=Utils.messageLengthCounter
   private var bitCounter:Int=Utils.bitCounter

   private var fileToBeEncoded: ByteArray =File(filePath).readBytes()
   private var messageStream:ByteArray= message.toByteArray(Charsets.UTF_8)

   //Sizes
   private val messageLength= messageStream.size
   private val fileLength=fileToBeEncoded.size
   private val messageLengthInArray:IntArray=Utils.intToIntArray(messageLength)
   private val messageLengthLength=Utils.messageLengthLength

   //Output Path
   private val directoryPath=Utils.directoryPath

   fun encode(): Int {
      if (fileLength-44<messageLength*8)                                                         //File Data Size(First 44 Byte Header) < Message Length * 8 Bytes required by each Character
         return 2                                                                                  //File Too Small
      if (false)
         return 4
      if (Build.VERSION.SDK_INT< Build.VERSION_CODES.Q) {
         if (!directoryPath.exists())                                                                  //Making Output Directory If It Doesn't Exist
            directoryPath.mkdir()
      }
      //Converting File to Int. To use Stable Bitwise Operators
      val fileInt: IntArray= Utils.byteToInt(fileToBeEncoded)
      val messageStreamInt:IntArray=EnDecrypt.enDecrypt(Utils.byteToInt(messageStream),enDeKey)

      while (fileCounter<fileLength && messageLengthCounter<messageLengthLength) {
            fileInt[fileCounter] = (fileInt[fileCounter].and(REMOVE_LSB))
                    .or((messageLengthInArray[messageLengthCounter].and(EXTRACT_MSB)).shr(7))
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

      bitCounter=0
        while (fileCounter<fileLength && messageCounter < messageLength) {
           if (fileInt[fileCounter]>0) {
              fileInt[fileCounter] = (fileInt[fileCounter].and(Utils.REMOVE_LSB))
                      .or((messageStreamInt[messageCounter].and(EXTRACT_MSB)).shr(7))
           }else {                                                                                   //For Negative Numbers
              fileInt[fileCounter]=fileInt[fileCounter].inv().plus(1)      //Convert to 2s' Compliment
              fileInt[fileCounter] = (fileInt[fileCounter].and(Utils.REMOVE_LSB))
                      .or((messageStreamInt[messageCounter].and(EXTRACT_MSB)).shr(7))
              fileInt[fileCounter]=fileInt[fileCounter].minus(1).inv()     //Convert Back to Basic
           }
           fileCounter++
           if (bitCounter<7){
              messageStreamInt[messageCounter]=messageStreamInt[messageCounter].shl(1)
              bitCounter++
           }
           else {
              messageCounter++
              bitCounter=0
           }
        }
         //enDeKey=RC4.keyGenerator(key)

      //Converting File back to Bytes
      fileToBeEncoded=Utils.intToByte(fileInt)

      if (Build.VERSION.SDK_INT<Build.VERSION_CODES.Q) {
         var enFile = File(directoryPath.absolutePath,
                 filePath.substringAfterLast("/"))
         var i=0
         while (true){
            if (!enFile.exists()) {
               enFile.writeBytes(fileToBeEncoded)
               break
            }else{
               enFile=File(directoryPath.absolutePath,
                       filePath.substringAfterLast("/").substringBeforeLast(".")+
                               "("+i.toString()+")."+
                               filePath.substringAfterLast("."))
               i++
            }
         }
      }else {
         print("")
         /*
         val resolver:ContentResolver= Context.contentResolver
         val audioCollection=MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
         val encodedFile=ContentValues().apply {
            put(MediaStore.Audio.Media.DISPLAY_NAME,"encodedName.wav") }
         val encodedSongURI=resolver.insert(audioCollection,encodedFile)
          */
      }

      return 1
   }
}

/*
Algorithm
____________________________________________________
Separate Header and Data
Divide the Data into Bytes
Select which bytes to Encode using RC4
Hide the Message in LSB of Selected Data Bytes
Attach the Header Back
 */

/*
Direct Access to External Storage was limited from Android 10(Q)
Shared storage like Music,Gallery,etc are only accessible along with the application's own data
 */