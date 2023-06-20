// To parse this JSON data, do
//
//     final ShowModel = ShowModelFromJson(jsonString);

import 'dart:convert';

ShowModel ShowModelFromJson(String str) => ShowModel.fromJson(json.decode(str));

String ShowModelToJson(ShowModel data) => json.encode(data.toJson());

class ShowModel {
  int code;
  String message;
  List<Data> data;

  ShowModel({
    this.code = 0,
    this.message = "no-message",
    this.data = const [],
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) => ShowModel(
        code: json["code"],
        message: json["message"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Data {
  int id;
  String poNumber;
  String poStatus;
  String createdDate;
  CreatedBy createdBy;
  Po poTo;
  Po poBy;
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

  Data({
    this.id = 0,
    this.poNumber = "no-poNumber",
    this.poStatus = "no-poStatus",
    this.createdDate = "no-createdDate",
    required this.createdBy,
    required this.poTo,
    required this.poBy,
    required this.poDeliverAddress,
    required this.customer,
    required this.deliveryMethod,
    required this.paymentMethod,
    this.driver = "no-driver",
    this.notes = "no-notes",
    this.poFileUrl = "no-poFileUrl",
    this.poFile = "no-poFile",
    this.items = const [],
    required this.progress,
    this.total = 0,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      poNumber: json["po_number"],
      poStatus: json["po_status"],
      createdDate: json["created_date"],
      createdBy: CreatedBy.fromJson(json["created_by"]),
      poTo: Po.fromJson(json["po_to"]),
      poBy: Po.fromJson(json["po_by"]),
      poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromJson(json["po_deliver_address"]),
      customer: Customer.fromJson(json["customer"]),
      deliveryMethod: json["delivery_method"] == null ? null : CreatedBy.fromJson(json["delivery_method"]),
      paymentMethod: CreatedBy.fromJson(json["payment_method"]),
      driver: json["driver"],
      notes: json["notes"],
      poFileUrl: json["po_file_url"],
      poFile: json["po_file"],
      items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      progress: Progress.fromJson(json["progress"]),
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "po_number": poNumber,
        "po_status": poStatus,
        "created_date": createdDate,
        "created_by": createdBy.toJson(),
        "po_to": poTo.toJson(),
        "po_by": poBy.toJson(),
        "po_deliver_address": poDeliverAddress,
        "customer": customer.toJson(),
        "delivery_method": deliveryMethod,
        "payment_method": paymentMethod.toJson(),
        "driver": driver,
        "notes": notes,
        "po_file_url": poFileUrl,
        "po_file": poFile,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "progress": progress.toJson(),
        "total": total,
      };
}

class CreatedBy {
  int id;
  String name;

  CreatedBy({
    this.id = 0,
    this.name = "no-name",
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
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
    this.companyNameKh = "no-companyNameKh",
    this.companyNameEn = "no-companyNameEn",
  });

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

class Item {
  int id;
  String quantity;
  Product product;
  Package package;

  Item({
    this.id = 0,
    this.quantity = "no-quantity",
    required this.product,
    required this.package,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        quantity: json["quantity"],
        product: Product.fromJson(json["product"]),
        package: Package.fromJson(json["package"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "product": product.toJson(),
        "package": package.toJson(),
      };
}

class Package {
  int id;
  String label;

  Package({
    this.id = 0,
    this.label = "no-label",
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
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
    this.name = "no-name",
    this.desc = "no-desc",
    this.stock = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "stock": stock,
      };
}

class Po {
  int id;
  String contactName;
  String? idCard;
  String contactPhone1;
  String? contactPhone2;
  String? email;
  CreatedBy? position;
  int isMain;

  Po({
    this.id = 0,
    this.contactName = "no-contactName",
    this.idCard = "no-idCard",
    this.contactPhone1 = "no-contactPhone1",
    this.contactPhone2 = "no-contactPhone2",
    this.email = "no-email",
    required this.position,
    this.isMain = 0,
  });

  factory Po.fromJson(Map<String, dynamic> json) => Po(
        id: json["id"],
        contactName: json["contact_name"],
        idCard: json["id_card"],
        contactPhone1: json["contact_phone1"],
        contactPhone2: json["contact_phone2"],
        email: json["email"],
        position: json["position"] == null ? null : CreatedBy.fromJson(json["position"]),
        isMain: json["is_main"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact_name": contactName,
        "id_card": idCard,
        "contact_phone1": contactPhone1,
        "contact_phone2": contactPhone2,
        "email": email,
        "position": position,
        "is_main": isMain,
      };
}

class Progress {
  ProgressStatus progressNew;
  ProgressStatus? inService;
  ProgressStatus? confirm;
  ProgressStatus? control;
  ProgressStatus? delivered;

  Progress({
    required this.progressNew,
    required this.inService,
    required this.confirm,
    required this.control,
    required this.delivered,
  });

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
        progressNew: ProgressStatus.fromJson(json["new"]),
        inService: json["in_service"] == null
            ? null
            : ProgressStatus.fromJson(
                json["in_service"],
              ),
        confirm: json["confirm"] == null
            ? null
            : ProgressStatus.fromJson(
                json["confirm"],
              ),
        control: json["control"] == null ? null : ProgressStatus.fromJson(json["control"]),
        delivered: json["delivered"] == null ? null : ProgressStatus.fromJson(json["delivered"]),
      );

  Map<String, dynamic> toJson() => {
        "new": progressNew.toJson(),
        "in_service": inService,
        "confirm": confirm,
        "control": control,
        "delivered": delivered,
      };
}

class ProgressStatus {
  String status;
  String date;
  String by;

  ProgressStatus({
    this.status = "no-status",
    this.date = "no-date",
    this.by = "no-by",
  });

  factory ProgressStatus.fromJson(Map<String, dynamic> json) {
    var status = json["status"].toString();
    status = status[0].toUpperCase() + status.substring(1);
    return ProgressStatus(
      status: status,
      date: json["date"],
      by: json["by"],
    );
  }
  Map<String, dynamic> toJson() => {
        "status": status,
        "date": date,
        "by": by,
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

  factory PoDeliverAddress.fromJson(Map<String, dynamic> json) => PoDeliverAddress(
        id: json["id"],
        homeAddress: json["home_address"],
        street: json["street"],
        sangkat: CreatedBy.fromJson(json["sangkat"]),
        khan: CreatedBy.fromJson(json["khan"]),
        province: CreatedBy.fromJson(json["province"]),
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
