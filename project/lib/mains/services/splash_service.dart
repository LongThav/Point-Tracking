import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../mains/utils/logger.dart';
import '../../auths/services/user_local_service.dart';
import '../utils/route/route_name.dart';

class SplashService {
  void checkAuthentication(BuildContext context) async {
    var lists = await UserLocalService().getUser();
    if (kDebugMode) {
      print('access token: ${lists[0].data.access_token.toString()}');
    }

    final getUser = lists[0];
    if (getUser.data.access_token.toString() == 'null' || getUser.data.access_token.toString() == '') {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        // Navigator.pushNamed(context, RouteName.signin);
        Navigator.pushReplacementNamed(context, RouteName.signin);
      });
    } else {
      // create time now
      DateTime now = DateTime.now();
      double nowMilliSeconds = now.millisecondsSinceEpoch.toDouble();

      double expiredTime = double.parse(lists[1]);
      double loginTimeMilliSeconds = double.parse(lists[2]);

      double timeLeft = (nowMilliSeconds - loginTimeMilliSeconds) / 1000;
      if (timeLeft < expiredTime) {
        // print('session login remaining');
        // session login remaining
        String role = getUser.data.role;
        String route = RouteName.checkRole(role);

        // wait for 3 seconds then redirect to dashboard page
        await Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.pushNamed(context, route);
        });
      } else {
        'session login expired'.log();
        // session login expired
        Future.delayed(const Duration(seconds: 3)).then((value) {
          final userPrefs = Provider.of<UserLocalService>(context, listen: false);
          userPrefs.removeUser();
          // redirect to sign in page
          // Navigator.pushNamed(context, RouteName.signin);
          Navigator.pushReplacementNamed(context, RouteName.signin);
        });
      }
    }
  }
}
// Future<UserModel> getUser() => UserLocalService().getUser();
// getUser().then((user) async {
//   if (kDebugMode) {
//     print('access token: ${user.data.access_token.toString()}');
//   }
//   if (user.data.access_token.toString() == 'null' ||
//       user.data.access_token.toString() == '') {
//
//     Future.delayed(const Duration(seconds: 3)).then((value) {
//       Navigator.pushNamed(context, RouteName.signin);
//     });
//   } else {
//     await Future.delayed(const Duration(seconds: 3)).then((value) {
//       var role = user.data.role;
//       var route = RouteName.checkRole(role);
//       Navigator.pushNamed(context, route);
//     });
//   }
// }).onError((error, stackTrace) {
//   // if (kDebugMode) {
//   //   print(error.toString());
//   // }
// });
