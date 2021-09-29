class MyFunctions{
  String enDeKey1,enDeKey2,enDeKey3,enDeKey4;                                   // _ specifies Private
  int enDeKey;
  keyBringer1(keyPart){
    enDeKey1=keyPart;
  }
  keyBringer2(keyPart){
    enDeKey2=keyPart;
  }
  keyBringer3(keyPart){
    enDeKey3=keyPart;
  }
  keyBringer4(keyPart){
    enDeKey4=keyPart;
  }
  keySender(){
    if(enDeKey1==null || enDeKey2==null || enDeKey3==null || enDeKey4==null)
      return 0000;
    return enDeKey1+enDeKey2+enDeKey3+enDeKey4;
  }
}