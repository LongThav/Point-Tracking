import 'package:flutter/material.dart';

/// Common Function

/// getHeaders
Map<String, String> getHeaders(String token) {
  Map<String, String> header = {};
  header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  return header;
}

/// delayed
Future<void> delayed({required int seconds, VoidCallback? onDelayedAction}) async {
  if (onDelayedAction != null) {
    return await Future.delayed(Duration(seconds: seconds), onDelayedAction);
  } else {
    return await Future.delayed(Duration(seconds: seconds), () {});
  }
}

/// alertMsg
Future<void> alertMsg({
  required BuildContext context,
  required String msg,
  int seconds = 0,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  await delayed(seconds: seconds);
}

/// on update success
Future<void> onUpdateSuccess({required BuildContext context, VoidCallback? callbackAction, bool? secondPop}) async {
  await Navigator.maybePop(context);
  if (secondPop == true) {
    await Navigator.maybePop(context);
  }
  if (callbackAction != null) {
    callbackAction();
  }
}
