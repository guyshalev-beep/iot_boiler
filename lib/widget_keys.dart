import 'package:flutter/cupertino.dart';

class WidgetKeysManager{
  static GlobalKey _KeyV1  = GlobalKey<FormState>();
  static GlobalKey _KeyV10 = GlobalKey<FormState>();
  static GlobalKey _KeyV11 = GlobalKey<FormState>();
  static GlobalKey _KeyV20 = GlobalKey<FormState>();
  static GlobalKey _KeyV21 = GlobalKey<FormState>();
  static GlobalKey _KeyV30 = GlobalKey<FormState>();
  static GlobalKey get KeyV1 => _KeyV1;
  static GlobalKey get KeyV10 => _KeyV10;
  static GlobalKey get KeyV20 => _KeyV20;
  static GlobalKey get KeyV11 => _KeyV11;
  static GlobalKey get KeyV21 => _KeyV21;
  static GlobalKey get KeyV30 => _KeyV30;

  static getIDFromGlobalKey(GlobalKey? key){
    //print("about to match ${key} to ${KeyV20}");
    String result = "";
    if (key == WidgetKeysManager.KeyV1) result = "1";
    if (key == WidgetKeysManager.KeyV10) result = "10";
    if (key == WidgetKeysManager.KeyV11) result = "11";
    if (key == WidgetKeysManager.KeyV20) result = "20";
    if (key == WidgetKeysManager.KeyV21) result = "21";
    if (key == WidgetKeysManager.KeyV30) result = "30";
    return result;
  }


}