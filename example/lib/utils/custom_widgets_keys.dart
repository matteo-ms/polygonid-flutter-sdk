import 'package:flutter/material.dart';

class CustomWidgetsKeys {
  CustomWidgetsKeys._();

  /// HOME SCREEN
  static const Key homeScreenButtonCreateIdentity =
      Key("homeButtonCreateIdentity");
  static const Key homeScreenButtonRemoveIdentity =
      Key("homeButtonRemoveIdentity");
  static const Key homeScreenFeatureCardAuthenticate =
      Key("homeFeatureCardAuthenticate");

  /// AUTH SCREEN
  static const Key authScreenButtonNextAction =
      Key("authScreenButtonNextAction");
  static const Key authScreenButtonConnect = Key("authScreenButtonConnect");

  /// SIGN SCREEN
  static const Key signScreenButtonSignMessage =
      Key("signScreenButtonSignMessage");
  static const Key signWidget = Key("signWidget");

  /// CLAIMS SCREEN
  static const Key claimsScreenButtonConnect =
      Key("claimsScreenButtonAddClaim");
}
