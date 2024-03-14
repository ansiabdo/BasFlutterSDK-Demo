

import 'dart:developer';

import 'UIData.dart';

LOGW(dynamic msg) {
  UIData.DEBUG_LOG ? log(msg.toString()) : null;
  UIData.DEBUG_PRINT ? print(msg) : null;
}