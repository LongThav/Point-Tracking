// To parse this JSON data, do
//
//     final poGroup = poGroupFromJson(jsonString);

import 'dart:convert';

PoGroup poGroupFromJson(String str) => PoGroup.fromJson(json.decode(str));

String poGroupToJson(PoGroup data) => json.encode(data.toJson());

class PoGroup {
  PoGroup({
    this.code = 0,
    this.message = "no-message",
    this.data = const [],
  });

  int code;
  String message;
  List<Group> data;

  factory PoGroup.fromJson(Map<String, dynamic> json) => PoGroup(
        code: json["code"],
        message: json["message"],
        data: List<Group>.from(json["data"].map((x) => Group.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Group {
  Group({
    this.id = 0,
    this.street = "no-street",
    this.pos = const [],
  });

  int id;
  String street;
  List<Po> pos;

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json["id"],
      street: json["street"],
      pos: List<Po>.from(json["pos"].map((x) => Po.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "street": street,
        "pos": List<dynamic>.from(pos.map((x) => x.toJson())),
      };
}

class Po {
  Po({
    this.id = 0,
    this.poNumber = "no-poNumber",
    this.poStatus = "no-poStatus",
    this.createdDate = "no-createdDate",
    required this.poTo,
    required this.poBy,
    required this.poDeliverAddress,
    required this.customer,
    this.deliveryMethod,
    required this.paymentMethod,
    this.driver = "no-driver",
    this.notes = "no-notes",
    this.total = 0,
    this.selected = false,
  });

  bool selected;
  int id;
  String poNumber;
  String poStatus;
  String createdDate;
  PoByClass poTo;
  PoByClass poBy;
  PoDeliverAddress? poDeliverAddress;
  Customer customer;
  DeliveryMethod? deliveryMethod;
  DeliveryMethod paymentMethod;
  String? driver;
  String? notes;
  int total;

  factory Po.fromJson(Map<String, dynamic> json) {
    return Po(
      id: json["id"],
      poNumber: json["po_number"],
      poStatus: json["po_status"],
      createdDate: json["created_date"],
      poTo: PoByClass.fromJson(json["po_to"]),
      poBy: PoByClass.fromJson(json["po_by"]),
      poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromJson(json["po_deliver_address"]),
      customer: Customer.fromJson(json["customer"]),
      deliveryMethod: json["delivery_method"] == null ? null : DeliveryMethod.fromJson(json["delivery_method"]),
      paymentMethod: DeliveryMethod.fromJson(json["payment_method"]),
      driver: json["driver"],
      notes: json["notes"],
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "po_number": poNumber,
        "po_status": poStatus,
        "created_date": createdDate,
        "po_to": poTo.toJson(),
        "po_by": poBy.toJson(),
        "po_deliver_address": poDeliverAddress?.toJson(),
        "customer": customer.toJson(),
        "delivery_method": deliveryMethod?.toJson(),
        "payment_method": paymentMethod.toJson(),
        "driver": driver,
        "notes": notes,
        "total": total,
      };
}

class Customer {
  Customer({
    this.id = 0,
    this.companyNameKh = "no-companyNameKh",
    this.companyNameEn = "no-companyNameEn",
  });

  int id;
  String companyNameKh;
  String companyNameEn;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        companyNameKh: json["company_name_kh"],
        companyNameEn: json["company_name_en"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name_kh": companyNameKh,
        "company_name_en": companyNameEn,
      };
}

class DeliveryMethod {
  DeliveryMethod({
    this.id = 0,
    this.name = "no-name",
  });

  int id;
  String name;

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) => DeliveryMethod(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class PoByClass {
  PoByClass({
    this.id = 0,
    this.contactName = "no-contactName",
    this.idCard = "no-idCard",
    this.contactPhone1 = "no-contactPhone1",
    this.contactPhone2 = "no-contactPhone2",
    this.email = "no-email",
    required this.position,
    this.isMain = 0,
  });

  int id;
  String contactName;
  String? idCard;
  String contactPhone1;
  String? contactPhone2;
  String? email;
  DeliveryMethod? position;
  int isMain;

  factory PoByClass.fromJson(Map<String, dynamic> json) => PoByClass(
        id: json["id"],
        contactName: json["contact_name"],
        idCard: json["id_card"],
        contactPhone1: json["contact_phone1"],
        contactPhone2: json["contact_phone2"],
        email: json["email"],
        position: json["position"] == null ? null : DeliveryMethod.fromJson(json["position"]),
        isMain: json["is_main"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact_name": contactName,
        "id_card": idCard,
        "contact_phone1": contactPhone1,
        "contact_phone2": contactPhone2,
        "email": email,
        "position": position?.toJson(),
        "is_main": isMain,
      };
}

class PoDeliverAddress {
  PoDeliverAddress({
    this.id = 0,
    this.homeAddress = "no-homeAddress",
    this.street = "no-street",
    required this.sangkat,
    required this.khan,
    required this.province,
    this.log = "no-log",
    this.lat = "no-lat",
    this.isMain = 0,
    this.type = "no-type",
  });

  int id;
  String homeAddress;
  String street;
  DeliveryMethod sangkat;
  DeliveryMethod khan;
  DeliveryMethod province;
  String log;
  String lat;
  int isMain;
  String type;

  factory PoDeliverAddress.fromJson(Map<String, dynamic> json) => PoDeliverAddress(
        id: json["id"],
        homeAddress: json["home_address"] ?? "",
        street: json["street"] ?? "",
        sangkat: DeliveryMethod.fromJson(json["sangkat"]),
        khan: DeliveryMethod.fromJson(json["khan"]),
        province: DeliveryMethod.fromJson(json["province"]),
        log: json["log"],
        lat: json["lat"],
        isMain: json["is_main"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "home_address": homeAddress,
        "street": street,
        "sangkat": sangkat.toJson(),
        "khan": khan.toJson(),
        "province": province.toJson(),
        "log": log,
        "lat": lat,
        "is_main": isMain,
        "type": type,
      };
}

class Progress {
  Progress({
    required this.progressNew,
    required this.inService,
    required this.confirm,
    this.control = "no-control",
    this.delivered = "no-delivered",
  });

  Confirm progressNew;
  Confirm? inService;
  Confirm confirm;
  String? control;
  String? delivered;

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
        progressNew: Confirm.fromJson(json["new"]),
        inService: json["in_service"] == null ? null : Confirm.fromJson(json["in_service"]),
        confirm: Confirm.fromJson(json["confirm"]),
        control: json["control"],
        delivered: json["delivered"],
      );

  Map<String, dynamic> toJson() => {
        "new": progressNew.toJson(),
        "in_service": inService?.toJson(),
        "confirm": confirm.toJson(),
        "control": control,
        "delivered": delivered,
      };
}

class Confirm {
  Confirm({
    this.status = "no-status",
    this.date = "no-date",
    this.by = "no-by",
  });

  String status;
  String date;
  String by;

  factory Confirm.fromJson(Map<String, dynamic> json) => Confirm(
        status: json["status"],
        date: json["date"],
        by: json["by"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "date": date,
        "by": by,
      };
}
