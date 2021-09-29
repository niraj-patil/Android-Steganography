package com.niraj.audio_steganography

import android.util.Log

class RC4 {
    companion object{               //Static Objects
        fun keyGenerator(key:Int,messageLength:Int):IntArray{
            val sArray=IntArray(256)                                                           //keyMaker
            val keyStream=Utils.intToIntArray(key)
            val tArray=IntArray(sArray.size)                                                        //Temporary Vector
            val cipher=IntArray(messageLength)

            //Cipher Initialization
            for (i in sArray.indices)
                sArray[i]=i

            //Making the KeyStreamSize==CipherSize by Repeating it
            var i=0
            var j=0
            while (i<tArray.size){
                tArray[i]=keyStream[j]
                i++
                j++
                if (j==keyStream.size)
                    j=0
            }

            //Key Scheduling Algorithm
            //Changing & Rearranging Cipher Depending upon the Key.To make it more Random
            i=0
            j=0
            var temporary=0
            while(i<sArray.size){
                j=(j+sArray[i]+tArray[i])%sArray.size
                temporary=sArray[i]
                sArray[i]=sArray[j]
                sArray[j]=temporary
                i++
            }

            //Pseudo-Random Key Generation Algorithm
                //Making the Cipher==Message Length using keyMaker Array aka. sArray
            i=0
            j=0
            var t=0
            var k=0
            while(k<messageLength){
                i=(i+1)%sArray.size
                j=(j+sArray[i])%sArray.size
                temporary=sArray[i]
                sArray[i]=sArray[j]
                sArray[j]=temporary
                t=(sArray[i]+sArray[j])%sArray.size
                cipher[k]=sArray[t]
                k++
                if(i==sArray.size-1)                                                                //Resetting i in case messageLength>sArray.size
                    i=0
            }
            for(i in cipher.indices)
                Log.d("CIPHER",cipher[i].toString())

            return cipher
        }
    }

}