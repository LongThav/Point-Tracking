class FrmDetailModel {
  FrmDetailModel({
    this.code = 0,
    this.message = 'no-message',
    required this.data,
  });

  int code;
  String message;
  FrmDetail data;

  factory FrmDetailModel.fromJson(Map<String, dynamic> json) => FrmDetailModel(
        code: json["code"],
        message: json["message"],
        data: FrmDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class FrmDetail {
  FrmDetail({
    this.paymentTerms = const [],
    this.positions = const [],
    this.provinces = const [],
    this.sangkat = const [],
    this.khan = const [],
  });

  List<PaymentTerms> paymentTerms;
  List<Positions> positions;
  List<Provinces> provinces;
  List<Sangkat> sangkat;
  List<Khan> khan;

  factory FrmDetail.fromJson(Map<String, dynamic> json) => FrmDetail(
        paymentTerms: List<PaymentTerms>.from(json["payment_terms"].map((x) => PaymentTerms.fromJson(x))),
        positions: List<Positions>.from(json["positions"].map((x) => Positions.fromJson(x))),
        provinces: List<Provinces>.from(json["provinces"].map((x) => Provinces.fromJson(x))),
        sangkat: List<Sangkat>.from(json["sangkat"].map((x) => Sangkat.fromJson(x))),
        khan: List<Khan>.from(json["khan"].map((x) => Khan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payment_terms": List<dynamic>.from(paymentTerms.map((x) => x.toJson())),
        "positions": List<dynamic>.from(positions.map((x) => x.toJson())),
        "provinces": List<dynamic>.from(provinces.map((x) => x.toJson())),
        "sangkat": List<dynamic>.from(sangkat.map((x) => x.toJson())),
        "khan": List<dynamic>.from(khan.map((x) => x.toJson())),
      };
}

class PaymentTerms {
  PaymentTerms({
    this.id = 0,
    this.name = "no-name",
  });

  int id;
  String name;

  factory PaymentTerms.fromJson(Map<String, dynamic> json) => PaymentTerms(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Positions {
  Positions({
    this.id = 0,
    this.name = "no-name",
  });

  int id;
  String name;

  factory Positions.fromJson(Map<String, dynamic> json) => Positions(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Provinces {
  Provinces({
    this.id = 0,
    this.name = "no-name",
  });

  int id;
  String name;

  factory Provinces.fromJson(Map<String, dynamic> json) => Provinces(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Sangkat {
  Sangkat({
    this.id = 0,
    this.name = "no-name",
  });

  int id;
  String name;

  factory Sangkat.fromJson(Map<String, dynamic> json) => Sangkat(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Khan {
  Khan({
    this.id = 0,
    this.name = "no-name",
  });

  int id;
  String name;

  factory Khan.fromJson(Map<String, dynamic> json) => Khan(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
