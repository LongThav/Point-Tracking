import '../../controllers/screens/home_controller_page.dart';
import '../../controllers/screens/purchase_controller_orders_page.dart';
import '../../drivers/screens/home_page.dart';
import '../../drivers/screens/purchase_page.dart';
import '../../logistics/screens/home_logistic_page.dart';
import '../../logistics/screens/purchase_logistic_page.dart';
import '../../sales/screens/dashboard/home_sale_page.dart';
import '../../sales/screens/product/product_page.dart';
import '../../sales/screens/customer/customer_page.dart';
import '../../sales/screens/purchase_orders/sale_page.dart';
import '../screens/setting_page.dart';

List salePages = [
  const HomeSalePage(),
  const ProductPage(),
  const SalePage(),
  const CustomerPage(),
  const SettingsPage(),
];

List controllerPages = [
  const HomeControllerPage(),
  const PurchaseOrderControllerPage(),
  const SettingsPage(),
];

List logisticPages = [
  const HomeLogisticPage(),
  const PurchaseLogisticPage(),
  const SettingsPage(),
];

List driverPages = [
  const HomeDriverPage(),
  const PurchaseDriverPage(),
  const SettingsPage(),
];
