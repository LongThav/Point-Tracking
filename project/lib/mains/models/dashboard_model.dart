class DashboardModel {
  DashboardModel({
    this.code = 0,
    this.message = "no-message",
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.dashboard,
  });

  Dashboard dashboard;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dashboard: Dashboard.fromJson(json["dashboard"]),
      );

  Map<String, dynamic> toJson() => {
        "dashboard": dashboard.toJson(),
      };
}

class Dashboard {
  Dashboard({
    this.dashboardNew = 0,
    this.inService = 0,
    this.confirm = 0,
    this.delivery = 0,
    this.delivered = 0,
  });

  int dashboardNew;
  int inService;
  int confirm;
  int delivery;
  int delivered;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        dashboardNew: json["new"],
        inService: json["in service"],
        confirm: json["confirm"],
        delivery: json["delivery"],
        delivered: json["delivered"],
      );

  Map<String, dynamic> toJson() => {
        "new": dashboardNew,
        "in service": inService,
        "confirm": confirm,
        "delivery": delivery,
        "delivered": delivered,
      };
}
