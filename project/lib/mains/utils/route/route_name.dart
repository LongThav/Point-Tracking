class RouteName {
  static const String splashpage = 'Splash_Screen';
  static const String signin = "Sign_In";
  static const String homepage = "Home_Page";
  static const String pageSale = "Sale";
  static const String pageController = "controller";
  static const String pageDriver = "Driver";
  static const String pageLogistic = "Logistic";
  static const String settingPage = 'Setting';
  static const String viewCustomer = 'view customer';
  static const String logisticPage = 'logistic_page';

  static String checkRole(String roleName) {
    var routeName = '';
    switch (roleName) {
      case "Sales":
      case "Leader":
        routeName = pageSale;
        break;
      case "Logistic":
        routeName = pageLogistic;
        break;
      case "Controller":
        routeName = pageController;
        break;
      case "Driver":
        routeName = pageDriver;
        break;
    }

    return routeName;
  }
}


// Roles: Sales, Logistic, Controller, Driver, Leader