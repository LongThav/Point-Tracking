// class PurchaseOrderModelDriver {
//   PurchaseOrderModelDriver({
//     this.code = 0,
//     this.message = "no-message",
//     this.data = const [],
//   });
//
//   int code;
//   String message;
//   List<PurchasOrder> data;
//
//   factory PurchaseOrderModelDriver.fromJson(Map<String, dynamic> json) => PurchaseOrderModelDriver(
//         code: json["code"],
//         message: json["message"],
//         data: List<PurchasOrder>.from(json["data"].map((x) => PurchasOrder.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "code": code,
//         "message": message,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }
//
// class PurchasOrder {
//   PurchasOrder({
//     this.id = 0,
//     this.street = "no-street",
//     this.pos = const [],
//   });
//
//   int id;
//   String street;
//   List<Po> pos;
//
//   factory PurchasOrder.fromJson(Map<String, dynamic> json) => PurchasOrder(
//         id: json["id"],
//         street: json["street"],
//         pos: List<Po>.from(json["pos"].map((x) => Po.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "street": street,
//         "pos": List<dynamic>.from(pos.map((x) => x.toJson())),
//       };
// }
//
// class Po {
//   Po({
//     this.id = 0,
//     this.poNumber = "no-poNumber",
//     this.poStatus = "no-poStatus",
//     this.createdDate = "no-createdDate",
//     this.poTo,
//     this.poBy,
//     this.poDeliverAddress,
//     this.customer,
//     this.deliveryMethod = "no-deliveryMethod",
//     this.paymentMethod,
//     required this.driver,
//     this.notes = "no-notes",
//     this.total = 0,
//   });
//
//   int id;
//   String poNumber;
//   String poStatus;
//   String createdDate;
//   PoByClass? poTo;
//   PoByClass? poBy;
//   PoDeliverAddress? poDeliverAddress;
//   Customer? customer;
//   String? deliveryMethod;
//   PaymentMethod? paymentMethod;
//   Driver? driver;
//   String? notes;
//   int total;
//
//   factory Po.fromJson(Map<String, dynamic> json) {
//     var poStatus = json["po_status"].toString();
//     poStatus = poStatus[0].toUpperCase() + poStatus.substring(1);
//     return Po(
//       id: json["id"],
//       poNumber: json["po_number"],
//       poStatus: poStatus,
//       createdDate: json["created_date"],
//       poTo: json["po_to"] == null ? null : PoByClass.fromJson(json["po_to"]),
//       poBy: json["po_by"] == null ? null : PoByClass.fromJson(json["po_by"]),
//       poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromJson(json["po_deliver_address"]),
//       customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
//       deliveryMethod: json["delivery_method"],
//       paymentMethod: json["payment_method"] == null ? null : PaymentMethod.fromJson(json["payment_method"]),
//       driver: json["payment_method"] == null ? null : Driver.fromJson(json["driver"]),
//       notes: json["notes"],
//       total: json["total"],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "po_number": poNumber,
//         "po_status": poStatus,
//         "created_date": createdDate,
//         "po_to": poTo?.toJson(),
//         "po_by": poBy?.toJson(),
//         "po_deliver_address": poDeliverAddress?.toJson(),
//         "customer": customer?.toJson(),
//         "delivery_method": deliveryMethod,
//         "payment_method": paymentMethod?.toJson(),
//         "driver": driver,
//         "notes": notes,
//         "total": total,
//       };
// }
//
// class Customer {
//   Customer({
//     this.id = 0,
//     this.companyNameKh = "no-companyNameKh",
//     this.companyNameEn = "no-companyNameEn",
//   });
//
//   int id;
//   String companyNameKh;
//   String companyNameEn;
//
//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
//         id: json["id"],
//         companyNameKh: json["company_name_kh"],
//         companyNameEn: json["company_name_en"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "company_name_kh": companyNameKh,
//         "company_name_en": companyNameEn,
//       };
// }
//
// class Driver {
//   Driver({
//     this.id = 0,
//     this.name = "no-name",
//     this.email = "no-email",
//     this.phone = "no-phone",
//     this.emailVerifiedAt = "no-emailVerifiedAt",
//     this.avatar = "no-avatar",
//     this.status = "no-status",
//     required this.createdAt,
//     required this.updatedAt,
//     this.departmentId = "no-departmentId",
//     this.text = "no-text",
//     this.avatarUrl = "no-avatarUrl",
//     this.roleName = "no-roleName",
//   });
//
//   int id;
//   String name;
//   String email;
//   String phone;
//   String? emailVerifiedAt;
//   String avatar;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String? departmentId;
//   String text;
//   String avatarUrl;
//   String roleName;
//
//   factory Driver.fromJson(Map<String, dynamic> json) => Driver(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         phone: json["phone"],
//         emailVerifiedAt: json["email_verified_at"],
//         avatar: json["avatar"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         departmentId: json["department_id"],
//         text: json["text"],
//         avatarUrl: json["avatar_url"],
//         roleName: json["role_name"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "email_verified_at": emailVerifiedAt,
//         "avatar": avatar,
//         "status": status,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "department_id": departmentId,
//         "text": text,
//         "avatar_url": avatarUrl,
//         "role_name": roleName,
//       };
// }
//
// class PaymentMethod {
//   PaymentMethod({
//     this.id = 0,
//     this.name = "no-name",
//   });
//
//   int id;
//   String name;
//
//   factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
//         id: json["id"],
//         name: json["name"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//       };
// }
//
// class PoByClass {
//   PoByClass({
//     this.id = 0,
//     this.contactName = "no-contactName",
//     this.idCard = "no-idCard",
//     this.contactPhone1 = "no-contactPhone1",
//     this.contactPhone2 = "no-contactPhone2",
//     this.email = "no-email",
//     this.position,
//     this.isMain = 0,
//   });
//
//   int id;
//   String contactName;
//   String? idCard;
//   String contactPhone1;
//   String? contactPhone2;
//   String? email;
//   PaymentMethod? position;
//   int isMain;
//
//   factory PoByClass.fromJson(Map<String, dynamic> json) => PoByClass(
//         id: json["id"],
//         contactName: json["contact_name"],
//         idCard: json["id_card"],
//         contactPhone1: json["contact_phone1"],
//         contactPhone2: json["contact_phone2"],
//         email: json["email"],
//         position: json["position"] == null ? null : PaymentMethod.fromJson(json["position"]),
//         isMain: json["is_main"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "contact_name": contactName,
//         "id_card": idCard,
//         "contact_phone1": contactPhone1,
//         "contact_phone2": contactPhone2,
//         "email": email,
//         "position": position?.toJson(),
//         "is_main": isMain,
//       };
// }
//
// class PoDeliverAddress {
//   PoDeliverAddress({
//     this.id = 0,
//     this.homeAddress = "no-homeAddress",
//     this.street = "no-street",
//     this.sangkat,
//     this.khan,
//     required this.province,
//     this.log = "no-log",
//     this.lat = "no-lat",
//     this.isMain = 0,
//     this.type = 'no-type',
//   });
//
//   int id;
//   String homeAddress;
//   String street;
//   PaymentMethod? sangkat;
//   PaymentMethod? khan;
//   PaymentMethod province;
//   String log;
//   String lat;
//   int isMain;
//   String type;
//
//   factory PoDeliverAddress.fromJson(Map<String, dynamic> json) => PoDeliverAddress(
//         id: json["id"],
//         homeAddress: json["home_address"],
//         street: json["street"],
//         sangkat: json["sangkat"] == null ? null : PaymentMethod.fromJson(json["sangkat"]),
//         khan: json["khan"] == null ? null : PaymentMethod.fromJson(json["khan"]),
//         province: PaymentMethod.fromJson(json["province"]),
//         log: json["log"],
//         lat: json["lat"],
//         isMain: json["is_main"],
//         type: json["type"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "home_address": homeAddress,
//         "street": street,
//         "sangkat": sangkat,
//         "khan": khan,
//         "province": province.toJson(),
//         "log": log,
//         "lat": lat,
//         "is_main": isMain,
//         "type": type,
//       };
// }
// To parse this JSON data, do
//
//     final purchaseOrderModelDriver = purchaseOrderModelDriverFromMap(jsonString);
class PurchaseOrderModelDriver {
  int code;
  String message;
  List<PurchasOrder> data;

