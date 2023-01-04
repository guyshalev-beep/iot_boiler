import 'package:flutter/cupertino.dart';

class WidgetKeysManager{
  static GlobalKey _KeyV1  = GlobalKey<FormState>();
  static GlobalKey _KeyV6  = GlobalKey<FormState>();
  static GlobalKey _KeyV7  = GlobalKey<FormState>();
  static GlobalKey _KeyV8  = GlobalKey<FormState>();
  static GlobalKey _KeyV9 = GlobalKey<FormState>();
  static GlobalKey _KeyV10 = GlobalKey<FormState>();
  static GlobalKey _KeyV11 = GlobalKey<FormState>();
  static GlobalKey _KeyV12 = GlobalKey<FormState>();
  static GlobalKey _KeyV20 = GlobalKey<FormState>();
  static GlobalKey _KeyV21 = GlobalKey<FormState>();
  static GlobalKey _KeyV22 = GlobalKey<FormState>();
  static GlobalKey _KeyV30 = GlobalKey<FormState>();
  static GlobalKey get KeyV1 => _KeyV1;
  static GlobalKey get KeyV7 => _KeyV7;
  static GlobalKey get KeyV8 => _KeyV8;
  static GlobalKey get KeyV6 => _KeyV6;
  static GlobalKey get KeyV9 => _KeyV9;
  static GlobalKey get KeyV10 => _KeyV10;
  static GlobalKey get KeyV20 => _KeyV20;
  static GlobalKey get KeyV11 => _KeyV11;
  static GlobalKey get KeyV12 => _KeyV12;
  static GlobalKey get KeyV21 => _KeyV21;
  static GlobalKey get KeyV22 => _KeyV22;
  static GlobalKey get KeyV30 => _KeyV30;

  static getIDFromGlobalKey(GlobalKey? key){
    //print("about to match ${key} to ${KeyV20}");
    String result = "";
    if (key == WidgetKeysManager.KeyV1) result = "1";
    if (key == WidgetKeysManager.KeyV6) result = "6";
    if (key == WidgetKeysManager.KeyV7) result = "7";
    if (key == WidgetKeysManager.KeyV8) result = "8";
    if (key == WidgetKeysManager.KeyV9) result = "9";
    if (key == WidgetKeysManager.KeyV10) result = "10";
    if (key == WidgetKeysManager.KeyV11) result = "11";
    if (key == WidgetKeysManager.KeyV12) result = "12";
    if (key == WidgetKeysManager.KeyV20) result = "20";
    if (key == WidgetKeysManager.KeyV21) result = "21";
    if (key == WidgetKeysManager.KeyV22) result = "22";
    if (key == WidgetKeysManager.KeyV30) result = "30";
    return result;
  }


}