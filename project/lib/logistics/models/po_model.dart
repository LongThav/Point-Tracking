import 'dart:convert';

PurchaseOrderModelLogistic purchaseOrderModelLogisticFromMap(String str) => PurchaseOrderModelLogistic.fromMap(json.decode(str));

String purchaseOrderModelLogisticToMap(PurchaseOrderModelLogistic data) => json.encode(data.toMap());

class PurchaseOrderModelLogistic {
  PurchaseOrderModelLogistic({
    this.code = 0,
    this.message = 'no-message',
    this.data = const [],
  });

  int code;
  String message;
  List<Data> data;

  factory PurchaseOrderModelLogistic.fromMap(Map<String, dynamic> json) => PurchaseOrderModelLogistic(
    code: json["code"],
    message: json["message"],
    data: List<Data>.from(json["data"].map((x) => Data.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class Data {
  Data({
    this.id = 0,
    this.poNumber = 'no-poNumber',
    this.poStatus = 'no-poStatus',
    this.createdDate = 'no-createdDate',
    required this.poTo,
    required this.poBy,
    required this.poDeliverAddress,
    required this.customer,
    this.deliveryMethod,
    required this.paymentMethod,
    this.driver,
    this.notes,
    this.total = 0,
    this.select = true,
  });

  int id;
  bool select;
  String poNumber;
  String poStatus;
  String createdDate;
  Po poTo;
  Po poBy;
  PoDeliverAddress? poDeliverAddress;
  Customer customer;
  PaymentMethod? deliveryMethod;
  PaymentMethod paymentMethod;
  String? driver;
  String? notes;
  int total;

  factory Data.fromMap(Map<String, dynamic> json) {
    var poStatus = json["po_status"].toString();
    poStatus = poStatus[0].toUpperCase() + poStatus.substring(1);
    return Data(
      id: json["id"],
      poNumber: json["po_number"],
      poStatus: poStatus,
      createdDate: json["created_date"],
      poTo: Po.fromMap(json["po_to"]),
      poBy: Po.fromMap(json["po_by"]),
      poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromMap(json["po_deliver_address"]),
      customer: Customer.fromMap(json["customer"]),
      deliveryMethod: json["delivery_method"] == null ? null : PaymentMethod.fromMap(json["delivery_method"]),
      paymentMethod: PaymentMethod.fromMap(json["payment_method"]),
      driver: json["driver"],
      notes: json["notes"],
      total: json["total"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "po_number": poNumber,
    "po_status": poStatus,
    "created_date": createdDate,
    "po_to": poTo.toMap(),
    "po_by": poBy.toMap(),
    // "po_deliver_address": poDeliverAddress?.toMap(),
    // "customer": customer.toMap(),
    // "delivery_method": deliveryMethod?.toMap(),
    // "payment_method": paymentMethod.toMap(),
    // "driver": driver,
    // "notes": notes,
    // "progress": progress.toMap(),
    // "total": total,
  };
}

class Customer {
  Customer({
    this.id = 0,
    this.companyNameKh = 'no-companyNameKh',
    this.companyNameEn = 'no-companyNameEn',
  });

  int id;
  String companyNameKh;
  String companyNameEn;

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

class PaymentMethod {
  PaymentMethod({
    this.id = 0,
    this.name = 'no-name',
  });

  int id;
  String name;

  factory PaymentMethod.fromMap(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}

class Po {
  Po({
    this.id = 0,
    this.contactName = 'no-contactName',
    this.idCard,
    this.contactPhone1 = 'no-contactPhone1',
    this.contactPhone2,
    this.email,
    required this.position,
    this.isMain = 0,
  });

  int id;
  String contactName;
  String? idCard;
  String contactPhone1;
  String? contactPhone2;
  String? email;
  PaymentMethod? position;
  int isMain;

  factory Po.fromMap(Map<String, dynamic> json) => Po(
    id: json["id"],
    contactName: json["contact_name"],
    idCard: json["id_card"],
    contactPhone1: json["contact_phone1"],
    contactPhone2: json["contact_phone2"],
    email: json["email"],
    position: json["position"] == null ? null : PaymentMethod.fromMap(json["position"]),
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
  PoDeliverAddress({
    this.id = 0,
    this.homeAddress = 'no-homeAddress',
    this.street = 'no-street',
    required this.sangkat,
    required this.khan,
    required this.province,
    this.log = 'no-log',
    this.lat = 'no-lat',
    this.isMain = 0,
    this.type = 'no-type',
  });

  int id;
  String homeAddress;
  String street;
  PaymentMethod sangkat;
  PaymentMethod khan;
  PaymentMethod province;
  String log;
  String lat;
  int isMain;
  String type;

  factory PoDeliverAddress.fromMap(Map<String, dynamic> json) => PoDeliverAddress(
    id: json["id"],
    homeAddress: json["home_address"],
    street: json["street"],
    sangkat: PaymentMethod.fromMap(json["sangkat"]),
    khan: PaymentMethod.fromMap(json["khan"]),
    province: PaymentMethod.fromMap(json["province"]),
    log: json["log"],
    lat: json["lat"],
    isMain: json["is_main"],
    type: json["type"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "home_address": homeAddress,
    "street": street,
    "sangkat": sangkat.toMap(),
    "khan": khan.toMap(),
    "province": province.toMap(),
    "log": log,
    "lat": lat,
    "is_main": isMain,
    "type": type,
  };
}

class Progress {
  Progress({
    required this.progressNew,
    this.inService,
    this.confirm,
    this.control,
    this.delivered,
  });

  InService progressNew;
  InService? inService;
  InService? confirm;
  String? control;
  String? delivered;

  factory Progress.fromMap(Map<String, dynamic> json) => Progress(
    progressNew: InService.fromMap(json["new"]),
    inService: json["in_service"] == null ? null : InService.fromMap(json["in_service"]),
    confirm: json["confirm"] == null ? null : InService.fromMap(json["confirm"]),
    control: json["control"],
    delivered: json["delivered"],
  );

  Map<String, dynamic> toMap() => {
    "new": progressNew.toMap(),
    "in_service": inService?.toMap(),
    "confirm": confirm?.toMap(),
    "control": control,
    "delivered": delivered,
  };
}

class InService {
  InService({
    this.status = 'no-status',
    this.date = 'no-date',
    this.by = 'no-by',
  });

  String status;
  String date;
  String by;

  factory InService.fromMap(Map<String, dynamic> json) => InService(
    status: json["status"],
    date: json["date"],
    by: json["by"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "date": date,
    "by": by,
  };
}
