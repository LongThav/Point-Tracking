import 'dart:convert';

FormModel formModelFromMap(String str) => FormModel.fromMap(json.decode(str));

String formModelToMap(FormModel data) => json.encode(data.toMap());

class FormModel {
  FormModel({
    this.code = 0,
    this.message = 'no-message',
    required this.data,
  });

  int code;
  String message;
  DetailForm data;

  factory FormModel.fromMap(Map<String, dynamic> json) => FormModel(
    code: json["code"],
    message: json["message"],
    data: DetailForm.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class DetailForm {
  DetailForm({
    this.deliveryMethod = const [],
    this.driver = const [],
  });

  List<Delivery> deliveryMethod;
  List<Delivery> driver;

  factory DetailForm.fromMap(Map<String, dynamic> json) => DetailForm(
    deliveryMethod: List<Delivery>.from(json["delivery_method"].map((x) => Delivery.fromMap(x))),
    driver: List<Delivery>.from(json["driver"].map((x) => Delivery.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "delivery_method": List<dynamic>.from(deliveryMethod.map((x) => x.toMap())),
    "driver": List<dynamic>.from(driver.map((x) => x.toMap())),
  };
}

class Delivery {
  Delivery({
    this.id = 0,
    this.name = 'no-name',
  });

  int id;
  String name;

  factory Delivery.fromMap(Map<String, dynamic> json) => Delivery(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}
