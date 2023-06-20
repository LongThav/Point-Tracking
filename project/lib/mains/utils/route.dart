import 'package:flutter/material.dart';

import '../../controllers/screens/index_controllers.dart';
import '../../drivers/screens/index_driver.dart';
import '../../logistics/screens/index_logistic.dart';
import '../../mains/screens/setting_page.dart';
import '../../mains/utils/route/route_name.dart';
import '../../sales/screens/dashboard/home_sale_page.dart';
import '../../sales/screens/index_sales.dart';
import '../screens/signin_page.dart';
import '../screens/splash_page.dart';
import '../../logistics/screens/purchase_logistic_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashpage:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case RouteName.signin:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case RouteName.homepage:
        return MaterialPageRoute(builder: (_) => const HomeSalePage());
      case RouteName.settingPage:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case RouteName.pageSale:
        return MaterialPageRoute(builder: (_) => const IndexSales());
      case RouteName.pageDriver:
        return MaterialPageRoute(builder: (_) => const IndexDriver());
      case RouteName.pageController:
        return MaterialPageRoute(builder: (_) => const IndexController());
      case RouteName.pageLogistic:
        return MaterialPageRoute(builder: (_) => const IndexLogistic());
      case RouteName.logisticPage:
        return MaterialPageRoute(builder: (_) => const PurchaseLogisticPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('Route not defined'),
            ),
          );
        });
    }
  }
}
