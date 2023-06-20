import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../logistics/service/po_service.dart';
import '../../sales/service/purchase_order_service.dart';
import '../../controllers/service/po_controller_service.dart';
import '../../drivers/service/purchase_order_service.dart';
import '../../mains/services/profile_service.dart';
import '../../auths/services/auth_service.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/services/dashboard_serivce.dart';
import '../../mains/utils/route.dart';
import '../../mains/utils/route/route_name.dart';
import '../../sales/service/customer_service.dart';
import '../../sales/service/product_item_service.dart';
import '../../sales/service/pocart_service.dart';
import '../../sales/service/location_service.dart';
// import 'logistics/service/helper_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserLocalService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ProfileService()),
        ChangeNotifierProvider(create: (context) => ProductItemService()),
        ChangeNotifierProvider(create: (context) => DashboardService()),
        ChangeNotifierProvider(create: (context) => CustomerService()),
        ChangeNotifierProvider(create: (context) => POCartService()),
        ChangeNotifierProvider(create: (context) => LocationService()),
        ChangeNotifierProvider(create: (context) => PurchaseOrderDriverService()),
        ChangeNotifierProvider(create: (context) => PoControllerService()),
        ChangeNotifierProvider(create: (context) => PoSaleService()),
        ChangeNotifierProvider(create: (context) => PurchaseServiceLogistic()),
        // ChangeNotifierProvider(create: (context) => DBHelperLogisticService()),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RouteName.splashpage,
          onGenerateRoute: Routes.generateRoute,
        );
      }),
    );
  }
}
