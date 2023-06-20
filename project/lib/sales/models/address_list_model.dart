import 'package:equatable/equatable.dart';

class AddressModel {
  AddressModel({
    this.code = 0,
    this.message = "no-message",
    this.data = const [],
  });

  int code;
  String message;
  List<Address> data;

  Address? getMainAddress() {
    Address? result;
    for (int i = 0; i < data.length; i++) {
      if (data[i].isMain == 1) {
        result = data[i];
        break;
      }
    }
    return result;
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        code: json["code"],
        message: json["message"],
        data: List<dynamic>.from(json["data"]).map((x) => Address.fromJson(x)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Address extends Equatable {
  const Address({
    this.id = 0,
    this.homeAddress = "no-homeAddress",
    required this.street,
    required this.sangkat,
    required this.khan,
    required this.province,
    this.lat,
    this.log,
    this.isMain = 0,
    this.type,
  });

  final int id;
  final String? homeAddress;
  final String? street;
  final MapAddress? sangkat;
  final MapAddress? khan;
  final MapAddress? province;
  final double? lat;
  final double? log;
  final int isMain;
  final String? type;

  String getFullAddress() {
    var fullOutPut = '';
    homeAddress != null ? fullOutPut += '$homeAddress, ' : '';
    street != null ? fullOutPut += '$street, ' : '';
    sangkat?.name != null ? fullOutPut += '${sangkat!.name}, ' : '';
    khan?.name != null ? fullOutPut += '${khan!.name}, ' : '';
    province?.name != null ? fullOutPut += '${province!.name} ' : '';
    if (fullOutPut[fullOutPut.length - 2] == ',') {
      fullOutPut = fullOutPut.substring(0, fullOutPut.length - 2);
    }
    return fullOutPut;
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    double? latFromApi;

    if (json['lat'] != null) {
      latFromApi = double.parse(json['lat'].toString());
    }
    double? logFromApi;
    if (json['log'] != null) {
      logFromApi = double.parse(json['log'].toString());
    }

    return Address(
      id: json["id"],
      homeAddress: json["home_address"],
      street: json["street"],
      sangkat: json["sangkat"] == null ? null : MapAddress.fromJson(json["sangkat"]),
      khan: json["khan"] == null ? null : MapAddress.fromJson(json["khan"]),
      province: json["province"] == null ? null : MapAddress.fromJson(json["province"]),
      lat: latFromApi,
      log: logFromApi,
      isMain: json["is_main"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "home_address": homeAddress,
        "street": street,
        "sangkat": sangkat?.toJson(),
        "khan": khan?.toJson(),
        "province": province?.toJson(),
        "log": log,
        "lat": lat,
        "is_main": isMain,
        "type": type,
      };

  @override
  List<Object?> get props => [
        id,
        homeAddress,
        street,
        sangkat,
        khan,
        province,
        log,
        lat,
        isMain,
        type,
      ];
}

class MapAddress extends Equatable {
  const MapAddress({
    this.id = 0,
    this.name = "no-name",
  });

  final int id;
  final String? name;

  factory MapAddress.fromJson(Map<String, dynamic> json) => MapAddress(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [id, name];
}