  PurchaseOrderModelDriver({
    this.code = 0,
    this.message = 'no-message',
    this.data = const [],
  });

  factory PurchaseOrderModelDriver.fromMap(Map<String, dynamic> json) => PurchaseOrderModelDriver(
    code: json["code"],
    message: json["message"],
    data: List<PurchasOrder>.from(json["data"].map((x) => PurchasOrder.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class PurchasOrder {
  int id;
  String street;
  List<Po> pos;

  PurchasOrder({
    this.id = 0,
    this.street = 'no-street',
    this.pos = const [],
  });

  factory PurchasOrder.fromMap(Map<String, dynamic> json) => PurchasOrder(
    id: json["id"],
    street: json["street"],
    pos: List<Po>.from(json["pos"].map((x) => Po.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "street": street,
    "pos": List<dynamic>.from(pos.map((x) => x.toMap())),
  };
}

class Po {
  int id;
  String poNumber;
  String poStatus;
  String createdDate;
  PoByClass? poTo;
  PoByClass? poBy;
  PoDeliverAddress? poDeliverAddress;
  Customer? customer;
  DeliveryMethod? deliveryMethod;
  DeliveryMethod? paymentMethod;
  String? driver;
  String? notes;
  int total;

  Po({
    this.id = 0,
    this.poNumber = 'no-poNumber',
    this.poStatus = 'no-poStatus',
    this.createdDate = 'no-createdDate',
    this.poTo,
    this.poBy,
    this.poDeliverAddress,
    this.customer,
    this.deliveryMethod,
    this.paymentMethod,
    this.driver,
    this.notes,
    required this.total,
  });

  factory Po.fromMap(Map<String, dynamic> json) => Po(
    id: json["id"],
    poNumber: json["po_number"],
    poStatus: json["po_status"],
    createdDate: json["created_date"],
    poTo: json["po_to"] == null ? null : PoByClass.fromMap(json["po_to"]),
    poBy: json["po_by"] == null ? null : PoByClass.fromMap(json["po_by"]),
    poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromMap(json["po_deliver_address"]),
    customer: json["customer"] == null ? null : Customer.fromMap(json["customer"]),
    deliveryMethod: json["delivery_method"] == null ? null : DeliveryMethod.fromMap(json["delivery_method"]),
    paymentMethod: json["payment_method"] == null ? null : DeliveryMethod.fromMap(json["payment_method"]),
    driver: json["driver"],
    notes: json["notes"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "po_number": poNumber,
    "po_status": poStatus,
    "created_date": createdDate,
    "po_to": poTo?.toMap(),
    "po_by": poBy?.toMap(),
    "po_deliver_address": poDeliverAddress?.toMap(),
    "customer": customer?.toMap(),
    "delivery_method": deliveryMethod?.toMap(),
    "payment_method": paymentMethod?.toMap(),
    "driver": driver,
    "notes": notes,
    "total": total,
  };
}

class Customer {
  int id;
  String companyNameKh;
  String companyNameEn;

  Customer({
    this.id = 0,
    this.companyNameKh = 'no-companyNameKh',
    this.companyNameEn = 'no-companyNameEn',
  });

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
    id: json["id"],
    companyNameKh: json["company_name_kh"],
    companyNameEn: json["company_name_en"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "company_name_kh": companyNameKh,
    "company_name_en": companyNameEn,
  };
}

class DeliveryMethod {
  int id;
  String name;

  DeliveryMethod({
    this.id = 0,
    this.name = 'no-name',
  });

  factory DeliveryMethod.fromMap(Map<String, dynamic> json) => DeliveryMethod(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}

class PoByClass {
  int id;
  String contactName;
  String? idCard;
  String contactPhone1;
  String? contactPhone2;
  String? email;
  DeliveryMethod? position;
  int isMain;

  PoByClass({
    this.id = 0,
    this.contactName = 'no-contactName',
    this.idCard,
    this.contactPhone1 = 'no-contactPhone1',
    this.contactPhone2,
    this.email,
    this.position,
    this.isMain = 0,
  });

  factory PoByClass.fromMap(Map<String, dynamic> json) => PoByClass(
    id: json["id"],
    contactName: json["contact_name"],
    idCard: json["id_card"],
    contactPhone1: json["contact_phone1"],
    contactPhone2: json["contact_phone2"],
    email: json["email"],
    position: json["position"] == null ? null : DeliveryMethod.fromMap(json["position"]),
    isMain: json["is_main"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "contact_name": contactName,
    "id_card": idCard,
    "contact_phone1": contactPhone1,
    "contact_phone2": contactPhone2,
    "email": email,
    "position": position?.toMap(),
    "is_main": isMain,
  };
}

class PoDeliverAddress {
  int id;
  String homeAddress;
  String street;
  DeliveryMethod? sangkat;
  DeliveryMethod? khan;
  DeliveryMethod province;
  String log;
  String lat;
  int isMain;
  String type;

  PoDeliverAddress({
    this.id = 0,
    this.homeAddress = 'no-homeAddress',
    this.street = 'no-street',
    this.sangkat,
    this.khan,
    required this.province,
    this.log = 'no-log',
    this.lat = 'no-lat',
    this.isMain = 0,
    this.type = 'no-type',
  });

  factory PoDeliverAddress.fromMap(Map<String, dynamic> json) => PoDeliverAddress(
    id: json["id"],
    homeAddress: json["home_address"],
    street: json["street"],
    sangkat: json["sangkat"] == null ? null : DeliveryMethod.fromMap(json["sangkat"]),
    khan: json["khan"] == null ? null : DeliveryMethod.fromMap(json["khan"]),
    province: DeliveryMethod.fromMap(json["province"]),
    log: json["log"],
    lat: json["lat"],
    isMain: json["is_main"],
    type: json["type"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "home_address": homeAddress,
    "street": street,
    "sangkat": sangkat?.toMap(),
    "khan": khan?.toMap(),
    "province": province.toMap(),
    "log": log,
    "lat": lat,
    "is_main": isMain,
    "type": type,
  };
}
