// class PurchaseOrderModelController {
//   PurchaseOrderModelController({
//     this.code = 0,
//     this.message = 'no-message',
//     this.data = const [],
//   });
//
//   int code;
//   String message;
//   List<PurchasOrderController> data;
//
//   factory PurchaseOrderModelController.fromMap(Map<String, dynamic> json) => PurchaseOrderModelController(
//         code: json["code"],
//         message: json["message"],
//         data: List<PurchasOrderController>.from(json["data"].map((x) => PurchasOrderController.fromMap(x))),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "code": code,
//         "message": message,
//         "data": List<dynamic>.from(data.map((x) => x.toMap())),
//       };
// }
//
// class PurchasOrderController {
//   PurchasOrderController({
//     this.id = 0,
//     this.street = 'no-street',
//     this.pos = const [],
//   });
//
//   int id;
//   String street;
//   List<Po> pos;
//
//   factory PurchasOrderController.fromMap(Map<String, dynamic> json) => PurchasOrderController(
//         id: json["id"],
//         street: json["street"],
//         pos: List<Po>.from(json["pos"].map((x) => Po.fromMap(x))),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "street": street,
//         "pos": List<dynamic>.from(pos.map((x) => x.toMap())),
//       };
// }
//
// class Po {
//   Po({
//     this.id = 0,
//     this.poNumber = 'no-poNumber',
//     this.poStatus = 'no-poStatus',
//     this.createdDate = 'no-createdDate',
//     required this.createdBy,
//     this.poTo,
//     this.poBy,
//     this.poDeliverAddress,
//     this.customer,
//     this.deliveryMethod = 'no-deliveryMethod',
//     this.paymentMethod,
//     this.driver,
//     this.notes = 'no-notes',
//     this.poFileUrl = "no-poFileUrl",
//     this.poFile = "no-poFile",
//     this.items = const [],
//   });
//
//   int id;
//   String poNumber;
//   String poStatus;
//   String createdDate;
//   CreatedBy? createdBy;
//   PoByClass? poTo;
//   PoByClass? poBy;
//   PoDeliverAddress? poDeliverAddress;
//   Customer? customer;
//   String? deliveryMethod;
//   PaymentMethod? paymentMethod;
//   Driver? driver;
//   String? notes;
//   String poFileUrl;
//   String? poFile;
//   List<Item> items;
//
//   factory Po.fromMap(Map<String, dynamic> json) {
//     var poStatus = json["po_status"].toString();
//     poStatus = poStatus[0].toUpperCase() + poStatus.substring(1);
//     return Po(
//       id: json["id"],
//       poNumber: json["po_number"],
//       poStatus: poStatus,
//       createdDate: json["created_date"],
//       createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
//       poTo: json["po_to"] == null ? null : PoByClass.fromMap(json["po_to"]),
//       poBy: json["po_by"] == null ? null : PoByClass.fromMap(json["po_by"]),
//       poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromMap(json["po_deliver_address"]),
//       customer: json["customer"] == null ? null : Customer.fromMap(json["customer"]),
//       deliveryMethod: json["delivery_method"] ?? "",
//       paymentMethod: json["payment_method"] == null ? null : PaymentMethod.fromMap(json["payment_method"]),
//       driver: json["driver"] == null ? null : Driver.fromMap(json["driver"]),
//       notes: json["notes"] ?? "",
//       poFileUrl: json["po_file_url"],
//       poFile: json["po_file"],
//       items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
//     );
//   }
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "po_number": poNumber,
//         "po_status": poStatus,
//         "created_date": createdDate,
//         "created_by": createdBy?.toJson(),
//         "po_to": poTo?.toMap(),
//         "po_by": poBy?.toMap(),
//         "po_deliver_address": poDeliverAddress?.toMap(),
//         "customer": customer?.toMap(),
//         "delivery_method": deliveryMethod,
//         "payment_method": paymentMethod?.toMap(),
//         "driver": driver?.toMap(),
//         "notes": notes,
//         "po_file_url": poFileUrl,
//         "po_file": poFile,
//         "items": List<dynamic>.from(items.map((x) => x.toMap())),
//       };
// }
//
// class CreatedBy {
//   CreatedBy({
//     this.id = 0,
//     this.name = "no-name",
//   });
//
//   int id;
//   String name;
//
//   factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
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
// class Customer {
//   Customer({
//     this.id = 0,
//     this.companyNameKh = 'no-companyNameKh',
//     this.companyNameEn = 'no-companyNameEn',
//   });
//
//   int id;
//   String companyNameKh;
//   String companyNameEn;
//
//   factory Customer.fromMap(Map<String, dynamic> json) => Customer(
//         id: json["id"],
//         companyNameKh: json["company_name_kh"],
//         companyNameEn: json["company_name_en"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "company_name_kh": companyNameKh,
//         "company_name_en": companyNameEn,
//       };
// }
//
// class Driver {
//   Driver({
//     this.id = 0,
//     this.name = 'no-name',
//     this.email = 'no-email',
//     this.phone = 'no-phone',
//     this.emailVerifiedAt = 'no-emailVerifiedAt',
//     this.avatar = 'no-avatar',
//     this.status = 'no-status',
//     this.createdAt = 'no-createdAt',
//     this.updatedAt = 'no-updatedAt',
//     this.departmentId = 'no-departmentId',
//     this.text = 'no-text',
//     this.avatarUrl = 'no-avatarUrl',
//     this.roleName = 'no-roleName',
//   });
//
//   int id;
//   String name;
//   String email;
//   String phone;
//   String? emailVerifiedAt;
//   String avatar;
//   String status;
//   String createdAt;
//   String updatedAt;
//   String? departmentId;
//   String text;
//   String avatarUrl;
//   String roleName;
//
//   factory Driver.fromMap(Map<String, dynamic> json) => Driver(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         phone: json["phone"],
//         emailVerifiedAt: json["email_verified_at"],
//         avatar: json["avatar"],
//         status: json["status"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         departmentId: json["department_id"],
//         text: json["text"],
//         avatarUrl: json["avatar_url"],
//         roleName: json["role_name"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "email_verified_at": emailVerifiedAt,
//         "avatar": avatar,
//         "status": status,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "department_id": departmentId,
//         "text": text,
//         "avatar_url": avatarUrl,
//         "role_name": roleName,
//       };
// }
//
// class Item {
//   Item({
//     this.id = 0,
//     required this.product,
//     required this.package,
//   });
//
//   int id;
//   PaymentMethod product;
//   Package package;
//
//   factory Item.fromMap(Map<String, dynamic> json) => Item(
//         id: json["id"],
//         product: PaymentMethod.fromMap(json["product"]),
//         package: Package.fromMap(json["package"]),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "product": product.toMap(),
//         "package": package.toMap(),
//       };
// }
//
// class Package {
//   Package({
//     this.id = 0,
//     this.label = 'no-label',
//   });
//
//   int id;
//   String label;
//
//   factory Package.fromMap(Map<String, dynamic> json) => Package(
//         id: json["id"],
//         label: json["label"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "label": label,
//       };
// }
//
// class PaymentMethod {
//   PaymentMethod({
//     this.id = 0,
//     this.name = 'no-name',
//   });
//
//   int id;
//   String name;
//
//   factory PaymentMethod.fromMap(Map<String, dynamic> json) => PaymentMethod(
//         id: json["id"],
//         name: json["name"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "name": name,
//       };
// }
//
// class PoByClass {
//   PoByClass({
//     this.id = 0,
//     this.contactName = 'no-contactName',
//     this.idCard = 'no-idCard',
//     this.contactPhone1 = 'no-contactPhone1',
//     this.contactPhone2 = 'no-contactPhone2',
//     this.email = 'no-email',
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
//   factory PoByClass.fromMap(Map<String, dynamic> json) => PoByClass(
//         id: json["id"],
//         contactName: json["contact_name"],
//         idCard: json["id_card"],
//         contactPhone1: json["contact_phone1"],
//         contactPhone2: json["contact_phone2"],
//         email: json["email"],
//         position: json["position"] == null ? null : PaymentMethod.fromMap(json["position"]),
//         isMain: json["is_main"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "contact_name": contactName,
//         "id_card": idCard,
//         "contact_phone1": contactPhone1,
//         "contact_phone2": contactPhone2,
//         "email": email,
//         "position": position?.toMap(),
//         "is_main": isMain,
//       };
// }
//
// class PoDeliverAddress {
//   PoDeliverAddress({
//     this.id = 0,
//     this.homeAddress = 'no-homeAddress',
//     this.street = 'no-street',
//     this.sangkat = 'no-sangkat',
//     this.khan = 'no-khan',
//     required this.province,
//     this.log = 'no-log',
//     this.lat = 'no-lat',
//     this.isMain = 0,
//   });
//
//   int id;
//   String homeAddress;
//   String street;
//   String? sangkat;
//   String? khan;
//   PaymentMethod? province;
//   String? log;
//   String? lat;
//   int isMain;
//
//   factory PoDeliverAddress.fromMap(Map<String, dynamic> json) => PoDeliverAddress(
//         id: json["id"],
//         homeAddress: json["home_address"],
//         street: json["street"],
//         sangkat: json["sangkat"],
//         khan: json["khan"],
//         province: PaymentMethod.fromMap(json["province"]),
//         log: json["log"],
//         lat: json["lat"],
//         isMain: json["is_main"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "home_address": homeAddress,
//         "street": street,
//         "sangkat": sangkat,
//         "khan": khan,
//         "province": province!.toMap(),
//         "log": log,
//         "lat": lat,
//         "is_main": isMain,
//       };
// }
// To parse this JSON data, do
//
//     final purchaseOrderModelController = purchaseOrderModelControllerFromMap(jsonString);

