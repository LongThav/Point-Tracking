// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class ProductModelList extends Equatable {
  ProductModelList({
    this.code = 0,
    this.message = "no-message",
    this.totalItem = 0,
    this.subTotal = 0,
    this.data = const [],
  });

  final int code;
  final String message;
  int totalItem;
  double subTotal;
  List<Data> data;

  factory ProductModelList.fromJson(Map<String, dynamic> json) {
    return ProductModelList(
      code: json["code"],
      message: json["message"],
      totalItem: 1,
      subTotal: 0,
      data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [code, message, data];
}

class Data extends Equatable {
  Data({
    this.id = 0,
    this.name = "no-name",
    this.notes = "no-notes",
    this.thumbUrl = "no-thumbUrl",
    this.packages = const [],
    this.price = 0,
    this.stock = 0,
    this.total = 0,
    this.quantity = 1,
    this.isSelect = false,
    this.isPOCartSelect = false,
    this.isClickable = true,
  });

  int id;
  String name;
  String notes;
  String thumbUrl;
  List<Package> packages;
  double price;
  int stock;
  double total;
  int quantity;
  bool isSelect;
  bool isPOCartSelect;
  bool isClickable;

  factory Data.fromJson(Map<String, dynamic> json) {
    double price = json["price"] == null ? 0 : double.parse(json["price"]);
    return Data(
      id: json["id"],
      name: json["name"],
      notes: json["notes"] ?? '',
      thumbUrl: json["thumb_url"] ?? '',
      packages: json["packages"] == null ? [] : List<Package>.from(json["packages"].map((x) => Package.fromJson(x))),
      price: price,
      stock: json["stock"] ?? 0,
      total: price,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "notes": notes,
        "thumb_url": thumbUrl,
        "packages": List<dynamic>.from(packages.map((x) => x.toJson())),
        "stock": stock,
        "price": price,
      };

  Map<String, String> getPOPostData() {
    return {
      "product_id": id.toString(),
      "quantity": quantity.toString(),
      "product_package_id": packages.firstWhere((package) => package.isDefault == 1).id.toString(),
      "price": price.toString(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        notes,
        thumbUrl,
        packages,
        price,
        stock,
        total,
        quantity,
        isSelect,
        isPOCartSelect,
      ];

  Data copy({
    required int id,
    String name = '',
    String notes = '',
    String thumbUrl = '',
    List<Package> packages = const [],
    double price = 0,
    int stock = 0,
    double total = 0,
    int quantity = 1,
    bool isSelect = false,
    bool isPOCartSelect = false,
  }) =>
      Data(
        id: this.id,
        name: this.name,
        notes: this.notes,
        stock: this.stock,
        total: this.total,
        price: this.price,
        thumbUrl: this.thumbUrl,
        packages: this.packages,
        isSelect: this.isSelect,
        isPOCartSelect: this.isPOCartSelect,
      );
}

class Package extends Equatable {
  Package({
    this.id = 0,
    this.packageSet = "no-packageSet",
    this.value = 0,
    this.unit = "no-unit",
    this.isDefault = 0,
    this.stock = 0,
    this.label = "",
  });

  final int id;
  final int stock;
  final String packageSet;
  final int? value;
  final String unit;
  int isDefault;
  final String? label;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        packageSet: json["set"],
        value: json["value"],
        unit: json["unit"],
        stock: json['stock'],
        isDefault: json["is_default"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "set": packageSet,
        "value": value,
        "unit": unit,
        "stock": stock,
        "is_default": isDefault,
      };

  @override
  List<Object?> get props => [id, packageSet, value, unit, stock, isDefault];
}

class Packaging extends Equatable {
  const Packaging({
    this.id = 0,
    this.purpleSet = 0,
    this.value = 0,
    this.unit = 0,
    this.isDefault = 0,
    this.productId = 0,
    this.createdBy = "no-createdBy",
    this.updatedBy = "no-updatedBy",
    required this.createdAt,
    required this.updatedAt,
    required this.packagingUnit,
    required this.packagingSet,
  });

  final int id;
  final int? purpleSet;
  final int? value;
  final int? unit;
  final int isDefault;
  final int productId;
  final String? createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PackagingSetClass? packagingUnit;
  final PackagingSetClass? packagingSet;

  factory Packaging.fromJson(Map<String, dynamic> json) => Packaging(
        id: json["id"],
        purpleSet: json["set"],
        value: json["value"],
        unit: json["unit"],
        isDefault: json["is_default"],
        productId: json["product_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        packagingUnit: json["packaging_unit"] == null ? null : PackagingSetClass.fromJson(json["packaging_unit"]),
        packagingSet: json["packaging_set"] == null ? null : PackagingSetClass.fromJson(json["packaging_set"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "set": purpleSet,
        "value": value,
        "unit": unit,
        "is_default": isDefault,
        "product_id": productId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "packaging_unit": packagingUnit?.toJson(),
        "packaging_set": packagingSet?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        purpleSet,
        value,
        unit,
        isDefault,
        productId,
        createdAt,
        updatedBy,
        createdAt,
        updatedAt,
        packagingUnit,
        packagingSet,
      ];
}

class PackagingSetClass {
  PackagingSetClass({
    this.id = 0,
    this.name = "no-name",
    this.createdBy = 0,
    this.updatedBy = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  int createdBy;
  int? updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory PackagingSetClass.fromJson(Map<String, dynamic> json) => PackagingSetClass(
        id: json["id"],
        name: json["name"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
