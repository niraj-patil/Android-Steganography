package com.niraj.audio_steganography

class Header {
    companion object{
        private const val wav:Int=45                        //44 Bit Header
        private const val mp3:Int=33                        //32 Bit Header
        private const val png:Int=65
        private const val bmp:Int=113
        private const val gif:Int=113
        fun headerLengthGiver(extension:String): Int {
            //Audio
            when (extension) {
                "wav" -> {
                    return wav
                }
                "mp3" -> {
                    return mp3
                }
                //Images
                "png" -> {
                    return png
                }
                "bmp" -> {
                    return bmp
                }
                "gif" -> {
                    return gif
                }
                else -> return headerLengthGiverComplex(extension)
            }
        }
        private fun headerLengthGiverComplex(extension: String):Int{
            when(extension){
                "mp4"->{
                    return 0
                }
                "jpg"->{
                    return 0
                }
            }
            return 0
        }
    }
}