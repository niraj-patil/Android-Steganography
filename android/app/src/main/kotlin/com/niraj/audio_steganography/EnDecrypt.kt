package com.niraj.audio_steganography

class EnDecrypt {
    companion object{
        fun enDecrypt(messageStreamInt:IntArray,key:Int): IntArray {
            val cipher=RC4.keyGenerator(key,messageStreamInt.size)
            for (i in messageStreamInt.indices){
                messageStreamInt[i]=messageStreamInt[i].xor(cipher[i])
            }
            return messageStreamInt
        }
    }
}