class PurchaseOrderModelController {
  int code;
  String message;
  List<PurchasOrderController> data;

  PurchaseOrderModelController({
    this.code = 0,
    this.message = 'no-message',
    this.data = const [],
  });

  factory PurchaseOrderModelController.fromMap(Map<String, dynamic> json) => PurchaseOrderModelController(
    code: json["code"],
    message: json["message"],
    data: List<PurchasOrderController>.from(json["data"].map((x) => PurchasOrderController.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class PurchasOrderController {
  int id;
  String street;
  List<Po> pos;

  PurchasOrderController({
    this.id = 0,
    this.street = 'no-street',
    this.pos = const [],
  });

  factory PurchasOrderController.fromMap(Map<String, dynamic> json) => PurchasOrderController(
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
  CreatedBy createdBy;
  PoByClass poTo;
  PoByClass poBy;
  PoDeliverAddress? poDeliverAddress;
  Customer customer;
  CreatedBy? deliveryMethod;
  CreatedBy paymentMethod;
  String? driver;
  String? notes;
  String poFileUrl;
  String poFile;
  List<Item> items;
  Progress progress;
  int total;

  Po({
    this.id = 0,
    this.poNumber = 'no-poNumber',
    this.poStatus = 'no-poStatus',
    this.createdDate = 'no-createdDate',
    required this.createdBy,
    required this.poTo,
    required this.poBy,
    this.poDeliverAddress,
    required this.customer,
    this.deliveryMethod,
    required this.paymentMethod,
    this.driver,
    this.notes,
    this.poFileUrl = 'no-poFileUrl',
    this.poFile = 'no-poFile',
    this.items = const [],
    required this.progress,
    this.total = 0,
  });

  factory Po.fromMap(Map<String, dynamic> json) => Po(
    id: json["id"],
    poNumber: json["po_number"],
    poStatus: json["po_status"],
    createdDate: json["created_date"],
    createdBy: CreatedBy.fromMap(json["created_by"]),
    poTo: PoByClass.fromMap(json["po_to"]),
    poBy: PoByClass.fromMap(json["po_by"]),
    poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromMap(json["po_deliver_address"]),
    customer: Customer.fromMap(json["customer"]),
    deliveryMethod: json["delivery_method"] == null ? null : CreatedBy.fromMap(json["delivery_method"]),
    paymentMethod: CreatedBy.fromMap(json["payment_method"]),
    driver: json["driver"],
    notes: json["notes"],
    poFileUrl: json["po_file_url"],
    poFile: json["po_file"],
    items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
    progress: Progress.fromMap(json["progress"]),
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "po_number": poNumber,
    "po_status": poStatus,
    "created_date": createdDate,
    "created_by": createdBy.toMap(),
    "po_to": poTo.toMap(),
    "po_by": poBy.toMap(),
    "po_deliver_address": poDeliverAddress?.toMap(),
    "customer": customer.toMap(),
    "delivery_method": deliveryMethod?.toMap(),
    "payment_method": paymentMethod.toMap(),
    "driver": driver,
    "notes": notes,
    "po_file_url": poFileUrl,
    "po_file": poFile,
    "items": List<dynamic>.from(items.map((x) => x.toMap())),
    "progress": progress.toMap(),
    "total": total,
  };
}

class CreatedBy {
  int id;
  String name;

  CreatedBy({
    this.id = 0,
    this.name = 'no-name',
  });

  factory CreatedBy.fromMap(Map<String, dynamic> json) => CreatedBy(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
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

class Item {
  int id;
  String quantity;
  Product product;
  Package package;

  Item({
    this.id = 0,
    this.quantity = 'no-quantity',
    required this.product,
    required this.package,
  });

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    id: json["id"],
    quantity: json["quantity"],
    product: Product.fromMap(json["product"]),
    package: Package.fromMap(json["package"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "quantity": quantity,
    "product": product.toMap(),
    "package": package.toMap(),
  };
}

class Package {
  int id;
  String label;

  Package({
    this.id = 0,
    this.label = 'no-label',
  });

  factory Package.fromMap(Map<String, dynamic> json) => Package(
    id: json["id"],
    label: json["label"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "label": label,
  };
}

class Product {
  int id;
  String name;
  String desc;
  int stock;

  Product({
    this.id = 0,
    this.name = 'no-name',
    this.desc = 'no-desc',
    this.stock = 0,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    stock: json["stock"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "desc": desc,
    "stock": stock,
  };
}

class PoByClass {
  int id;
  String contactName;
  String? idCard;
  String contactPhone1;
  String? contactPhone2;
  String? email;
  CreatedBy position;
  int isMain;

  PoByClass({
    this.id = 0,
    this.contactName = 'no-contactName',
    this.idCard,
    this.contactPhone1 = 'no-contactPhone1',
    this.contactPhone2,
    this.email,
    required this.position,
    this.isMain = 0,
  });

  factory PoByClass.fromMap(Map<String, dynamic> json) => PoByClass(
    id: json["id"],
    contactName: json["contact_name"],
    idCard: json["id_card"],
    contactPhone1: json["contact_phone1"],
    contactPhone2: json["contact_phone2"],
    email: json["email"],
    position: CreatedBy.fromMap(json["position"]),
    isMain: json["is_main"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "contact_name": contactName,
    "id_card": idCard,
    "contact_phone1": contactPhone1,
    "contact_phone2": contactPhone2,
    "email": email,
    "position": position.toMap(),
    "is_main": isMain,
  };
}

class PoDeliverAddress {
  int id;
  String homeAddress;
  String street;
  CreatedBy sangkat;
  CreatedBy khan;
  CreatedBy province;
  String log;
  String lat;
  int isMain;
  String type;

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

  factory PoDeliverAddress.fromMap(Map<String, dynamic> json) => PoDeliverAddress(
    id: json["id"],
    homeAddress: json["home_address"],
    street: json["street"],
    sangkat: CreatedBy.fromMap(json["sangkat"]),
    khan: CreatedBy.fromMap(json["khan"]),
    province: CreatedBy.fromMap(json["province"]),
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
  New progressNew;
  New? inService;
  New? confirm;
  New? control;
  New? delivered;

  Progress({
    required this.progressNew,
    this.inService,
    this.confirm,
    this.control,
    this.delivered,
  });

  factory Progress.fromMap(Map<String, dynamic> json) => Progress(
    progressNew: New.fromMap(json["new"]),
    inService: json["in_service"] == null ? null : New.fromMap(json["in_service"]),
    confirm: json["confirm"] == null ? null : New.fromMap(json["confirm"]),
    control: json["control"] == null ? null : New.fromMap(json["control"]),
    delivered: json["delivered"] == null ? null : New.fromMap(json["delivered"]),
  );

  Map<String, dynamic> toMap() => {
    "new": progressNew.toMap(),
    "in_service": inService?.toMap(),
    "confirm": confirm?.toMap(),
    "control": control?.toMap(),
    "delivered": delivered?.toMap(),
  };
}

class New {
  String status;
  String date;
  String by;

  New({
    this.status = 'no-status',
    this.date = 'no-date',
    this.by = 'no-by',
  });

  factory New.fromMap(Map<String, dynamic> json) => New(
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

