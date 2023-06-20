class ContactModel {
  ContactModel({
    this.code = 0,
    this.message = "no-message",
    this.data = const [],
  });

  int code;
  String message;
  List<ContactM> data;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        code: json["code"],
        message: json["message"],
        data: List<ContactM>.from(json["data"].map((x) => ContactM.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ContactM {
  ContactM({
    this.id = 0,
    this.contactName = "no-contactName",
    this.idCard = "no-idCard",
    this.contactPhone1 = "no-contactPhone1",
    this.contactPhone2 = "no-contactPhone2",
    this.email = "no-email",
    this.position,
  });

  int id;
  String contactName;
  String? idCard;
  String contactPhone1;
  String? contactPhone2;
  String? email;
  Position? position;

  factory ContactM.fromJson(Map<String, dynamic> json) => ContactM(
        id: json["id"],
        contactName: json["contact_name"],
        idCard: json["id_card"],
        contactPhone1: json["contact_phone1"],
        contactPhone2: json["contact_phone2"],
        email: json["email"],
        position: json["position"] == null ? null : Position.fromJson(json["position"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact_name": contactName,
        "id_card": idCard,
        "contact_phone1": contactPhone1,
        "contact_phone2": contactPhone2,
        "email": email,
        "position": position?.toJson(),
      };
}

class Position {
  Position({
    this.id = 0,
    this.name = "no-name",
  });

  int id;
  String name;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
