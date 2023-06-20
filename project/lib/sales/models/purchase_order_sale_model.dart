import 'dart:convert';

import 'package:equatable/equatable.dart';

PurchaseOrderSaleModel purchaseOrderSaleModelFromMap(String str) => PurchaseOrderSaleModel.fromMap(json.decode(str));

String purchaseOrderSaleModelToMap(PurchaseOrderSaleModel data) => json.encode(data.toMap());

class PurchaseOrderSaleModel {
  PurchaseOrderSaleModel({
    this.code = 0,
    this.message = 'no-message',
    this.data = const [],
  });

  int code;
  String message;
  List<Data> data;

  factory PurchaseOrderSaleModel.fromMap(Map<String, dynamic> json) => PurchaseOrderSaleModel(
        code: json["code"],
        message: json["message"],
        data: List<Data>.from(json["data"].map((x) => Data.fromMap(x))).toList(),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Data extends Equatable {
  const Data({
    this.id = 0,
    this.poNumber = 'no-poNumber',
    this.poStatus = 'no-poStatus',
    this.createdDate = 'no-createdDate',
    this.createdBy,
    required this.poTo,
    required this.poBy,
    this.poDeliverAddress,
    required this.customer,
    this.deliveryMethod,
    required this.paymentMethod,
    this.driver,
    this.notes,
    this.poFileUrl,
    this.poFile,
    this.progress,
    this.total = 0,
    required this.items,
  });

  final int id;
  final String poNumber;
  final String poStatus;
  final String createdDate;
  final CreatedBy? createdBy;
  final Po poTo;
  final Po poBy;
  final PoDeliverAddress? poDeliverAddress;
  final Customer customer;
  final DeliveryMethod? deliveryMethod;
  final DeliveryMethod? paymentMethod;
  final String? driver;
  final String? notes;
  final String? poFileUrl;
  final String? poFile;
  final Progress? progress;
  final int total;
  final List<Item> items;

  factory Data.fromMap(Map<String, dynamic> json) {
    var poStatus = json["po_status"].toString();
    poStatus = poStatus[0].toUpperCase() + poStatus.substring(1);
    return Data(
      id: json["id"],
      poNumber: json["po_number"],
      poStatus: poStatus,
      createdDate: json["created_date"],
      createdBy: json['created_by'] == null ? null : CreatedBy.fromJson(json['created_by']),
      poTo: Po.fromMap(json["po_to"]),
      poBy: Po.fromMap(json["po_by"]),
      poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromMap(json["po_deliver_address"]),
      customer: Customer.fromMap(json["customer"]),
      deliveryMethod: json["delivery_method"] == null ? null : DeliveryMethod.fromMap(json["delivery_method"]),
      paymentMethod: json["payment_method"] == null ? null : DeliveryMethod.fromMap(json["payment_method"]),
      driver: json["driver"],
      notes: json["notes"],
      poFileUrl: json["po_file_url"],
      poFile: json["po_file"],
      progress: json["progress"] != null ? Progress.fromMap(json["progress"]) : null,
      total: json["total"] == null ? 0 : int.parse(json['total'].toString()),
      items: json["items"] != null ? List<dynamic>.from(json["items"]).map((item) => Item.fromJson(item)).toList() : [],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "po_number": poNumber,
        "po_status": poStatus,
        "created_date": createdDate,
        "po_to": poTo.toMap(),
        "po_by": poBy.toMap(),
        "po_deliver_address": poDeliverAddress?.toMap(),
        "customer": customer.toMap(),
        "delivery_method": deliveryMethod?.toMap(),
        "payment_method": paymentMethod?.toMap(),
        "driver": driver,
        "notes": notes,
        // "progress": progress?.toMap(),
        "total": total,
      };

  @override
  List<Object?> get props => [
        id,
        poNumber,
        poStatus,
        createdDate,
        createdBy,
        poTo,
        poBy,
        poDeliverAddress,
        customer,
        deliveryMethod,
        paymentMethod,
        driver,
        notes,
        // poFileUrl,
        // progress,
        total,
      ];
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

class DeliveryMethod {
  DeliveryMethod({
    this.id = 0,
    this.name = 'no-name',
  });

  int id;
  String name;

  factory DeliveryMethod.fromMap(Map<String, dynamic> json) => DeliveryMethod(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

class Po extends Equatable {
  const Po({
    this.id = 0,
    this.contactName = 'no-contactName',
    this.idCard,
    this.contactPhone1 = 'no-contactPhone1',
    this.contactPhone2,
    this.email,
    this.position,
    this.isMain = 0,
  });

  final int id;
  final String contactName;
  final String? idCard;
  final String contactPhone1;
  final String? contactPhone2;
  final String? email;
  final DeliveryMethod? position;
  final int isMain;

  factory Po.fromMap(Map<String, dynamic> json) => Po(
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

  @override
  List<Object?> get props => [
        id,
        contactName,
        idCard,
        contactPhone1,
        contactPhone2,
        email,
        position,
        isMain,
      ];
}

class PoDeliverAddress {
  PoDeliverAddress({
    this.id = 0,
    this.homeAddress = 'no-homeAddress',
    this.street = 'no-street',
    this.sangkat,
    required this.khan,
    required this.province,
    this.log = 'no-log',
    this.lat = 'no-lat',
    this.isMain = 0,
    this.type = 'no-type',
  });

  int id;
  String? homeAddress;
  String? street;
  DeliveryMethod? sangkat;
  DeliveryMethod? khan;
  DeliveryMethod? province;
  String? log;
  String? lat;
  int isMain;
  String type;

  factory PoDeliverAddress.fromMap(Map<String, dynamic> json) => PoDeliverAddress(
        id: json["id"],
        homeAddress: json["home_address"],
        street: json["street"],
        sangkat: json["sangkat"] == null ? null : DeliveryMethod.fromMap(json["sangkat"]),
        khan: json["khan"] == null ? null : DeliveryMethod.fromMap(json["khan"]),
        province: json["province"] == null ? null : DeliveryMethod.fromMap(json["province"]),
        log: json["log"].toString(),
        lat: json["lat"].toString(),
        isMain: json["is_main"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "home_address": homeAddress,
        "street": street,
        "sangkat": sangkat?.toMap(),
        "khan": khan?.toMap(),
        "province": province?.toMap(),
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

  ProgressStatus progressNew;
  ProgressStatus? inService;
  ProgressStatus? confirm;
  ProgressStatus? control;
  ProgressStatus? delivered;

  factory Progress.fromMap(Map<String, dynamic> json) => Progress(
        progressNew: ProgressStatus.fromMap(json["new"]),
        inService: json["in_service"] == null ? null : ProgressStatus.fromMap(json["in_service"]),
        confirm: json["confirm"] == null ? null : ProgressStatus.fromMap(json["confirm"]),
        control: json["control"] == null ? null : ProgressStatus.fromMap(json["control"]),
        delivered: json["delivered"] == null ? null : ProgressStatus.fromMap(json["delivered"]),
      );

  Map<String, dynamic> toMap() => {
        "new": progressNew.toMap(),
        "in_service": inService?.toMap(),
        "confirm": confirm?.toMap(),
        "control": control?.toMap(),
        "delivered": delivered?.toMap(),
      };
}

class ProgressStatus {
  ProgressStatus({
    this.status = 'no-status',
    this.date = 'no-date',
    this.by = 'no-by',
  });

  String status;
  String date;
  String by;

  factory ProgressStatus.fromMap(Map<String, dynamic> json) {
    var status = json["status"].toString();
    status = status[0].toUpperCase() + status.substring(1);
    return ProgressStatus(
      status: status,
      date: json["date"],
      by: json["by"],
    );
  }

  Map<String, dynamic> toMap() => {
        "status": status,
        "date": date,
        "by": by,
      };
}

class CreatedBy extends Equatable {
  const CreatedBy({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class Item extends Equatable {
  const Item({
    required this.id,
    required this.quantity,
    required this.price,
    required this.product,
    required this.package,
  });

  final int id;
  final int quantity;
  final double price;
  final Product product;
  final Package package;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"],
      quantity: int.tryParse(json["quantity"].toString()) ?? 0,
      price: double.tryParse(json["price"].toString()) ?? 0,
      product: Product.fromJson(json['product']),
      package: Package.fromJson(json["package"]),
    );
  }

  @override
  List<Object?> get props => [id, quantity, product, package];
}

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.stock,
  });

  final int id;
  final String name;
  final String desc;
  final int stock;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      desc: json["desc"],
      stock: json["stock"],
    );
  }

  @override
  List<Object?> get props => [id, name, desc, stock];
}

class Package extends Equatable {
  const Package({
    required this.id,
    required this.label,
  });

  final int id;
  final String label;

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json["id"],
      label: json["label"],
    );
  }

  @override
  List<Object?> get props => [id, label];
}
